//Operation Mode:
//1: ENC MODE
//0: DEC MODE
module aes_gcm_v3(
input iClk,
input iRstn,
	//control signals
input iInit,
input iNext,
input iEncdec,
output oReady,
	//data
input [0:95] iIV,
input iIV_valid,
input [0:255] iKey,
input iKey_valid,
input iKeylen,

input [0:127] iAad, //Additional Authentication Data and Length
input iAad_valid,
input iAad_last,

input [0:127] iBlock,
input iBlock_valid,
input iBlock_last,

input [0:127] iTag,	//DEC_MODE: compare with newly generated TAG
input iTag_valid,
	//output
output [0:127] oResult,
output oResult_valid,
output [0:127] oTag,
output oTag_valid,
output oAuthentic
);

//----------------------------------------------------------------
// Registers variables and enable.
//----------------------------------------------------------------

//ghash result register
reg [0:127] ghash_result_reg;
reg ghash_result_wen; //Todo change to wire
reg temp;
reg temp_wen; //Todo change to wire
reg ghash_result_dec_wen; //Todo change to wire

//hash key register
reg [0:127] hash_key_reg;
reg hash_key_wen; //Todo change to wire

//y0 register
reg [0:127] y0_reg;
reg y0_wen; //Todo change to wire

//delay iBlock_last
reg last_block;

//tag register
reg [0:127] tag_reg;

reg  [2:0] aes_gcm_ctrl_reg;
reg  [2:0] aes_gcm_ctrl_new; //Todo change to wire
//----------------------------------------------------------------
// Control signal
//----------------------------------------------------------------

//ghash
reg [1:0] ghash_input_signal; //Todo change to wire
wire [0:127] muxed_ghash_input1;
wire [0:127] muxed_ghash_input2;
wire [0:127] ghash_result;
reg ghash_next;
reg ghash_input_valid;
reg hash_key_valid;

//gctr
reg gctr_init; //Todo change to wire
reg gctr_hashkey_compute; //Todo change to wire
reg gctr_y0_compute; //Todo change to wire
wire [0:127] gctr_result;
wire gctr_result_valid;

//aes_gcm
reg aes_gcm_ready; //Todo change to wire
reg aes_gcm_tag_valid; //Todo change to wire
reg aes_gcm_result_valid;		//Todo change to wire

//----------------------------------------------------------------
// Instantiations.
//----------------------------------------------------------------

//GCTR_BLOCK_v2 contain AES_CORE with only encryption mode
gctr_block_v2 GCTR(
	//control signal
.iClk(iClk),
.iRstn(iRstn),
.iInit(gctr_init),
.iHashKey(gctr_hashkey_compute), 
.iY0(gctr_y0_compute),
	//data
.iIV(iIV),				
.iIV_valid(iIV_valid),	
.iKey(iKey),		
.iKey_valid(iKey_valid),	
.iKeylen(iKeylen),
.iBlock(iBlock), 
.iBlock_valid(iBlock_valid),
	//output: ciphertext, hashkey, y0
.oResult(gctr_result),						
.oResult_valid(gctr_result_valid)
);

//GHASH_BLOCK_v2 computes GF(2^128) in 128 clock cycles
ghash_block_v2 GHASH(
.iClk(iClk),
.iRstn(iRstn),
.iNext(ghash_next),
.iCtext(muxed_ghash_input2), 			//AAD or Cipher text
.iCtext_valid(ghash_input_valid),						//Todo:
.iY(ghash_result_reg), 					//previous ghash result
.iHashkey(hash_key_reg),				//hash key
.iHashkey_valid(hash_key_valid),						//Todo
.oY(ghash_result),						//new ghash result
.oY_valid(ghash_result_valid)								//Todo
);

//----------------------------------------------------------------
// Reg
//----------------------------------------------------------------

//BOTH MODE: store Hashkey
always @(posedge iClk) begin
	if(~iRstn)				hash_key_reg <= 128'd0;
	else if(hash_key_wen)	hash_key_reg <= gctr_result;  //Hashkey
	else					hash_key_reg <= hash_key_reg;
end

//DEC MODE: store Tag to compare with newly generated Tag
always @(posedge iClk) begin
	if(~iRstn)						tag_reg <= 128'd0;
	else if(iTag_valid)				tag_reg <= iTag;
	else							tag_reg <= tag_reg;
end

//BOTH MODE: store Ghash result
always @(posedge iClk) begin
	if(~iRstn)											ghash_result_reg <= 128'd0;
	else if(ghash_result_wen | ghash_result_dec_wen)	ghash_result_reg <= ghash_result; //CipherText
	else												ghash_result_reg <= ghash_result_reg;
end

//Temp: use for update ghash result wen when calculating tag in decipher mode
always @(posedge iClk) begin
	if(~iRstn | gctr_result_valid)	temp <= 1'b0;
	else if(temp_wen) temp <= 1'b1;
	else temp <= temp;
end

//State transition
always @(posedge iClk) begin
	if(~iRstn)		aes_gcm_ctrl_reg <= 3'd0;
	else if(iInit) 	aes_gcm_ctrl_reg <= aes_gcm_ctrl_new;
	else			aes_gcm_ctrl_reg <= aes_gcm_ctrl_reg;
end

//Last block
always @(posedge iClk) begin
	if(~iRstn)		last_block <= 1'b0;
	else			last_block <= iBlock_last;
end

//BOTH MODE: store Y0 value to XOR with last Ghash result to get the TAG
always @(posedge iClk) begin
	if(~iRstn)					y0_reg <= 128'd0;
	else if(y0_wen)				y0_reg <= gctr_result; //y0
	else						y0_reg <= y0_reg;
end
//----------------------------------------------------------------
// Mux connection, output of aes_gcm, and other signals
//----------------------------------------------------------------

assign muxed_ghash_input1 = (ghash_input_signal[0])? iAad : gctr_result;
assign muxed_ghash_input2 = (ghash_input_signal[1])? iBlock : muxed_ghash_input1;

assign oResult = gctr_result;
assign oResult_valid = aes_gcm_result_valid;
assign oTag = ghash_result ^ y0_reg;					
assign oTag_valid = aes_gcm_tag_valid;		
assign oReady = aes_gcm_ready;
assign oAuthentic = (~iEncdec & oTag_valid & (tag_reg == oTag));

// ----------------------------------------------------------------
// aes_gcm control 

// Control FSM for aes_gcm. Tasks:
// - Initialize
// - Calculate Hashkey
// - Compute AAD (optional)
// - Send plain text to gctr_block and wait for each cipher text
// ----------------------------------------------------------------

parameter IDLE = 3'b000;
parameter CAL_HASHKEY = 3'b001;
parameter CAL_ADD = 3'b010;
parameter CIPHER = 3'b011;
parameter TAG1 = 3'b100; //Compute Y0
parameter TAG2 = 3'b101; //Generate TAG

always @(*) begin
	case(aes_gcm_ctrl_reg)
	IDLE:
		if(iInit & iKey_valid) 		aes_gcm_ctrl_new = CAL_HASHKEY;
		else									aes_gcm_ctrl_new = IDLE;
	CAL_HASHKEY:
		if(gctr_result_valid)								aes_gcm_ctrl_new = CAL_ADD;
		else												aes_gcm_ctrl_new = CAL_HASHKEY;
	CAL_ADD:
		if( (ghash_result_valid ) & iBlock_valid)			aes_gcm_ctrl_new = CIPHER;
		else															aes_gcm_ctrl_new = CAL_ADD;
	CIPHER:
		if ((last_block & gctr_result_valid) | (iBlock_last & ~iBlock_valid)) 			aes_gcm_ctrl_new = TAG1;
		else 																			aes_gcm_ctrl_new = CIPHER;
	TAG1:
		if(gctr_result_valid)	aes_gcm_ctrl_new = TAG2;
		else					aes_gcm_ctrl_new = TAG1;
	TAG2:	
		aes_gcm_ctrl_new = IDLE;
	default:
		aes_gcm_ctrl_new = IDLE;
	endcase
end

// wire IDLE 			= ~aes_gcm_ctrl_reg[2] & ~aes_gcm_ctrl_reg[1] & ~aes_gcm_ctrl_reg[0];
// wire CAL_HASHKEY 	= ~aes_gcm_ctrl_reg[2] & ~aes_gcm_ctrl_reg[1] &  aes_gcm_ctrl_reg[0];
// wire CAL_ADD		= ~aes_gcm_ctrl_reg[2] &  aes_gcm_ctrl_reg[1] & ~aes_gcm_ctrl_reg[0];
// wire CIPHER			= ~aes_gcm_ctrl_reg[2] &  aes_gcm_ctrl_reg[1] &  aes_gcm_ctrl_reg[0];
// wire TAG1			=  aes_gcm_ctrl_reg[2] & ~aes_gcm_ctrl_reg[1] & ~aes_gcm_ctrl_reg[0];
// wire TAG2			=  aes_gcm_ctrl_reg[2] & ~aes_gcm_ctrl_reg[1] &  aes_gcm_ctrl_reg[0];
// wire AES_ONLY		=  aes_gcm_ctrl_reg[2] &  aes_gcm_ctrl_reg[1] & ~aes_gcm_ctrl_reg[0];

// assign aes_gcm_ctrl_new[0] = 	 (IDLE & iInit & iKey_valid & ~iOpMode) 
// 								|(CAL_HASHKEY & ~gctr_result_valid) 
// 								|(CAL_ADD & (iAad_last | iBlock_valid))
// 								|(CIPHER & ((~gctr_result_valid & ~iBlock_last) | (~last_block & ~iBlock_last) | (~gctr_result_valid & iBlock_valid) | (iBlock_valid & ~last_block)))
// 								|(TAG1 & gctr_result_valid);
// assign aes_gcm_ctrl_new[1] =	(IDLE & iInit & iKey_valid & iOpMode)
// 								|(CAL_HASHKEY & gctr_result_valid)
// 								|(CAL_ADD)
// 								|(CIPHER & ((~gctr_result_valid & ~iBlock_last) | (~last_block & ~iBlock_last) | (~gctr_result_valid & iBlock_valid) | (iBlock_valid & ~last_block)))
// 								|(AES_ONLY & ~gctr_result_valid);
// assign aes_gcm_ctrl_new[2] = 	(IDLE & iInit & iKey_valid & iOpMode)
// 								|(CIPHER & ((last_block & gctr_result_valid) | (iBlock_last & ~iBlock_valid)))
// 								|(TAG1)
// 								|(AES_ONLY & ~gctr_result_valid);


always @(*) begin
	//ghash
	ghash_result_wen = 1'b0;
	ghash_result_dec_wen = 1'b0;
	temp_wen = 1'b0;
	hash_key_wen = 1'b0;
	ghash_input_signal[0] = 1'b0;
	ghash_input_signal[1] = 1'b0;
		//ctrl
	hash_key_valid = 1'b0;
	ghash_input_valid = 1'b0;
	ghash_next = 1'b0;
	//gctr
	gctr_init = 1'b0;
	gctr_hashkey_compute = 1'b0;
	gctr_y0_compute = 1'b0;
	y0_wen = 1'b0;
	//aes_gcm
	aes_gcm_ready = 1'b1;
	aes_gcm_tag_valid = 1'b0;
	aes_gcm_result_valid = 1'b0;
	case(aes_gcm_ctrl_reg)
		3'b000: begin // IDLE
			//ghash
			ghash_result_wen = 1'b0;
			hash_key_wen = 1'b0;
			ghash_input_signal[0] = 1'b0;
			ghash_input_signal[1] = 1'b0;

			hash_key_valid = 1'b0;
			ghash_input_valid = 1'b0;
			//gctr
			gctr_init = 1'b0;
			gctr_hashkey_compute = 1'b0;
			gctr_y0_compute = 1'b0; // signal calculate y0
			y0_wen = 1'b0;
			//aes gcm
			aes_gcm_ready = 1'b1;
			aes_gcm_tag_valid = 1'b0;
			aes_gcm_result_valid = 1'b0;
		end
		
		3'b001: begin	//CAL_HASHKEY
			//ghash	
			ghash_input_signal[0] = 1'b0; //ignored, dont need GHASH
			ghash_input_signal[1] = 1'b0;
			ghash_result_wen = 1'b0;
			if(gctr_result_valid) 	hash_key_wen = 1'b1;
			else 					hash_key_wen = 1'b0;

			if(gctr_result_valid) hash_key_valid = 1'b1;
			else				   hash_key_valid = 1'b0;
			ghash_input_valid = 1'b0;
			ghash_next = 1'b0;
			
			//gctr 
			if(gctr_result_valid) gctr_init = 1'b0;
			else				  gctr_init = 1'b1;
			gctr_hashkey_compute = 1'b1;
			gctr_y0_compute = 1'b0;
			y0_wen = 1'b0;
			//aes gcm
				//Newly modify
			if(gctr_result_valid) aes_gcm_ready = 1'b1;
			else aes_gcm_ready = 1'b0;
			// aes_gcm_ready = 1'b0;
			aes_gcm_tag_valid = 1'b0;
			aes_gcm_result_valid = 1'b0;
		end
		
		3'b010: begin	//CAL_ADD
			//ghash
			ghash_input_signal[0] = 1'b1; 	//iAAD input to GHASH
			ghash_input_signal[1] = 1'b0;
			// if(iAad_valid)	ghash_result_wen = 1'b1;
			// else ghash_result_wen = 1'b0;
			hash_key_wen = 1'b0;		//turn off hash_key_reg

			if(ghash_result_valid) ghash_result_wen = 1'b1;
			else ghash_result_wen = 1'b0;
			hash_key_valid = 1'b1;
			ghash_input_valid = iAad_valid;
			//gctr 
			gctr_init = 1'b0;			//in this step, dont use gctr
			gctr_hashkey_compute = 1'b0;
			gctr_y0_compute = 1'b0;
			y0_wen = 1'b0;
			//aes gcm
				//Newly modify
			if(ghash_result_valid) aes_gcm_ready = 1'b1;
			else aes_gcm_ready = 1'b0;
			// aes_gcm_ready = 1'b1;
			aes_gcm_tag_valid = 1'b0;
			aes_gcm_result_valid = 1'b0;
		end
		
		3'b011: begin	//CIPHER
			//ghash
			ghash_input_signal[0] = 1'b0; 	//GCTR result input to GHASH
			if(iEncdec) ghash_input_signal[1] = 1'b0;
			else		ghash_input_signal[1] = 1'b1;
			
			temp_wen = 1'b1;
			// if(iEncdec) begin
			// 	if(gctr_result_valid)	ghash_result_wen = 1'b1;
			// 	else					ghash_result_wen = 1'b0;
			// 	ghash_result_dec_wen = 1'b0;
			// end
			// else begin
			// 	ghash_result_wen = 1'b0;
			// 	ghash_result_dec_wen =  ~temp & ~ghash_result_wen;
			// end
			
			if(iEncdec) begin
				if(ghash_result_valid)	ghash_result_wen = 1'b1;
				else					ghash_result_wen = 1'b0;
				ghash_result_dec_wen = 1'b0;
			end
			else begin
				ghash_result_wen = 1'b0;
				ghash_result_dec_wen =  ~temp & ~ghash_result_wen;
			end

			
			//if(iEncdec & gctr_result_valid) 	ghash_result_wen = 1'b1;
			//else 								ghash_result_wen = 1'b0;
			//if(~iEncdec) ghash_result_dec_wen =  ~temp & ~ghash_result_wen;
			//else ghash_result_dec_wen = 1'b0;
			hash_key_wen = 1'b0;		//turn off hash_key_reg

			hash_key_valid = 1'b1;
			ghash_input_valid = gctr_result_valid;
			//gctr
			if (gctr_result_valid & last_block | ~iBlock_valid) gctr_init = 1'b0;
			else												gctr_init = 1'b1;
			gctr_hashkey_compute = 1'b0;
			gctr_y0_compute = 1'b0;
			y0_wen = 1'b0;
			//aes gcm
			if(gctr_result_valid) 	aes_gcm_ready = 1'b1;
			else 					aes_gcm_ready = 1'b0;
			aes_gcm_tag_valid = 1'b0;
			aes_gcm_result_valid = gctr_result_valid;
		end
		
		3'b100: begin //TAG1
			//ghash
			ghash_input_signal[0] = 1'b0;
			ghash_input_signal[1] = 1'b0;
			ghash_result_wen = 1'b0;
			temp_wen = 1'b0;
			hash_key_wen = 1'b0;

			hash_key_valid = 1'b1;
			//gctr 
			if(gctr_result_valid) gctr_init = 1'b0;
			else				  gctr_init = 1'b1;
			gctr_hashkey_compute = 1'b0;
			gctr_y0_compute = 1'b1;
			if(gctr_result_valid)   y0_wen = 1'b1;
			else					y0_wen = 1'b0;
			//aes gcm
			aes_gcm_ready = 1'b0;
			aes_gcm_tag_valid = 1'b0;
			aes_gcm_result_valid = 1'b0;
		end
		
		3'b101: begin //TAG2
			//ghash
			ghash_input_signal[0] = 1'b1; 	//iAAD/Len to GHASH
			ghash_input_signal[1] = 1'b0;
			ghash_result_wen = 1'b1;
			hash_key_wen = 1'b0;		//turn off hash_key_reg

			hash_key_valid = 1'b1;
			//gctr 
			gctr_init = 1'b0;
			gctr_hashkey_compute = 1'b0;
			gctr_y0_compute = 1'b0;
			y0_wen = 1'b0;
			//aes gcm
			if(gctr_result_valid) 	aes_gcm_ready = 1'b1;
			else 					aes_gcm_ready = 1'b0;
			aes_gcm_tag_valid = 1'b1;
			aes_gcm_result_valid = 1'b0;
		end
		
		default: begin 
			//ghash
			ghash_result_wen = 1'b0;
			hash_key_wen = 1'b0;
			ghash_input_signal[0] = 1'b0;
			ghash_input_signal[1] = 1'b0;

			hash_key_valid = 1'b1;
			//gctr
			gctr_init = 1'b0;
			gctr_hashkey_compute = 1'b0;
			gctr_y0_compute = 1'b0;
			y0_wen = 1'b0;
			//aes gcm
			aes_gcm_ready = 1'b1;
			aes_gcm_tag_valid = 1'b0;
			aes_gcm_result_valid = 1'b0;
		end
	endcase
end

// //ghash
// assign ghash_result_wen = 	(CAL_ADD & iAad_valid) 
// 							|(CIPHER & (iEncdec & gctr_result_valid))
// 							|TAG2;
							
// assign ghash_result_dec_wen = (CIPHER & (~iEncdec & (~temp & ~ghash_result_wen)));
// assign temp_wen = CIPHER;
// assign hash_key_wen = CAL_HASHKEY & gctr_result_valid;
// assign ghash_input_signal[0] = CAL_ADD | TAG2 ;
// assign ghash_input_signal[1] = CIPHER & ~iEncdec;

// //gctr
// assign gctr_init = 	(CAL_HASHKEY & ~gctr_result_valid) 
// 					|(CIPHER & ((~gctr_result_valid & iBlock_valid) | (~last_block & iBlock_valid)))
// 					|(TAG1 & ~gctr_result_valid)
// 					|AES_ONLY;
					
// assign gctr_hashkey_compute = CAL_HASHKEY;
// assign gctr_y0_compute = TAG1;
// assign y0_wen = TAG1 & gctr_result_valid;

// //aes_gcm
// assign aes_gcm_ready = 	IDLE 
// 						|CAL_ADD
// 						|(CIPHER & gctr_result_valid)
// 						|(TAG2 & gctr_result_valid)
// 						|(AES_ONLY & gctr_result_valid);
// assign aes_gcm_tag_valid = TAG2;
// assign aes_gcm_result_valid = (CIPHER & gctr_result_valid) | (AES_ONLY & gctr_result_valid);



endmodule

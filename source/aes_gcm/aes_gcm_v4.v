//Operation Mode:
//1: ENC MODE
//0: DEC MODE
module aes_gcm_v4(
input iClk,
input iRstn,
	//control signals
// input iInit,
// input iNext,
// input iEncdec,
input [0:3] iCtrl,
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
// Registers and wire declare
//----------------------------------------------------------------
/* AES GCM */
//control
/*
ctrl_reg[0]: iInit
ctrl_reg[1]: iNext
ctrl_reg[2]: iEncdec
*/
reg [0:3] ctrl_reg;
reg next_reg;
wire next_rising;

reg aes_gcm_ready; //Todo: FSM
reg aes_gcm_ready_reg;

reg aes_gcm_tag_valid; //Todo: FSM

reg aes_gcm_result_valid; //Todo: FSM
reg aes_gcm_result_valid_reg;
//input
reg [0:127] dec_tag_reg;

/* FSM */
reg  [2:0] aes_gcm_ctrl_reg;
reg  [2:0] aes_gcm_ctrl_new; //Todo change to wire

/* GCTR */
//control
reg gctr_init; //Todo: FSM
reg gctr_hashkey_compute; //Todo: FSM
reg gctr_y0_compute; //Todo: FSM
//output
wire [0:127] gctr_result;
wire gctr_result_valid;
reg gctr_result_valid_reg;
wire gctr_result_rising;

/* GHASH */
//control
reg ghash_next;     //Todo: FSM
reg [1:0] ghash_input_signal; //Todo: FSM
//input
wire [0:127] mux_ghash_input1;
wire [0:127] mux_ghash_input2;
reg ghash_input_valid; //Todo: FSM

reg [0:127] ghash_key_reg;
reg ghash_key_wen; //Todo: FSM
reg ghash_key_valid; //Todo: FSM

reg [0:127] y0_reg;
reg y0_wen; //Todo: FSM
//output
wire [0:127] ghash_result;
reg [0:127] ghash_result_reg;
reg ghash_result_wen; //Todo: FSM
wire ghash_result_valid;
reg ghash_result_valid_reg;
wire ghash_result_valid_rising;

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
	//control
.iNext(ghash_next),
	//data
.iCtext(mux_ghash_input2), 			//AAD or Cipher text
.iCtext_valid(ghash_input_valid),						//Todo:
.iY(ghash_result_reg), 					//previous ghash result
.iHashkey(ghash_key_reg),				//hash key
.iHashkey_valid(ghash_key_valid),						//Todo
	//output
.oY(ghash_result),						//new ghash result
.oY_valid(ghash_result_valid)								//Todo
);

//----------------------------------------------------------------
// Registers
//----------------------------------------------------------------
//control
always @(posedge iClk) begin
	if(~iRstn)			ctrl_reg <= 4'd0;
	else				ctrl_reg <= iCtrl;
end
//aes gcm ready reg
always @(posedge iClk) begin
	if(~iRstn)			aes_gcm_ready_reg <= 1'b0;
	else				aes_gcm_ready_reg <= aes_gcm_ready;
end
//aes gcm result valid
always @(posedge iClk) begin
	if(~iRstn | next_rising)    aes_gcm_result_valid <= 1'b0;
	else if(gctr_result_rising & (~aes_gcm_ctrl_reg[2] &  aes_gcm_ctrl_reg[1] &  aes_gcm_ctrl_reg[0]) )	aes_gcm_result_valid <= 1'b1;
    else                        aes_gcm_result_valid <= aes_gcm_result_valid;
end
//next reg
always @(posedge iClk) begin
    if(~iRstn)  next_reg <= 1'b0;
    else        next_reg <= ctrl_reg[1];
end

//ghash key reg
always @(posedge iClk) begin
	if(~iRstn)			   ghash_key_reg <= 128'd0;
    else if(ghash_key_wen) ghash_key_reg <= gctr_result;
	else				   ghash_key_reg <= ghash_key_reg;
end
//ghash result reg
always @(posedge iClk) begin
	if(~iRstn)			           ghash_result_reg <= 128'd0;
    else if(ghash_result_wen)    ghash_result_reg <= ghash_result;
	else				           ghash_result_reg <= ghash_result_reg;
end
//ghash result valid reg
always @(posedge iClk) begin
	if(~iRstn)			           ghash_result_valid_reg <= 1'b0;
	else				           ghash_result_valid_reg <= ghash_result_valid;
end
//gctr result valid reg
always @(posedge iClk) begin
	if(~iRstn)			           gctr_result_valid_reg <= 1'b0;
	else				           gctr_result_valid_reg <= gctr_result_valid;
end
//ghash key reg
always @(posedge iClk) begin
	if(~iRstn)		y0_reg <= 128'd0;
    else if(y0_wen) y0_reg <= gctr_result;
	else			y0_reg <= y0_reg;
end
//decryption tag
always @(posedge iClk) begin
	if(~iRstn)			   dec_tag_reg <= 128'd0;
    else if(iTag_valid)    dec_tag_reg <= iTag;
	else				   dec_tag_reg <= dec_tag_reg;
end
//FSM
//State transition
always @(posedge iClk) begin
	if(~iRstn)		aes_gcm_ctrl_reg <= 3'd0;
	else if(ctrl_reg[0]) 	aes_gcm_ctrl_reg <= aes_gcm_ctrl_new;
	else			aes_gcm_ctrl_reg <= aes_gcm_ctrl_reg;
end
reg last_block;
always @(posedge iClk) begin
	if(~iRstn)		last_block <= 1'b0;
	else			last_block <= iBlock_last;
end
//----------------------------------------------------------------
// Wire
//----------------------------------------------------------------
assign mux_ghash_input1 = (ghash_input_signal[0])? iAad : gctr_result;
assign mux_ghash_input2 = (ghash_input_signal[1])? iBlock : mux_ghash_input1;

assign ghash_result_valid_rising = ghash_result_valid & ~ghash_result_valid_reg; 
assign gctr_result_rising = gctr_result_valid & ~gctr_result_valid_reg;
assign next_rising = ctrl_reg[1] & ~next_reg;

assign oResult = gctr_result;
assign oResult_valid = aes_gcm_result_valid;
assign oTag = ghash_result ^ y0_reg;					
assign oTag_valid = aes_gcm_tag_valid;		
assign oReady = aes_gcm_ready_reg;
assign oAuthentic = (~ctrl_reg[2] & oTag_valid & (dec_tag_reg == oTag));
//----------------------------------------------------------------
// FSM
//----------------------------------------------------------------
parameter IDLE = 3'b000;
parameter CAL_HASHKEY = 3'b001;
parameter CAL_ADD = 3'b010;
parameter CIPHER = 3'b011;
parameter TAG1 = 3'b100; //Compute Y0
parameter TAG2 = 3'b101; //Generate TAG

always @(*) begin
	case(aes_gcm_ctrl_reg)
	IDLE:
		if(ctrl_reg[0]) aes_gcm_ctrl_new = CAL_HASHKEY;
		else		    aes_gcm_ctrl_new = IDLE;
	CAL_HASHKEY:
		if(gctr_result_valid)	aes_gcm_ctrl_new = CAL_ADD;
		else					aes_gcm_ctrl_new = CAL_HASHKEY;
	CAL_ADD:
		if(ghash_result_valid & iBlock_valid)		aes_gcm_ctrl_new = CIPHER;
		else										aes_gcm_ctrl_new = CAL_ADD;
	CIPHER:
		if ((last_block & gctr_result_valid) | (iBlock_last & ~iBlock_valid)) aes_gcm_ctrl_new = IDLE;
		else 																  aes_gcm_ctrl_new = CIPHER;
	// TAG1:
	// 	if(gctr_result_valid)	aes_gcm_ctrl_new = TAG2;
	// 	else					aes_gcm_ctrl_new = TAG1;
	// TAG2:	
	// 	aes_gcm_ctrl_new = IDLE;
	default:
		aes_gcm_ctrl_new = IDLE;
	endcase
end

always @(*) begin
    //aes_gcm
    aes_gcm_ready = 1'b0;
    aes_gcm_tag_valid = 1'b0;
    //aes_gcm_result_valid = 1'b0;
    //gctr
    gctr_init = 1'b0;
    gctr_hashkey_compute = 1'b0;
    gctr_y0_compute = 1'b0;
    //ghash
    ghash_next = 1'b0;
    ghash_input_signal = 2'b00;
    ghash_input_valid = 1'b0;
    ghash_key_wen = 1'b0;
    ghash_key_valid = 1'b0;
    y0_wen = 1'b0;
    ghash_result_wen = 1'b0;
    case(aes_gcm_ctrl_reg)
        IDLE: begin            
            //aes_gcm
            aes_gcm_ready = 1'b0;
            aes_gcm_tag_valid = 1'b0;
            //aes_gcm_result_valid = 1'b0;
            //gctr
            gctr_init = 1'b0;
            gctr_hashkey_compute = 1'b0;
            gctr_y0_compute = 1'b0;
            //ghash
            ghash_next = 1'b0;
            ghash_input_signal = 2'b00;
            ghash_input_valid = 1'b0;
            ghash_key_wen = 1'b0;
            ghash_key_valid = 1'b0;
            y0_wen = 1'b0;
            ghash_result_wen = 1'b0;
        end
        CAL_HASHKEY: begin
            //aes_gcm
            if(gctr_result_valid) aes_gcm_ready = 1'b1;
            else                   aes_gcm_ready = 1'b0;
            aes_gcm_tag_valid = 1'b0;
            //aes_gcm_result_valid = 1'b0;
            //gctr
            if(gctr_result_valid) gctr_init = 1'b0;
			else				  gctr_init = 1'b1;
            gctr_hashkey_compute = 1'b1;
            gctr_y0_compute = 1'b0;
            //ghash
            ghash_next = 1'b0;
            ghash_input_signal[0] = 1'b0;
            ghash_input_signal[1] = 1'b0;
            ghash_input_valid = 1'b0;
            if(gctr_result_valid) ghash_key_wen = 1'b1;
            else                  ghash_key_wen = 1'b0;
            if(gctr_result_valid) ghash_key_valid = 1'b1;
            else                  ghash_key_valid = 1'b0;
            y0_wen = 1'b0;
            ghash_result_wen = 1'b0;
        end
        CAL_ADD: begin
            //aes_gcm
            if(ghash_result_valid) aes_gcm_ready = 1'b1;
            else                   aes_gcm_ready = 1'b0;
            aes_gcm_tag_valid = 1'b0;
            //aes_gcm_result_valid = 1'b0;
            //gctr
            gctr_init = 1'b0;
            gctr_hashkey_compute = 1'b0;
            gctr_y0_compute = 1'b0;
            //ghash
            ghash_next = ctrl_reg[1];
            ghash_input_signal[0] = 1'b1; 	//iAAD input to GHASH
			ghash_input_signal[1] = 1'b0;
            ghash_input_valid = iAad_valid;
            ghash_key_wen = 1'b0;
            ghash_key_valid = 1'b1;
            y0_wen = 1'b0;
            if(ghash_result_valid_rising) ghash_result_wen = 1'b1;
			else                          ghash_result_wen = 1'b0;
        end
        CIPHER: begin
            //aes_gcm
            if(gctr_result_valid) 	aes_gcm_ready = 1'b1;
			else 					aes_gcm_ready = 1'b0;
            aes_gcm_tag_valid = 1'b0;
            //aes_gcm_result_valid = gctr_result_valid;
            //gctr
            // if (gctr_result_valid & last_block | ~iBlock_valid) gctr_init = 1'b0;
			// else												gctr_init = 1'b1;
            if(ctrl_reg[1])   gctr_init = 1'b1;
            else              gctr_init = 1'b0;
            gctr_hashkey_compute = 1'b0;
            gctr_y0_compute = 1'b0;
            //ghash
            ghash_next = ctrl_reg[1];
			ghash_input_signal[0] = 1'b0; 	//GCTR result input to GHASH
			if(ctrl_reg[2]) ghash_input_signal[1] = 1'b0;
			else		    ghash_input_signal[1] = 1'b1;
            ghash_input_valid = 1'b0;
            ghash_key_wen = 1'b0;
            ghash_key_valid = 1'b1;
            y0_wen = 1'b0;
            if(ghash_result_valid)	ghash_result_wen = 1'b1;
			else					ghash_result_wen = 1'b0;
        end
        default: begin
        //aes_gcm
        aes_gcm_ready = 1'b0;
        aes_gcm_tag_valid = 1'b0;
        //aes_gcm_result_valid = 1'b0;
        //gctr
        gctr_init = 1'b0;
        gctr_hashkey_compute = 1'b0;
        gctr_y0_compute = 1'b0;
        //ghash
        ghash_next = 1'b0;
        ghash_input_signal = 2'b00;
        ghash_input_valid = 1'b0;
        ghash_key_wen = 1'b0;
        ghash_key_valid = 1'b1;
        y0_wen = 1'b0;
        ghash_result_wen = 1'b0;
        end
    endcase
end

endmodule
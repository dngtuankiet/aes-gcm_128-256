module aes_gcm_v4(
input iClk,
input iRstn,
	/* control signals */
// iCtrl[0] - iInit
// iCtrl[1] - iNext
// iCtrl[2] - iEncdec: 1 for ENC, 0 for DEC
// iCtrl[3] - aad_only
input [0:3] iCtrl,
output oReady,
	/* data */
input [0:95] iIV,
input iIV_valid,
input [0:255] iKey,
input iKey_valid,
input iKeylen,

input [0:127] iAad, //Additional Authentication Data and Length
input iAad_valid,

input [0:127] iBlock,
input iBlock_valid,

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
ctrl_reg[0] - iInit
ctrl_reg[1] - iNext
ctrl_reg[2] - iEncdec
ctrl_reg[3] - aad_only
*/
reg [0:3] ctrl_reg;
reg next_reg;
wire next_rising;

reg aes_gcm_ready;
reg aes_gcm_tag_valid;
reg aes_gcm_result_valid;
//input
reg [0:127] dec_tag_reg;

/* FSM */
parameter IDLE = 3'b000;
parameter CAL_HASHKEY = 3'b001;
parameter CAL_ADD = 3'b010;
parameter CIPHER = 3'b011;
parameter TAG = 3'b100; //Compute Y0
parameter TAG2 = 3'b101; //Generate TAG
reg  [2:0] aes_gcm_state_reg;
reg  [2:0] aes_gcm_state_new; //Todo: Optimize

/* GCTR */
//control
reg gctr_init; //Todo: Optimize
reg gctr_hashkey_compute; //Todo: Optimize
reg gctr_y0_compute; //Todo: Optimize
//output
wire [0:127] gctr_result;
wire gctr_result_valid;
reg gctr_result_valid_reg;
wire gctr_result_rising;

/* GHASH */
//control
reg [1:0] ghash_input_signal; //Todo: Optimize
//input
wire [0:127] mux_ghash_input1;
wire [0:127] mux_ghash_input2;

reg [0:127] ghash_key_reg;
reg ghash_key_wen; //Todo: Optimize

reg [0:127] y0_reg;
reg y0_wen; //Todo: Optimize
//output
wire [0:127] ghash_result;
reg [0:127] ghash_result_reg;
reg ghash_result_wen; //Todo: Optimize

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
// ghash_block_v2 GHASH(
// .iClk(iClk),
// .iRstn(iRstn),
// 	//control
// .iNext(ghash_next),
// 	//data
// .iCtext(mux_ghash_input2), 			    //AAD or Cipher text
// .iCtext_valid(ghash_input_valid),
// .iY(ghash_result_reg), 					//previous ghash result
// .iHashkey(ghash_key_reg),				//hash key
// .iHashkey_valid(ghash_key_valid),
// 	//output
// .oY(ghash_result),						//new ghash result
// .oY_valid(ghash_result_valid)
// );

//GHASH_BLOCK computes GF(2^128) in 1 clock cycles
ghash_block GHASH(
	//data
.iCtext(mux_ghash_input2), 			    //AAD or Cipher text
.iY(ghash_result_reg), 					//previous ghash result
.iHashkey(ghash_key_reg),				//hash key
	//output
.oY(ghash_result)						//new ghash result
);


//----------------------------------------------------------------
// Registers
//----------------------------------------------------------------

/* AES GCM */
//control
always @(posedge iClk) begin
	if(~iRstn)	ctrl_reg <= 4'd0;
	else		ctrl_reg <= iCtrl;
end

always @(posedge iClk) begin
    if(~iRstn)  next_reg <= 1'b0;
    else        next_reg <= ctrl_reg[1];
end

//output
always @(posedge iClk) begin
	if(~iRstn | next_rising)                                      aes_gcm_result_valid <= 1'b0;
	else if(gctr_result_rising & (aes_gcm_state_reg == CIPHER) )  aes_gcm_result_valid <= 1'b1;
    else                                                          aes_gcm_result_valid <= aes_gcm_result_valid;
end

always @(posedge iClk) begin
    if(~iRstn)                                                       aes_gcm_tag_valid <= 1'b0;
    else if(gctr_result_rising & (aes_gcm_state_reg == TAG))  aes_gcm_tag_valid <= 1'b1;
    else                                                             aes_gcm_tag_valid <= aes_gcm_tag_valid;
end

always @(posedge iClk) begin
    if(~iRstn | next_rising)                                                                        aes_gcm_ready <= 1'b0;
    else if((gctr_result_rising & (aes_gcm_state_reg == CAL_HASHKEY)) | gctr_result_rising)  aes_gcm_ready <= 1'b1;
    else                                                                                            aes_gcm_ready <= aes_gcm_ready;
end

/* GHASH */
//ghash key reg
always @(posedge iClk) begin
	if(~iRstn)			   ghash_key_reg <= 128'd0;
    else if(ghash_key_wen) ghash_key_reg <= gctr_result;
	else				   ghash_key_reg <= ghash_key_reg;
end
//ghash result reg
always @(posedge iClk) begin
	if(~iRstn)			        ghash_result_reg <= 128'd0;
    else if(ghash_result_wen)   ghash_result_reg <= ghash_result;
	else				        ghash_result_reg <= ghash_result_reg;
end
//gctr result valid reg
always @(posedge iClk) begin
	if(~iRstn)	 gctr_result_valid_reg <= 1'b0;
	else		 gctr_result_valid_reg <= gctr_result_valid;
end
//ghash key reg
always @(posedge iClk) begin
	if(~iRstn)		 y0_reg <= 128'd0;
    else if(y0_wen)  y0_reg <= gctr_result;
	else			 y0_reg <= y0_reg;
end
//decryption tag
always @(posedge iClk) begin
	if(~iRstn)			   dec_tag_reg <= 128'd0;
    else if(iTag_valid)    dec_tag_reg <= iTag;
	else				   dec_tag_reg <= dec_tag_reg;
end
/* FSM */
//State transition
always @(posedge iClk) begin
	if(~iRstn)		      aes_gcm_state_reg <= 3'd0;
	else if(ctrl_reg[0])  aes_gcm_state_reg <= aes_gcm_state_new;
	else			      aes_gcm_state_reg <= aes_gcm_state_reg;
end
//----------------------------------------------------------------
// Wire
//----------------------------------------------------------------
assign mux_ghash_input1 = (ghash_input_signal[0])? iAad : gctr_result;
assign mux_ghash_input2 = (ghash_input_signal[1])? iBlock : mux_ghash_input1;

assign gctr_result_rising = gctr_result_valid & ~gctr_result_valid_reg;
assign next_rising = ctrl_reg[1] & ~next_reg;

assign oResult = gctr_result;
assign oResult_valid = aes_gcm_result_valid;
assign oTag = ghash_result_reg ^ y0_reg;					
assign oTag_valid = aes_gcm_tag_valid;		
assign oReady = aes_gcm_ready;
assign oAuthentic = (~ctrl_reg[2] & oTag_valid & (dec_tag_reg == oTag));
//----------------------------------------------------------------
// FSM
//----------------------------------------------------------------
always @(*) begin
	case(aes_gcm_state_reg)
	IDLE:
		if(ctrl_reg[0] & next_rising)   aes_gcm_state_new = CAL_HASHKEY;
		else		                    aes_gcm_state_new = IDLE;
	CAL_HASHKEY:
		if(gctr_result_valid)	aes_gcm_state_new = CAL_ADD;
		else					aes_gcm_state_new = CAL_HASHKEY;
	CAL_ADD:
		if(iBlock_valid & next_rising)		aes_gcm_state_new = CIPHER;
        else if(ctrl_reg[3] & next_rising)  aes_gcm_state_new = TAG;
		else							    aes_gcm_state_new = CAL_ADD;
	CIPHER:
		if (iAad_valid & next_rising)   aes_gcm_state_new = TAG;
		else 							aes_gcm_state_new = CIPHER;
	TAG:
		aes_gcm_state_new = IDLE;
	default:
		aes_gcm_state_new = IDLE;
	endcase
end

always @(*) begin
    //gctr
    gctr_init = 1'b0;
    gctr_hashkey_compute = 1'b0;
    gctr_y0_compute = 1'b0;
    //ghash
    ghash_input_signal = 2'b00;
    ghash_key_wen = 1'b0;
    y0_wen = 1'b0;
    ghash_result_wen = 1'b0;
    case(aes_gcm_state_reg)
        IDLE: begin            
            //gctr
            gctr_init = 1'b0;
            gctr_hashkey_compute = 1'b0;
            gctr_y0_compute = 1'b0;
            //ghash
            ghash_input_signal = 2'b00;
            ghash_key_wen = 1'b0;
            y0_wen = 1'b0;
            ghash_result_wen = 1'b0;
        end
        CAL_HASHKEY: begin
            //gctr
            if(gctr_result_valid) gctr_init = 1'b0;
			else				  gctr_init = 1'b1;
            gctr_hashkey_compute = 1'b1;
            gctr_y0_compute = 1'b0;
            //ghash
            ghash_input_signal[0] = 1'b0;
            ghash_input_signal[1] = 1'b0;
            if(gctr_result_valid) ghash_key_wen = 1'b1;
            else                  ghash_key_wen = 1'b0;
            y0_wen = 1'b0;
            ghash_result_wen = 1'b0;
        end
        CAL_ADD: begin
            //gctr
            if(next_rising & (iBlock_valid | ctrl_reg[3]))  gctr_init = 1'b1;
            else                                            gctr_init = 1'b0;
            gctr_hashkey_compute = 1'b0;
            gctr_y0_compute = 1'b0;
            //ghash
            ghash_input_signal[0] = 1'b1; 	//iAAD input to GHASH
			ghash_input_signal[1] = 1'b0;
            ghash_key_wen = 1'b0;
            y0_wen = 1'b0;
            if(iAad_valid & next_rising) ghash_result_wen = 1'b1;
			else                         ghash_result_wen = 1'b0;
        end
        CIPHER: begin
            //gctr
            if(next_rising)   gctr_init = 1'b1;
            else              gctr_init = 1'b0;
            gctr_hashkey_compute = 1'b0;
            gctr_y0_compute = 1'b0;
            //ghash
			ghash_input_signal[0] = 1'b0; 	//GCTR result input to GHASH
			if(ctrl_reg[2]) ghash_input_signal[1] = 1'b0;
			else		    ghash_input_signal[1] = 1'b1;
            ghash_key_wen = 1'b0;
            y0_wen = 1'b0;
            if(gctr_result_rising)	ghash_result_wen = 1'b1;
			else					ghash_result_wen = 1'b0;
        end
        TAG: begin
            //gctr
            gctr_init = 1'b0;
            gctr_hashkey_compute = 1'b0;
            gctr_y0_compute = 1'b1;
            //ghash
            ghash_input_signal[0] = 1'b1;
            ghash_input_signal[1] = 1'b0;
            ghash_key_wen = 1'b0;
            if(gctr_result_rising) y0_wen = 1'b1;
            else                   y0_wen = 1'b0;
            if(gctr_result_rising)	ghash_result_wen = 1'b1;
			else                            ghash_result_wen = 1'b0;
        end
        default: begin
        //gctr
        gctr_init = 1'b0;
        gctr_hashkey_compute = 1'b0;
        gctr_y0_compute = 1'b0;
        //ghash
        ghash_input_signal = 2'b00;
        ghash_key_wen = 1'b0;
        y0_wen = 1'b0;
        ghash_result_wen = 1'b0;
        end
    endcase
end

endmodule
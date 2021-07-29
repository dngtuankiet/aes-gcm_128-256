module aes_gcm_v2(
input iClk,
input iRstn,
input iInit,
input iEncdec,
input iOpMode,
output oReady,

input [0:95] iIV,
input iIV_valid,
input [0:255] iKey,
input iKey_valid,
input iKeylen,

input [0:127] iAad, //Len
input iAad_valid,
input iAad_last,

input [0:127] iBlock,
input iBlock_valid,
input iBlock_last,

input [0:127] iTag,
input iTag_valid,

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
wire ghash_result_wen;
wire ghash_result_dec_wen;

//hash key register
reg [0:127] hash_key_reg;
wire hash_key_wen;

//y0 register
reg [0:127] y0_reg;
wire y0_wen;

//delay iBlock_last
reg last_block;

//tag register
reg [0:127] tag_reg;

reg  [2:0] aes_gcm_ctrl_reg;
wire  [2:0] aes_gcm_ctrl_new;

//----------------------------------------------------------------
// Control signal
//----------------------------------------------------------------

//ghash
wire [1:0] ghash_input_signal;
wire [0:127] muxed_ghash_input1;
wire [0:127] muxed_ghash_input2;
wire [0:127] ghash_result;

//gctr
wire gctr_init;
wire gctr_mode;
wire gctr_hashkey_proc;
wire gctr_y0;
wire [0:127] gctr_result;
wire gctr_result_valid;

//aes_gcm
wire aes_gcm_ready;
wire aes_gcm_tag_valid;
wire aes_gcm_result_valid;		

//----------------------------------------------------------------
// Instantiations.
//----------------------------------------------------------------

gctr_block GCTR(
.iClk(iClk),
.iRstn(iRstn),
.iEncdec(gctr_mode),	//always do encryption for aes gcm
.iOpMode(iOpMode),
.iInit(gctr_init),
.iIV(iIV),				
.iIV_valid(iIV_valid),	
.iKey(iKey),		
.iKey_valid(iKey_valid),	
.iKeylen(iKeylen),
.iY0(gctr_y0),
.iHashKey(gctr_hashkey_proc), 
.iBlock(iBlock), 
.iBlock_valid(iBlock_valid),
.oResult(gctr_result),						//Cipher text
.oResult_valid(gctr_result_valid)
);

ghash_block GHASH(
.iClk(iClk),
.iRstn(iRstn),
.iCtext(muxed_ghash_input2), 			//AAD or Cipher text
.iCtext_valid()							//ToDo
.iY(ghash_result_reg), 					//previous ghash result
.iHashkey(hash_key_reg),				//hash key
.iHashkey_valid()						//ToDo
.oY(ghash_result)						//new ghash result
.oY_valid()								//ToDo
);

//----------------------------------------------------------------
// Reg
//----------------------------------------------------------------

//Store Hashkey
always @(posedge iClk) begin
	//if(~iRstn)				hash_key_reg <= 128'd0;
	if(hash_key_wen)	hash_key_reg <= gctr_result;  //Hashkey
	else					hash_key_reg <= hash_key_reg;
end

//Store Tag
always @(posedge iClk) begin
	//if(~iRstn)						tag_reg <= 128'd0;
	if(iTag_valid)	tag_reg <= iTag;
	else							tag_reg <= tag_reg;
end

//Ghash result
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

//y0
always @(posedge iClk) begin
	//if(~iRstn)					y0_reg <= 128'd0;
	if(y0_wen)				y0_reg <= gctr_result; //y0
	else						y0_reg <= y0_reg;
end

endmodule
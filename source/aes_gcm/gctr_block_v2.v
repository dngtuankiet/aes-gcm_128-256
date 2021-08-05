module gctr_block_v2(
	//control signal
input iClk,
input iRstn,  
input iInit,
input iHashKey,
input iY0,
	//data
input [0:95] iIV,
input iIV_valid,
input [0:255] iKey,
input iKey_valid,
input iKeylen,
input [0:127] iBlock,
input iBlock_valid,
	//output
output [0:127] oResult,
output oResult_valid
);

//----------------------------------------------------------------
// Registers variables and enable.
//----------------------------------------------------------------
reg [0:31] counter_reg;
reg	   counter_en; //todo

reg [0:127] block_reg;
reg 		block_wen; //todo
reg			encdec_reg;

reg [0:95]  IV_reg;
reg		IV_wen; //todo

reg [0:255] key_reg;
reg 		key_wen; //todo
reg 		key_len;

reg hashkey_reg;
reg hashkey_wen; //todo

reg y0_reg;
reg y0_wen; //todo

reg [1:0] gctr_ctrl_reg;
reg [1:0] gctr_ctrl_new; //todo

reg gctr_result_valid; //todo
//----------------------------------------------------------------
// Wires.
//----------------------------------------------------------------
wire State0; //IDLE
wire State1; //INIT_AES
wire State2; //WAIT_KEY
wire State3; //CIPHER

wire [0:127] muxed_aes_core_input;
wire [0:127] aes_core_output;

reg aes_core_init;  //todo
reg aes_core_next; //todo
wire aes_core_oready;
wire aes_core_output_valid;

assign State0 = ~gctr_ctrl_reg[1] & ~gctr_ctrl_reg[0];
assign State1 = ~gctr_ctrl_reg[1] &  gctr_ctrl_reg[0]; 
assign State2 =  gctr_ctrl_reg[1] & ~gctr_ctrl_reg[0]; 
assign State3 =  gctr_ctrl_reg[1] &  gctr_ctrl_reg[0];
//----------------------------------------------------------------
// Instantiations.
//----------------------------------------------------------------
aes_core U1(
.iClk(iClk),						
.iRstn(iRstn),
				
.iInit(aes_core_init),						
.iNext(aes_core_next),						
.oReady(aes_core_oready),				

.iKey(key_reg),						
.iKeylen(key_len),					

.iBlock(muxed_aes_core_input),					
.oResult(aes_core_output),					
.oResult_valid(aes_core_output_valid)
);

//----------------------------------------------------------------
// Reg
//----------------------------------------------------------------

//Sample input IV
always @(posedge iClk) begin
	if(~iRstn) 									IV_reg <= 128'd0;
	else if(IV_wen & iIV_valid)  	IV_reg <= iIV;				
	else 										IV_reg <= IV_reg;
end

//Sample input plaintext
always @(posedge iClk) begin
	if(~iRstn) 							block_reg <= 128'd0;
	else if(block_wen & iBlock_valid)  	block_reg <= iBlock;			
	else 								block_reg <= block_reg;
end

//Sample input key
always @(posedge iClk) begin
	if(~iRstn) 						key_reg <= 256'd0;
	else if(key_wen & iKey_valid)  	key_reg <= iKey;				
	else 							key_reg <= key_reg;
end

always @(posedge iClk) begin
	if(~iRstn) 						key_len <= 1'd0;
	else if(key_wen & iKey_valid)  	key_len <= iKeylen;				
	else 							key_len <= key_len;
end

always @(posedge iClk) begin
	if(~iRstn) 							hashkey_reg <= 1'b0;
	else if(hashkey_wen & iKey_valid)  	hashkey_reg <= iHashKey;				
	else 								hashkey_reg <= hashkey_reg;
end

always @(posedge iClk) begin
	if(~iRstn) 										y0_reg <= 1'b0;
	else if(y0_wen & iKey_valid)  		y0_reg <= iY0;				
	else 											y0_reg <= y0_reg;
end

//Counter
always @(posedge iClk) begin
	if(~iRstn)												counter_reg <= 32'd1;
	else if(counter_en & ~hashkey_reg & ~y0_reg)	counter_reg <= counter_reg + 1'd1; 
	else													counter_reg <= counter_reg;
end

//State transition
always @(posedge iClk) begin
	if(~iRstn)		gctr_ctrl_reg <= 2'd0;
	else if(iInit)  gctr_ctrl_reg <= gctr_ctrl_new;
	else 			gctr_ctrl_reg <= gctr_ctrl_reg;
end

//----------------------------------------------------------------
// Mux connection of the input and output of aes_core
//----------------------------------------------------------------
assign muxed_aes_core_input = (y0_reg)? {IV_reg, 31'd0, 1'b1} : 
							  (hashkey_reg)? {128{1'b0}} :  {IV_reg, counter_reg};  //Create Hashkey


assign oResult = (hashkey_reg | y0_reg)? aes_core_output : aes_core_output ^ block_reg; //Output Hashkey or y0


assign oResult_valid = gctr_result_valid;


//----------------------------------------------------------------
// gctr_block control
//
// Control FSM for gctr_block. Tasks:
// - Sample input Key, Keylen, IV, Block
// - Store Block
// - Pass necessary signal and data to aes_core and wait for return signal
//----------------------------------------------------------------

//---------------------------------------------------------------------------------------------------------------------------------
//State transition
always @(*) begin
	case(gctr_ctrl_reg)
	2'b00:
		if(iInit & aes_core_oready) 	gctr_ctrl_new = 2'b01;	//start when init_signal = 1 and the aes_core is avaiable
		else							gctr_ctrl_new = 2'b00;
	2'b01:
		gctr_ctrl_new = 2'b10;									//after init, wait for the aes_core to generate keys
	2'b10:
		if(aes_core_oready) gctr_ctrl_new = 2'b11;					//the keys are generated, send data to enc/dec
		else gctr_ctrl_new = 2'b10;
	2'b11:
		if(aes_core_oready) 	gctr_ctrl_new = 2'b00;		//pass input to aes_core, go back to IDLE
		else					gctr_ctrl_new = 2'b11;
	endcase
end

//-- Optim --
// assign gctr_ctrl_new[0] = (State0 & iInit & aes_core_oready) | (State2 & aes_core_oready) | (State3 & ~aes_core_oready);
// assign gctr_ctrl_new[1] = State1 | State2 | (State3 & ~aes_core_oready);
//---------------------------------------------------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------------------------------------------------
//Control signals
always @(*) begin
	//input
	counter_en = 1'b0;
	block_wen = 1'b0;
	IV_wen = 1'b0;
	key_wen = 1'b0;
	hashkey_wen = 1'b0;
	//signal to aes_core
	aes_core_init = 1'b0;
	aes_core_next = 1'b0;
	case(gctr_ctrl_reg)
		2'b00: begin	//IDLE
			//input
			counter_en = 1'b0;
			block_wen = 1'b0;
			IV_wen = 1'b0;
			key_wen = 1'b0;
			hashkey_wen = 1'b0;
			//signal to aes_core
			aes_core_init = 1'b0;
			aes_core_next = 1'b0;
			gctr_result_valid = aes_core_output_valid;
		end
		2'b01: begin	//INIT_AES			//Start aes_core, sample all necessary input
			//input
			counter_en = 1'b0;
			block_wen = 1'b1;
			IV_wen = 1'b1;
			key_wen = 1'b1;
			hashkey_wen = 1'b1;
			y0_wen = 1'b1;
			//signal to aes_core
			aes_core_init = 1'b1;
			aes_core_next = 1'b0;
			gctr_result_valid = 1'b0;
		end
		2'b10: begin //WAIT_KEY
			//input
			counter_en = 1'b0;
			block_wen = 1'b0;
			IV_wen = 1'b0;
			key_wen = 1'b0;
			hashkey_wen = 1'b0;
			//signal to aes_core
			aes_core_init = 1'b0;
			aes_core_next = 1'b0;
			gctr_result_valid = 1'b0;
		end
		2'b11: begin //CIPHER
			//input
			counter_en = 1'b1;
			block_wen = 1'b0;
			IV_wen = 1'b0;
			key_wen = 1'b0;
			hashkey_wen = 1'b0;
			//signal to aes_core
			aes_core_init = 1'b0;
			aes_core_next = 1'b1;
			gctr_result_valid = 1'b0;
		end
	endcase
end

// assign counter_en = State3;
// assign block_wen = State1;
// assign IV_wen = State1;
// assign key_wen = State1;
// assign hashkey_wen = State1;
// assign aes_core_init = State1;
// assign aes_core_next = State3;
// 	//this reduce aes_core_output_valid signal to 1 clock cycle
// //assign gctr_result_valid = (gctr_ctrl_new[1] & ~gctr_ctrl_new[0])? aes_core_output_valid : 1'b0;
// assign gctr_result_valid = aes_core_output_valid;
// assign y0_wen = State1;
//---------------------------------------------------------------------------------------------------------------------------------

endmodule

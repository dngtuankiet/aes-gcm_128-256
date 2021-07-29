module gfmul_v2(
input iClk,
input iRst_n,
input [0:127] iCtext,
input iCtext_valid,
input [0:127] iHashkey,
input iHashkey_valid,
output [0:127] oResult,
output oResult_valid
);
//----------------------------------------------------------------
// reg and wire
//----------------------------------------------------------------
reg [0:127] Z;
reg [0:127] V;
wire [0:127] iR;
assign iR = {8'b1110_0001, 120'd0};
wire [0:127] V_and_xor;
wire [0:127] Z_and_xor;
reg [6:0] cnt;
wire [0:127] mux_Z_1;
wire [0:127] mux_Z_2;
wire [0:127] mux_V;
wire mux_sel_V;
wire mux_sel_Z_1;
wire mux_sel_Z_2;

//----------------------------------------------------------------
// function
//----------------------------------------------------------------
function [0:127]and_xor;
	input [0:127] in1;
	input [0:127] in2;
	input [0:127] in3;
	begin
		and_xor = in1 ^ (in2 & in3);
	end
endfunction

//----------------------------------------------------------------
// register
//----------------------------------------------------------------
always@(posedge iClk) begin
	if(~iRst_n | oResult_valid)				cnt <= 7'd0;
	else if(iCtext_valid && iHashkey_valid) cnt <= cnt + 1'b1;
	else									cnt <= cnt;
end

always@(posedge iClk) begin
	if(iHashkey_valid) 	V <= V_and_xor;
	else 				V <= V;
end

always@(posedge iClk) begin
	if(iCtext_valid && iHashkey_valid) 	Z <= Z_and_xor;
	else 				Z <= Z;
end

//----------------------------------------------------------------
// assignment
//----------------------------------------------------------------
assign oResult_valid = &cnt;
assign oResult = Z;

assign mux_sel_V = (cnt == 7'd0)? 1'b1 : 1'b0;
assign mux_sel_Z_1 = (cnt == 7'd0)? 1'b1 : 1'b0;
assign mux_sel_Z_2 = (cnt == 7'd0)? 1'b1 : 1'b0;

assign mux_V = (mux_sel_V)? iHashkey : V;
assign V_and_xor = and_xor({1'b0, mux_V[0:126]}, iR, {128{mux_V[127]}});

assign mux_Z_1 = (mux_sel_Z_1)? iHashkey : V;
assign mux_Z_2 = (mux_sel_Z_2)? 128'd0 : Z;
assign Z_and_xor = and_xor(mux_Z_2, mux_Z_1, {128{iCtext[cnt]}});

endmodule
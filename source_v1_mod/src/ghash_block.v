module ghash_block (
//input 	iClk,
//input 	iRstn,
input 	[0:127] iCtext,
input 	[0:127] iY,
input 	[0:127] iHashkey,
output 	[0:127] oY
);

wire [0:127] wXor;


//reg [0:127] R;
//always @(posedge iClk) begin
//	if(~iRstn) 	R <=  {8'b1110_0001, 120'd0};
//	else 		R <= R;
//end

gfmul GFMUL(
//.iR(R),
.iCtext(wXor),
.iHashkey(iHashkey),
.oResult(oY)
);

assign wXor = iCtext ^ iY;

endmodule
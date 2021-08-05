module ghash_block_v2 (
input 	iClk,
input 	iRstn,
	//control
input iNext,
	//data
input 	[0:127] iCtext,
input 	iCtext_valid,
input 	[0:127] iY,
input 	[0:127] iHashkey,
input 	iHashkey_valid,
	//output
output 	[0:127] oY,
output 	oY_valid
);

wire [0:127] wXor;

gfmul_v2 GFMUL(
.iClk(iClk),
.iRstn(iRstn),
	//control
.iNext(iNext),
	//data
.iCtext(wXor),
.iCtext_valid(iCtext_valid),
.iHashkey(iHashkey),
.iHashkey_valid(iHashkey_valid),
	//output
.oResult(oY),
.oResult_valid(oY_valid)
);

assign wXor = iCtext ^ iY;

endmodule
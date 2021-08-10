module aes_gcm_v4_TOP(
//7 pins
input ICLK,
input IRSTN,
input [0:3] ICTRL,
output OREADY,

//355 pins
input [0:95] IIV,
input IIV_VALID,
input [0:255] IKEY,
input IKEY_VALID,
input IKEYLEN,

//129 pins
input [0:127] IAAD,
input IAAD_VALID,

//129 pins
input [0:127] IBLOCK,
input IBLOCK_VALID,

//129 pins
input [0:127] ITAG,
input ITAG_VALID,

//259 pins
output [0:127] ORESULT,
output ORESULT_VALID,
output [0:127] OTAG,
output OTAG_VALID,
output OAUTHENTIC
);

aes_gcm_v4 U1(
.iClk(ICLK),
.iRstn(IRSTN),
.iCtrl(ICTRL),
.oReady(OREADY),

.iIV(IIV),
.iIV_valid(IIV_VALID),
.iKey(IKEY),
.iKey_valid(IKEY_VALID),
.iKeylen(IKEYLEN),

.iAad(IAAD), //Len
.iAad_valid(IAAD_VALID),

.iBlock(IBLOCK),
.iBlock_valid(IBLOCK_VALID),

.iTag(ITAG),
.iTag_valid(ITAG_VALID),

.oResult(ORESULT),
.oResult_valid(ORESULT_VALID),
.oTag(OTAG),
.oTag_valid(OTAG_VALID),
.oAuthentic(OAUTHENTIC)
);

endmodule


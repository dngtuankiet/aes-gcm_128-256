module tb_gfmul_v2();
reg CLK;
reg RST;
reg NEXT;
reg [127:0] CTEXT;
reg CTEXT_VALID;
reg [0:127] HASHKEY;
reg HASHKEY_VALID;
wire [0:127] RESULT;
wire RESULT_VALID;


always #5 CLK = ~CLK;

gfmul_v2 GFMUL(
.iClk(CLK),
.iRstn(RST),
.iNext(NEXT),
.iCtext(CTEXT),
.iCtext_valid(CTEXT_VALID),
.iHashkey(HASHKEY),
.iHashkey_valid(HASHKEY_VALID),
.oResult(RESULT),
.oResult_valid(RESULT_VALID)
);

task check_result(
input [0:127] expected
);
begin
@(RESULT_VALID);
	// if(RESULT_VALID) begin
		if(RESULT == expected) begin
			$display("***Correct Result");
			end
		else
		begin
			$display("Expected: 0x%032x", expected);
			$display("Got:      0x%032x", RESULT);
			$display("");
		end
	// end
end
endtask

initial begin
//R = {8'b1110_0001, 120'd0};
$display("Test GFMUL");
CLK = 0;
RST = 0;
NEXT = 0;
CTEXT = 0;
CTEXT_VALID = 0;
HASHKEY = 128'h66E94BD4EF8A2C3B884CFA59CA342B2E;
HASHKEY_VALID = 1;
#15
RST = 1;

#30

CTEXT = 128'h0388DACE60B6A392F328C2B971B2FE78;
HASHKEY = 128'h66E94BD4EF8A2C3B884CFA59CA342B2E;
CTEXT_VALID = 1;
HASHKEY_VALID = 1;
NEXT = 1;
#30
NEXT = 0;
//expected result: 5E2EC746917062882C85B0685353DEB7
check_result(128'h5E2EC746917062882C85B0685353DEB7);

CTEXT_VALID = 0;
HASHKEY_VALID = 0;
#30
HASHKEY_VALID = 1;
HASHKEY = 128'h73A23D80121DE2D5A850253FCF43120E;
#15

//Authentication 
CTEXT = 128'hD609B1F056637A0D46DF998D88E52E00;
HASHKEY = 128'h73A23D80121DE2D5A850253FCF43120E;
CTEXT_VALID = 1;
HASHKEY_VALID = 1;
NEXT = 1;
#10
NEXT = 0;
//expected result: 9CABBD91899C1413AA7AD629C1DF12CD
check_result(128'h9CABBD91899C1413AA7AD629C1DF12CD);

CTEXT_VALID = 0;
HASHKEY_VALID = 1;
#30
HASHKEY_VALID = 1;
HASHKEY = 128'h73A23D80121DE2D5A850253FCF43120E;
#15

//Authentication 
CTEXT = 128'h9CABBD91899C1413AA7AD629C1DF12CD ^ 128'hB2C2846512153524C0895E8100000000;
//CTEXT = 128'hB2C2846512153524C0895E81;
HASHKEY = 128'h73A23D80121DE2D5A850253FCF43120E;
CTEXT_VALID = 1;
HASHKEY_VALID = 1;
NEXT = 1;
#50
NEXT = 0;
//expected result: B99ABF6BDBD18B8E148F8030F0686F28
check_result(128'hB99ABF6BDBD18B8E148F8030F0686F28);

CTEXT_VALID = 0;
HASHKEY_VALID = 0;
#30

/*
//CTEXT 1
CTEXT = RESULT ^ 128'h701AFA1CC039C0D765128A665DAB6924;
HASHKEY = 128'h73A23D80121DE2D5A850253FCF43120E;
//expected result: 8B5BD74B9A65A459150392C3872BCE7F
check_result(128'h8B5BD74B9A65A459150392C3872BCE7F);

CTEXT_VALID = 0;
HASHKEY_VALID = 0;
#30
 
//CTEXT 2
CTEXT = RESULT ^ 128'h3899BF7318CCDC81C9931DA17FBE8EDD;
HASHKEY = 128'h73A23D80121DE2D5A850253FCF43120E;
//expected result: 934E9D58C59230EE652675D0FF4FB255
check_result(128'h934E9D58C59230EE652675D0FF4FB255);

CTEXT_VALID = 0;
HASHKEY_VALID = 0;
#30

//CTEXT 3
CTEXT = RESULT ^ 128'h7D17CB8B4C26FC81E3284F2B7FBA713D;
HASHKEY = 128'h73A23D80121DE2D5A850253FCF43120E;
//expected result: 4738D208B10FAFF24D6DFBDDC916DC44
check_result(128'h4738D208B10FAFF24D6DFBDDC916DC44);

CTEXT_VALID = 0;
HASHKEY_VALID = 0;
#30

CTEXT = 128'h988477a4dcb89947a8373a9e3532de9f; 
HASHKEY = 128'hacbef20579b4b8ebce889bac8732dad7;
//expected result: 29de812309d3116a6eff7ec844484f3e
check_result(128'h29de812309d3116a6eff7ec844484f3e);

CTEXT_VALID = 0;
HASHKEY_VALID = 0;
#30

CTEXT = 128'ha56e0f6b50deaa57c94ff5d812cac706; 
HASHKEY = 128'hacbef20579b4b8ebce889bac8732dad7;
//expected result: 45fad9deeda9ea561b8f199c3613845b
check_result(128'h45fad9deeda9ea561b8f199c3613845b);

CTEXT_VALID = 0;
HASHKEY_VALID = 0;
#30

CTEXT = 128'ha56e0f6b50deaa57c94ff5d812cac707; 
HASHKEY = 128'hacbef20579b4b8ebce889bac8732dad7;
//expected result: 29de812309d3116a6eff7ec844484f3e
check_result(128'ha26c4d1bce48adfc0068dad14ec14d23);

CTEXT_VALID = 0;
HASHKEY_VALID = 0;
#30*/
$finish;
end

endmodule

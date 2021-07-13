module tb_gfmul();
reg [0:127] CTEXT;
reg [0:127] HASHKEY;
wire [0:127] RESULT;

reg [0:127] R;

gfmul GFMUL(
.iR(R),
.iCtext(CTEXT),
.iHashkey(HASHKEY),
.oResult(RESULT)
);

initial begin
R = {8'b1110_0001, 120'd0};
CTEXT = 0;
HASHKEY = 0;
#30
CTEXT = 128'h0388DACE60B6A392F328C2B971B2FE78;
HASHKEY = 128'h66E94BD4EF8A2C3B884CFA59CA342B2E;
#30
//Authentication 
CTEXT = 128'hD609B1F056637A0D46DF998D88E52E00;
        
HASHKEY = 128'h73A23D80121DE2D5A850253FCF43120E;
//expected result: 9CABBD91899C1413AA7AD629C1DF12CD
#30
//Authentication 
CTEXT = RESULT ^ 128'hB2C2846512153524C0895E8100000000;
//CTEXT = 128'hB2C2846512153524C0895E81;
HASHKEY = 128'h73A23D80121DE2D5A850253FCF43120E;
//expected result: B99ABF6BDBD18B8E148F8030F0686F28
#30
//CTEXT 1
CTEXT = RESULT ^ 128'h701AFA1CC039C0D765128A665DAB6924;
HASHKEY = 128'h73A23D80121DE2D5A850253FCF43120E;
//expected result: 8B5BD74B9A65A459150392C3872BCE7F
#30
//CTEXT 2
CTEXT = RESULT ^ 128'h3899BF7318CCDC81C9931DA17FBE8EDD;
HASHKEY = 128'h73A23D80121DE2D5A850253FCF43120E;
//expected result: 934E9D58C59230EE652675D0FF4FB255
#30
//CTEXT 3
CTEXT = RESULT ^ 128'h7D17CB8B4C26FC81E3284F2B7FBA713D;
HASHKEY = 128'h73A23D80121DE2D5A850253FCF43120E;
//expected result: 4738D208B10FAFF24D6DFBDDC916DC44
#30
CTEXT = 128'h988477a4dcb89947a8373a9e3532de9f; 
HASHKEY = 128'hacbef20579b4b8ebce889bac8732dad7;
//expected result: 29de812309d3116a6eff7ec844484f3e
#30
CTEXT = 128'ha56e0f6b50deaa57c94ff5d812cac706; 
HASHKEY = 128'hacbef20579b4b8ebce889bac8732dad7;
//expected result: 45fad9deeda9ea561b8f199c3613845b
#30
CTEXT = 128'ha56e0f6b50deaa57c94ff5d812cac707; 
HASHKEY = 128'hacbef20579b4b8ebce889bac8732dad7;
//expected result: 29de812309d3116a6eff7ec844484f3e
#30
$finish;
end


endmodule
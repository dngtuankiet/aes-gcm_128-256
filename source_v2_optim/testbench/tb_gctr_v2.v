module tb_gctr_v2();
reg CLK;
reg RST;
reg ENCDEC;
reg INIT;
reg OPMODE;

reg [0:95] IV;
reg IV_VALID;
reg [0:255] KEY;
reg KEY_VALID;
reg KEYLEN;
reg Y0;

reg HASHKEY;
reg [0:127] BLOCK;
reg BLOCK_VALID;
wire [0:127] RESULT;
wire RESULT_VALID;

parameter AES_GCM = 0;
parameter AES_ONLY = 1;
parameter INIT_AES_CORE = 1;
parameter ENC_MODE = 1;
parameter DEC_MODE = 0;
parameter HASHKEY_YES = 1;
parameter HASHKEY_NO = 0;
parameter Y0_YES = 1;
parameter Y0_NO = 0;
parameter AES_128_BIT_KEY = 0;
parameter AES_256_BIT_KEY = 1;

gctr_block_v2 U1(
.iClk(CLK),
.iRstn(RST),
.iInit(INIT),

.iIV(IV),
.iIV_valid(IV_VALID),
.iKey(KEY),
.iKey_valid(KEY_VALID),
.iKeylen(KEYLEN),
.iY0(Y0),

.iHashKey(HASHKEY),
.iBlock(BLOCK),
.iBlock_valid(BLOCK_VALID),
.oResult(RESULT),
.oResult_valid(RESULT_VALID)
);

//----------------------------------------------
//test case task
//----------------------------------------------

task gctr_block_test(
input init,
input [0:95] iv,
input iv_valid,
input [0:255] key,
input key_valid,
input keylen,
input y0,
input hashkey,
input [0:127] block,
input block_valid
);
	begin 
		INIT = init;

		IV = iv;
		IV_VALID = iv_valid;

		KEY = key;
		KEY_VALID = key_valid;
		KEYLEN = keylen; //256 = 1
		Y0 = y0;
		
		HASHKEY = hashkey;
		BLOCK = block;
		BLOCK_VALID = block_valid;

		@(posedge CLK)
		INIT = 0;
		@(posedge CLK)
		
		//ENCDEC = 0;

		// IV = 0;
		// IV_VALID = 0;
		// KEY = 0;
		// KEY_VALID = 0;
		// KEYLEN = 0;

		// BLOCK = 0;
		// BLOCK_VALID = 0;

		@(posedge RESULT_VALID);
		INIT = 0;
		HASHKEY = 0;
		Y0 = 0;
	end
endtask

//------------------------------------
//	Declare test case and initial value
//	Testcase taken from https://www.ieee802.org/1/files/public/docs2011/bn-randall-test-vectors-0511-v1.pdf, 2.2.2 60-byte Packet Encryption Using GCM-AES-256
//	key size = 256 bits
//	P: 384 bits
//	A: 224 bits
//	IV: 96 bits
//	ICV: 128 bits
/*	Expected results:
H: hashkey
Y: input of aes_core
E: output of aes_core
C: cipher text, output of gctr_block

GCM-AES Encryption
H: 286D73994EA0BA3CFD1F52BF06A8ACF2
Y[0]: 12153524C0895E81B2C2846500000001
E(K,Y[0]): 714D54FDCFCEE37D5729CDDAB383A016

Y[1]: 12153524C0895E81B2C2846500000002
E(K,Y[1]): EA0061A43E406416388D0E8A42DE02CB
C[1]: E2006EB42F5277022D9B19925BC419D7

Y[2]: 12153524C0895E81B2C2846500000003
E(K,Y[2]): B88C794CB37DC1CB54A893CB21C5C18B
C[2]: A592666C925FE2EF718EB4E308EFEAA7

Y[3]: 12153524C0895E81B2C2846500000004
E(K,Y[3]): E8091409702AB53E6ED49E476F917834
C[3]: C5273B394118860A5BE2A97F56AB7836

X[1]: D62D2B0792C282A27B82C3731ABCB7A1
X[2]: 841068CDEDA878030E644F03743927D0
X[3]: 224CE5247BE62FB2AC5932EFAC5D1991
X[4]: EB66718E589AB6472880D1A2C908CB72
X[5]: 6D109A3C7F34085754FDDFF0EB5D4595
GHASH(H,A,C): 2DE8C33074F038F04D389C30B9741420

*/
//------------------------------------

reg [0:95] 	test_256_iv;
reg [0:255] test_256_key;
reg [0:127] test_256_block_1;
reg [0:127] test_256_block_2;
reg [0:127] test_256_block_3;

reg [0:95] test_128_iv;
reg [0:255] test_128_key;
reg [0:127] test_128_block_1;
reg [0:127] test_128_block_2;
reg [0:127] test_128_block_3;

reg [0:95] test_dec_256_iv;
reg [0:255] test_dec_256_key;
reg [0:127] test_dec_256_block_1;
reg [0:127] test_dec_256_block_2;
reg [0:127] test_dec_256_block_3;

reg [0:127] test_aes_256_block;
reg [0:255] test_aes_256_key;
reg [0:127] test_aes_256_cipher_block;

initial begin
CLK = 0;
RST = 0;
INIT = 0;

IV = 0;
IV_VALID = 0;
KEY = 0;
KEY_VALID = 0;
KEYLEN = 0;
Y0 = 0;

HASHKEY = 0;
BLOCK = 0;
BLOCK_VALID = 0;

test_256_iv = 96'h12153524C0895E81B2C28465;
test_256_key = 256'hE3C08A8F06C6E3AD95A70557B23F75483CE33021A9C72B7025666204C69C0B72;
test_256_block_1 = 128'h08000F101112131415161718191A1B1C;
test_256_block_2 = 128'h1D1E1F202122232425262728292A2B2C;
test_256_block_3 = 128'h2D2E2F303132333435363738393A0002;

test_128_iv = 96'h12153524C0895E81B2C28465;
test_128_key = {128'hAD7A2BD03EAC835A6F620FDCB506B345, 128'd0};
test_128_block_1 = 128'h08000F101112131415161718191A1B1C;
test_128_block_2 = 128'h1D1E1F202122232425262728292A2B2C;
test_128_block_3 = 128'h2D2E2F303132333435363738393A0002;

test_dec_256_iv = 96'h12153524C0895E81B2C28465;
test_dec_256_key = 256'hE3C08A8F06C6E3AD95A70557B23F75483CE33021A9C72B7025666204C69C0B72;
test_dec_256_block_1 = 128'hE2006EB42F5277022D9B19925BC419D7;
test_dec_256_block_2 = 128'hA592666C925FE2EF718EB4E308EFEAA7;
test_dec_256_block_3 = 128'hC5273B394118860A5BE2A97F56AB7836;

// test_aes_256_block = 128'h00112233445566778899aabbccddeeff;
// test_aes_256_key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
// test_aes_256_cipher_block = 128'h8ea2b7ca516745bfeafc49904b496089;
end

always #5 CLK = ~CLK;



initial begin
#30 
RST = 1;
#20
@(posedge CLK)

//--------------------------------------------------------------------------------------
//			TEST GCRT Enc 256 Mode
//--------------------------------------------------------------------------------------
//init the aes_core with hashkey, the input iv, key, block are ingnored in this case
gctr_block_test(INIT_AES_CORE, test_256_iv, 1'b1 /*valid iv*/, test_256_key, 1'b1 /*valid key*/, AES_256_BIT_KEY, Y0_NO, HASHKEY_YES, test_256_block_1, 1'b0  /*valid block*/);

//test with test_block_1
gctr_block_test(INIT_AES_CORE, test_256_iv, 1'b1 /*valid iv*/, test_256_key, 1'b1 /*valid key*/, AES_256_BIT_KEY, Y0_NO, HASHKEY_NO, test_256_block_1, 1'b1  /*valid block*/);

//At this point, the GCTR_BLOCK Init is turn off
//the output of the previous block (RESULT + RESULT_VALID) SHOULD remain
#100


//test with test_block_2
gctr_block_test(INIT_AES_CORE, test_256_iv, 1'b1 /*valid iv*/, test_256_key, 1'b1 /*valid key*/, AES_256_BIT_KEY, Y0_NO, HASHKEY_NO, test_256_block_2, 1'b1  /*valid block*/);


//test with test_block_3
gctr_block_test(INIT_AES_CORE, test_256_iv, 1'b1 /*valid iv*/, test_256_key, 1'b1 /*valid key*/, AES_256_BIT_KEY, Y0_NO, HASHKEY_NO, test_256_block_3, 1'b1  /*valid block*/);

//test with Y0
gctr_block_test(INIT_AES_CORE, test_256_iv, 1'b1 /*valid iv*/, test_256_key, 1'b1 /*valid key*/, AES_256_BIT_KEY, Y0_YES, HASHKEY_NO, test_256_block_3, 1'b0  /*valid block*/);


#30 
RST = 0;
#30 
RST = 1;

//--------------------------------------------------------------------------------------
//			TEST GCRT Enc 128 Mode
//--------------------------------------------------------------------------------------
//init the aes_core with hashkey, the input iv, key, block are ingnored in this case
gctr_block_test(INIT_AES_CORE, test_128_iv, 1'b1 /*valid iv*/, test_128_key, 1'b1 /*valid key*/, AES_128_BIT_KEY, Y0_NO, HASHKEY_YES, test_128_block_1, 1'b0  /*valid block*/);

//test with test_block_1
gctr_block_test(INIT_AES_CORE, test_128_iv, 1'b1 /*valid iv*/, test_128_key, 1'b1 /*valid key*/, AES_128_BIT_KEY, Y0_NO, HASHKEY_NO, test_128_block_1, 1'b1  /*valid block*/);

//test with test_block_2
gctr_block_test(INIT_AES_CORE, test_128_iv, 1'b1 /*valid iv*/, test_128_key, 1'b1 /*valid key*/, AES_128_BIT_KEY, Y0_NO, HASHKEY_NO, test_128_block_2, 1'b1  /*valid block*/);

//test with test_block_3
gctr_block_test(INIT_AES_CORE, test_128_iv, 1'b1 /*valid iv*/, test_128_key, 1'b1 /*valid key*/, AES_128_BIT_KEY, Y0_NO, HASHKEY_NO, test_128_block_3, 1'b1  /*valid block*/);

//test with Y0
gctr_block_test(INIT_AES_CORE, test_128_iv, 1'b1 /*valid iv*/, test_128_key, 1'b1 /*valid key*/, AES_128_BIT_KEY, Y0_YES, HASHKEY_NO, test_128_block_3, 1'b0  /*valid block*/);

#30 
RST = 0;
#30 
RST = 1;



//--------------------------------------------------------------------------------------
//			TEST GCRT Dec 256 Mode
//--------------------------------------------------------------------------------------
//init the aes_core with hashkey, the input iv, key, block are ingnored in this case
gctr_block_test(INIT_AES_CORE, test_dec_256_iv, 1'b1 /*valid iv*/, test_dec_256_key, 1'b1 /*valid key*/, AES_256_BIT_KEY, Y0_NO, HASHKEY_YES, test_dec_256_block_1, 1'b0  /*valid block*/);

//test with test_block_1
gctr_block_test(INIT_AES_CORE, test_dec_256_iv, 1'b1 /*valid iv*/, test_dec_256_key, 1'b1 /*valid key*/, AES_256_BIT_KEY, Y0_NO, HASHKEY_NO, test_dec_256_block_1, 1'b1  /*valid block*/);

//test with test_block_2
gctr_block_test(INIT_AES_CORE, test_dec_256_iv, 1'b1 /*valid iv*/, test_dec_256_key, 1'b1 /*valid key*/, AES_256_BIT_KEY, Y0_NO, HASHKEY_NO, test_dec_256_block_2, 1'b1  /*valid block*/);

//test with test_block_3
gctr_block_test(INIT_AES_CORE, test_dec_256_iv, 1'b1 /*valid iv*/, test_dec_256_key, 1'b1 /*valid key*/, AES_256_BIT_KEY, Y0_NO, HASHKEY_NO, test_dec_256_block_3, 1'b1  /*valid block*/);

//test with Y0
gctr_block_test(INIT_AES_CORE, test_dec_256_iv, 1'b1 /*valid iv*/, test_dec_256_key, 1'b1 /*valid key*/, AES_256_BIT_KEY, Y0_YES, HASHKEY_NO, test_dec_256_block_3, 1'b0  /*valid block*/);

#30 
RST = 0;
#30 
RST = 1;

// //--------------------------------------------------------------------------------------
// //			TEST AES Only Enc 256 Mode
// //--------------------------------------------------------------------------------------

// //test with test_block
// gctr_block_test(INIT_AES_CORE, AES_ONLY, ENC_MODE, test_dec_256_iv, 1'b0 /*valid iv*/, test_aes_256_key, 1'b1 /*valid key*/, AES_256_BIT_KEY, Y0_NO, HASHKEY_NO, test_aes_256_block, 1'b1  /*valid block*/);
// #30 
// RST = 0;
// #30 
// RST = 1;

// //--------------------------------------------------------------------------------------
// //			TEST AES Only Dec 256 Mode
// //--------------------------------------------------------------------------------------

// //test with test_block
// gctr_block_test(INIT_AES_CORE, AES_ONLY, DEC_MODE, test_dec_256_iv, 1'b0 /*valid iv*/, test_aes_256_key, 1'b1 /*valid key*/, AES_256_BIT_KEY, Y0_NO, HASHKEY_NO, test_aes_256_cipher_block, 1'b1  /*valid block*/);

// #100
// RST = 0;
// #30 
// RST = 1;

$finish;
end

endmodule




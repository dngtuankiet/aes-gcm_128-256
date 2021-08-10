module tb_aes_gcm_v4();
reg CLK;
reg RST;
//control
reg INIT;
reg NEXT;
reg ENCDEC;
wire [0:3] CTRL;
//data
reg [0:95] IV;
reg IV_VAL;
reg [0:255] KEY;
reg KEY_VAL;
reg KEYLEN;

reg [0:127] AAD;
reg AAD_VAL;
reg AAD_LAST;

reg [0:127] BLOCK;
reg BLOCK_VAL;
reg BLOCK_LAST;

reg [0:127] AUTHENTIC_TAG;
reg AUTHENTIC_TAG_VAL;
//output
wire READY;
wire [0:127] RESULT;
wire RESULT_VAL;
wire [0:127] TAG;
wire TAG_VAL;
wire AUTHENTIC;

parameter AES_GCM = 0;
parameter AES_ONLY = 1;
parameter INIT_AES_GCM_CORE = 1;
parameter ENC_MODE = 1;
parameter DEC_MODE = 0;
parameter HASHKEY_YES = 1;
parameter HASHKEY_NO = 0;
parameter AES_128_BIT_KEY = 0;
parameter AES_256_BIT_KEY = 1;

reg AAD_ONLY;
assign CTRL = {INIT, NEXT, ENCDEC, AAD_ONLY};
aes_gcm_v4 DUT(
.iClk(CLK),
.iRstn(RST),
// .iInit(INIT),
// .iNext(NEXT),
// .iEncdec(ENCDEC),
.iCtrl(CTRL),
.oReady(READY),
.iIV(IV),
.iIV_valid(IV_VAL),
.iKey(KEY),
.iKey_valid(KEY_VAL),
.iKeylen(KEYLEN),
.iAad(AAD),
.iAad_valid(AAD_VAL),
.iAad_last(AAD_LAST),
.iBlock(BLOCK),
.iBlock_valid(BLOCK_VAL),
.iBlock_last(BLOCK_LAST),
.iTag(AUTHENTIC_TAG),
.iTag_valid(AUTHENTIC_TAG_VAL),
.oResult(RESULT),
.oResult_valid(RESULT_VAL),
.oTag(TAG),
.oTag_valid(TAG_VAL),
.oAuthentic(AUTHENTIC)
);

//test case 1
reg [0:255] testcase1_256_key;
reg [0:95] testcase1_256_iv;
reg [0:127] testcase1_256_block_1;
reg [0:127] testcase1_256_block_2;
reg [0:127] testcase1_256_block_3;
reg [0:127] testcase1_256_aad_1;
reg [0:127] testcase1_256_aad_2;
reg [0:127] testcase1_256_len;
//--expected--//
reg [0:127] testcase1_cipher_256 [2:0];
reg [0:127] testcase1_tag_256;

//test case 2
reg [0:255] testcase2_128_key;
reg [0:95] 	testcase2_128_iv;
reg [0:127] testcase2_128_block_1;
reg [0:127] testcase2_128_block_2;
reg [0:127] testcase2_128_block_3;
reg [0:127] testcase2_128_aad_1;
reg [0:127] testcase2_128_aad_2;
reg [0:127] testcase2_128_len;
//--expected--//
reg [0:127] testcase2_cipher_128 [2:0];
reg [0:127] testcase2_tag_128;

//test case 3 - //test case 15 at: https://luca-giuzzi.unibs.it/corsi/Support/papers-cryptography/gcm-spec.pdf
reg [0:255] testcase3_256_key;
reg [0:95] testcase3_256_iv;
reg [0:127] testcase3_256_block_1;
reg [0:127] testcase3_256_block_2;
reg [0:127] testcase3_256_block_3;
reg [0:127] testcase3_256_block_4;
reg [0:127] testcase3_256_add_empty;
reg [0:127] testcase3_256_len;
//--expected--//
reg [0:127] testcase3_cipher_256 [3:0];
reg [0:127] testcase3_tag_256;

//test case 4 - //2.5.2 at: https://www.ieee802.org/1/files/public/docs2011/bn-randall-test-vectors-0511-v1.pdf
reg [0:255] testcase4_256_key;
reg [0:95] testcase4_256_iv;
reg [0:127] testcase4_256_block_empty;
reg [0:127] testcase4_256_aad_1;
reg [0:127] testcase4_256_aad_2;
reg [0:127] testcase4_256_aad_3;
reg [0:127] testcase4_256_aad_4;
reg [0:127] testcase4_256_aad_5;
reg [0:127] testcase4_256_aad_6;
reg [0:127] testcase4_256_len;
//--expected--//
reg [0:127] testcase4_tag_256;

//test case 5
reg [0:255] testcase5_256_key;
reg [0:95] testcase5_256_iv;
reg [0:127] testcase5_256_block_1;
reg [0:127] testcase5_256_block_2;
reg [0:127] testcase5_256_block_3;
reg [0:127] testcase5_256_aad_1;
reg [0:127] testcase5_256_aad_2;
reg [0:127] testcase5_256_len;
//--expected--//
reg [0:127] testcase5_cipher_256 [2:0];
reg [0:127] testcase5_tag_256;

integer error_cnt;
integer cipher_cnt;

initial begin
CLK = 0;
RST = 0;
NEXT = 0;
// INIT = 0;
// ENCDEC = 0;
AAD_ONLY = 1'b0;

IV = 0;
IV_VAL = 0;
KEY = 0;
KEY_VAL = 0;
KEYLEN = 0;

AAD = 0;
AAD_VAL = 0;
AAD_LAST = 0;

BLOCK = 0;
BLOCK_VAL = 0;
BLOCK_LAST = 0;

AUTHENTIC_TAG = 0;
AUTHENTIC_TAG_VAL = 0;

error_cnt = 0;

//test case 1: with both AAD and Block
testcase1_256_key = 256'hE3C08A8F06C6E3AD95A70557B23F75483CE33021A9C72B7025666204C69C0B72;
testcase1_256_block_1 = 128'h08000F101112131415161718191A1B1C;
testcase1_256_block_2 = 128'h1D1E1F202122232425262728292A2B2C;
testcase1_256_block_3 = 128'h2D2E2F303132333435363738393A0002;
testcase1_256_aad_1 = 128'hD609B1F056637A0D46DF998D88E52E00;
testcase1_256_aad_2 = 128'hB2C2846512153524C0895E81_00000000;
testcase1_256_iv = 96'h12153524C0895E81B2C28465;
testcase1_256_len = 128'h00000000000000E0_0000000000000180;
//--expected--//
testcase1_cipher_256[0] = 128'hE2006EB42F5277022D9B19925BC419D7;
testcase1_cipher_256[1] = 128'hA592666C925FE2EF718EB4E308EFEAA7;
testcase1_cipher_256[2] = 128'hC5273B394118860A5BE2A97F56AB7836;
testcase1_tag_256 = 128'h5CA597CDBB3EDB8D1A1151EA0AF7B436;

//------------------------------------------------------------------

//test case 2: with both AAD and Block
testcase2_128_key = {128'hAD7A2BD03EAC835A6F620FDCB506B345,128'd0};
testcase2_128_iv = 96'h12153524C0895E81B2C28465;
testcase2_128_block_1 = 128'h08000F101112131415161718191A1B1C;
testcase2_128_block_2 = 128'h1D1E1F202122232425262728292A2B2C;
testcase2_128_block_3 = 128'h2D2E2F303132333435363738393A0002;
testcase2_128_aad_1 = 128'hD609B1F056637A0D46DF998D88E52E00;
testcase2_128_aad_2 = 128'hB2C2846512153524C0895E81_00000000;
testcase2_128_len = 128'h00000000000000E0_0000000000000180;
//--expected--//
testcase2_cipher_128[0] = 128'h701AFA1CC039C0D765128A665DAB6924;
testcase2_cipher_128[1] = 128'h3899BF7318CCDC81C9931DA17FBE8EDD;
testcase2_cipher_128[2] = 128'h7D17CB8B4C26FC81E3284F2B7FBA713D;
testcase2_tag_128 = 128'h4F8D55E7D3F06FD5A13C0C29B9D5B880;

//------------------------------------------------------------------

//test case 3: without AAD
testcase3_256_key = 256'hfeffe9928665731c6d6a8f9467308308_feffe9928665731c6d6a8f9467308308;
testcase3_256_block_1 = 128'hd9313225f88406e5a55909c5aff5269a;
testcase3_256_block_2 = 128'h86a7a9531534f7da2e4c303d8a318a72;
testcase3_256_block_3 = 128'h1c3c0c95956809532fcf0e2449a6b525;
testcase3_256_block_4 = 128'hb16aedf5aa0de657ba637b391aafd255;
testcase3_256_add_empty = 128'd0;
testcase3_256_iv = 96'hcafebabefacedbaddecaf888;
testcase3_256_len = 128'h00000000000000000000000000000200;
//--expected--//
testcase3_cipher_256[0] = 128'h522dc1f099567d07f47f37a32a84427d;
testcase3_cipher_256[1] = 128'h643a8cdcbfe5c0c97598a2bd2555d1aa;
testcase3_cipher_256[2] = 128'h8cb08e48590dbb3da7b08b1056828838;
testcase3_cipher_256[3] = 128'hc5f61e6393ba7a0abcc9f662898015ad;
testcase3_tag_256 = 128'hb094dac5d93471bdec1a502270e3cc6c;

//------------------------------------------------------------------

//test case 4: Authentication without Plaintext
testcase4_256_key = 256'h83C093B58DE7FFE1C0DA926AC43FB360_9AC1C80FEE1B624497EF942E2F79A823;
testcase4_256_block_empty = 128'd0;
testcase4_256_aad_1 = 128'h84C5D513D2AAF6E5BBD2727788E52300;
testcase4_256_aad_2 = 128'h8932D6127CFDE9F9E33724C608000F10;
testcase4_256_aad_3 = 128'h1112131415161718191A1B1C1D1E1F20;
testcase4_256_aad_4 = 128'h2122232425262728292A2B2C2D2E2F30;
testcase4_256_aad_5 = 128'h3132333435363738393A3B3C3D3E3F00;
testcase4_256_aad_6 = 128'h05000000000000000000000000000000;
testcase4_256_iv = 96'h7CFDE9F9E33724C68932D612;
testcase4_256_len = 128'h0000000000000288_0000000000000000;
//--expected--/
testcase4_tag_256 = 128'h6EE160E8FAECA4B36C86B234920CA975;

//------------------------------------------------------------------

//test case 5: decryption with both AAD and Block
testcase5_256_key = 256'hE3C08A8F06C6E3AD95A70557B23F75483CE33021A9C72B7025666204C69C0B72;
testcase5_256_block_1 = 128'hE2006EB42F5277022D9B19925BC419D7;
testcase5_256_block_2 = 128'hA592666C925FE2EF718EB4E308EFEAA7;
testcase5_256_block_3 = 128'hC5273B394118860A5BE2A97F56AB7836;
testcase5_256_aad_1 = 128'hD609B1F056637A0D46DF998D88E52E00;
testcase5_256_aad_2 = 128'hB2C2846512153524C0895E81_00000000;
testcase5_256_iv = 96'h12153524C0895E81B2C28465;
testcase5_256_len = 128'h00000000000000E0_0000000000000180;
//--expected--//
testcase5_cipher_256[0] = 128'h08000F101112131415161718191A1B1C;
testcase5_cipher_256[1] = 128'h1D1E1F202122232425262728292A2B2C;
testcase5_cipher_256[2] = 128'h2D2E2F303132333435363738393A0002;
testcase5_tag_256 = 128'h5CA597CDBB3EDB8D1A1151EA0AF7B436;

end

always #5 CLK = ~CLK;

task aes_gcm_block_test(
input init,
input encdec,

input [0:95] iv,
input iv_valid,
input [0:255] key,
input key_valid,
input keylen,

input [0:127] aad,
input aad_valid,
input aad_last,

input [0:127] block,
input block_valid,
input block_last,
input [0:127] expected_result,
input [0:127] expected_tag
);
	begin
	INIT = init;
	
	ENCDEC = encdec;
	
	IV = iv;
	IV_VAL = iv_valid;
	KEY = key;
	KEY_VAL = key_valid;
	KEYLEN = keylen;
	
	AAD = aad;
	AAD_VAL = aad_valid;
	AAD_LAST = aad_last;
	
	BLOCK = block;
	BLOCK_VAL = block_valid;
	BLOCK_LAST = block_last;
	
	// @(posedge CLK);
	// if (BLOCK_LAST) begin 
	// 	@(posedge TAG_VAL);
	// 	check_tag(expected_tag);
	// end
	// else if(~aad_valid) begin
	// 	@(posedge READY);
	// 	check_cipher(expected_result);
	// end

    //after loading the data, set NEXT in the control reg to process
    #20
	NEXT = 1;


	@(posedge READY);
    check_cipher(expected_result);
	NEXT = 0;
	end
endtask

task check_cipher(
input [0:127] expected
);
begin
	if(RESULT_VAL) begin
		if(RESULT == expected) begin
			$display("***Correct Ciphertext");
			end
		else
		begin
			$display("Expected: 0x%032x", expected);
			$display("Got:      0x%032x", RESULT);
			$display("");
			error_cnt = error_cnt + 1;
		end
		cipher_cnt = cipher_cnt + 1;
	end
end
endtask

task check_tag(
input [0:127] expected
);
begin
	if(TAG_VAL) begin
		if(TAG == expected) begin
			$display("***Correct Tag");
			end
		else
		begin
            $display("***Wrong Tag");
			$display("Expected: 0x%032x", expected);
			$display("Got:      0x%032x", TAG);
			$display("");
		end
	end
end
endtask

task reset();
begin
	RST = 0;
	INIT = 0;
	NEXT = 0;
	ENCDEC = 0;
    AAD_ONLY = 0;

	IV = 0;
	IV_VAL = 0;
	KEY = 0;
	KEY_VAL = 0;
	KEYLEN = 0;

	AAD = 0;
	AAD_VAL = 0;
	AAD_LAST = 0;

	BLOCK = 0;
	BLOCK_VAL = 0;
	BLOCK_LAST = 0;
	#100
	RST = 1;
	#200
	@(posedge CLK);
end
endtask


initial begin
#30
RST = 1;
#20
@(posedge CLK);


//------------------------------------------------------------------------------
//TEST CASE 1
//------------------------------------------------------------------------------
$display("Checking test case 1 AES-GCM Enc with 256b Key, both AAD and Plaintext");
error_cnt = 0;
cipher_cnt = 0;

//KEY
aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase1_256_iv, 1'b1 /*iv val*/, testcase1_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase1_256_aad_1, 1'b0 /*aad val*/, 1'b0 /*aad last*/, testcase1_256_block_1, 1'b0 /*block val*/, 1'b0 /*block_last*/, 128'd0, testcase1_tag_256);
//AAD
aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase1_256_iv, 1'b1 /*iv val*/, testcase1_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase1_256_aad_1, 1'b1 /*aad val*/, 1'b0 /*aad last*/, testcase1_256_block_1, 1'b0 /*block val*/, 1'b0 /*block_last*/, 128'd0, testcase1_tag_256);
#30
aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase1_256_iv, 1'b1 /*iv val*/, testcase1_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase1_256_aad_2, 1'b1 /*aad val*/, 1'b1 /*aad last*/, testcase1_256_block_1, 1'b0 /*block val*/, 1'b0 /*block_last*/, 128'd0, testcase1_tag_256);
#70
//BLOCK
aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase1_256_iv, 1'b1 /*iv val*/, testcase1_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase1_256_aad_2, 1'b0 /*aad val*/, 1'b0 /*aad last*/, testcase1_256_block_1, 1'b1 /*block val*/, 1'b0 /*block_last*/,testcase1_cipher_256[0], testcase1_tag_256);
#50
aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase1_256_iv, 1'b1 /*iv val*/, testcase1_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase1_256_aad_2, 1'b0 /*aad val*/, 1'b0 /*aad last*/, testcase1_256_block_2, 1'b1 /*block val*/, 1'b0 /*block_last*/, testcase1_cipher_256[1], testcase1_tag_256);
#50
aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase1_256_iv, 1'b1 /*iv val*/, testcase1_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase1_256_len, 1'b0 /*aad val*/, 1'b0 /*aad last*/, testcase1_256_block_3, 1'b1 /*block val*/, 1'b1 /*block_last*/, testcase1_cipher_256[2], testcase1_tag_256);
#50
//LEN
aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase1_256_iv, 1'b1 /*iv val*/, testcase1_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase1_256_len, 1'b1 /*aad val*/, 1'b0 /*aad last*/, testcase1_256_block_1, 1'b0 /*block val*/, 1'b0 /*block_last*/, 128'd0, testcase1_tag_256);

check_tag(testcase1_tag_256);

$display("Checking test case 1 done with %d ERROR Ciphertext", error_cnt);
$display("");
reset();
#5000
//------------------------------------------------------------------------------
//TEST CASE 2
//------------------------------------------------------------------------------
$display("Checking test case 2 AES-GCM Enc with 128b Key, both AAD and Plaintext");
error_cnt = 0;
cipher_cnt = 0;
//KEY
aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase2_128_iv, 1'b1 /*iv val*/, testcase2_128_key, 1'b1 /*key val*/, AES_128_BIT_KEY,
testcase2_128_aad_1, 1'b0 /*aad val*/, 1'b0 /*aad last*/, testcase2_128_block_1, 1'b0 /*block val*/, 1'b0 /*block_last*/, 128'd0, testcase2_tag_128);
//AAD
aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase2_128_iv, 1'b1 /*iv val*/, testcase2_128_key, 1'b1 /*key val*/, AES_128_BIT_KEY,
testcase2_128_aad_1, 1'b1 /*aad val*/, 1'b0 /*aad last*/, testcase2_128_block_1, 1'b0 /*block val*/, 1'b0 /*block_last*/,  128'd0,testcase2_tag_128);
aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase2_128_iv, 1'b1 /*iv val*/, testcase2_128_key, 1'b1 /*key val*/, AES_128_BIT_KEY,
testcase2_128_aad_2, 1'b1 /*aad val*/, 1'b1 /*aad last*/, testcase2_128_block_1, 1'b0 /*block val*/, 1'b0 /*block_last*/,  128'd0,testcase2_tag_128);
//BLOCK
aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase2_128_iv, 1'b1 /*iv val*/, testcase2_128_key, 1'b1 /*key val*/, AES_128_BIT_KEY,
testcase2_128_aad_2, 1'b0 /*aad val*/, 1'b0 /*aad last*/, testcase2_128_block_1, 1'b1 /*block val*/, 1'b0 /*block_last*/, testcase2_cipher_128[0], testcase2_tag_128);

aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase2_128_iv, 1'b1 /*iv val*/, testcase2_128_key, 1'b1 /*key val*/, AES_128_BIT_KEY,
testcase2_128_aad_2, 1'b0 /*aad val*/, 1'b0 /*aad last*/, testcase2_128_block_2, 1'b1 /*block val*/, 1'b0 /*block_last*/, testcase2_cipher_128[1], testcase2_tag_128);

aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase2_128_iv, 1'b1 /*iv val*/, testcase2_128_key, 1'b1 /*key val*/, AES_128_BIT_KEY,
testcase2_128_len, 1'b0 /*aad val*/, 1'b0 /*aad last*/, testcase2_128_block_3, 1'b1 /*block val*/, 1'b1 /*block_last*/, testcase2_cipher_128[2], testcase2_tag_128);

//LEN
aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase2_128_iv, 1'b1 /*iv val*/, testcase2_128_key, 1'b1 /*key val*/, AES_128_BIT_KEY,
testcase2_128_len, 1'b1 /*aad val*/, 1'b0 /*aad last*/, testcase2_128_block_1, 1'b0 /*block val*/, 1'b0 /*block_last*/, 128'd0, testcase2_tag_128);

check_tag(testcase2_tag_128);
$display("Checking test case 2 done with %d ERROR Ciphertext", error_cnt);
$display("");
reset();
#5000
//------------------------------------------------------------------------------
//TEST CASE 3
//------------------------------------------------------------------------------
$display("Checking test case 3 AES-GCM Enc with 256b Key, only Plaintext without AAD");
error_cnt = 0;
cipher_cnt = 0;
//KEY
aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase3_256_iv, 1'b1 /*iv val*/, testcase3_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase1_256_aad_1, 1'b0 /*aad val*/, 1'b0 /*aad last*/, testcase3_256_block_1, 1'b0 /*block val*/, 1'b0 /*block_last*/, 128'd0, testcase3_tag_256);
//BLOCK
aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase3_256_iv, 1'b1 /*iv val*/, testcase3_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase3_256_add_empty, 1'b0 /*aad val*/, 1'b0 /*aad last*/, testcase3_256_block_1, 1'b1 /*block val*/, 1'b0 /*block_last*/, testcase3_cipher_256[0], testcase3_tag_256);

aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase3_256_iv, 1'b1 /*iv val*/, testcase3_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase3_256_add_empty, 1'b0 /*aad val*/, 1'b0 /*aad last*/, testcase3_256_block_2, 1'b1 /*block val*/, 1'b0 /*block_last*/, testcase3_cipher_256[1], testcase3_tag_256);

aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase3_256_iv, 1'b1 /*iv val*/, testcase3_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase3_256_add_empty, 1'b0 /*aad val*/, 1'b0 /*aad last*/, testcase3_256_block_3, 1'b1 /*block val*/, 1'b0 /*block_last*/, testcase3_cipher_256[2], testcase3_tag_256);

aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase3_256_iv, 1'b1 /*iv val*/, testcase3_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase3_256_len, 1'b0 /*aad val*/, 1'b0 /*aad last*/, testcase3_256_block_4, 1'b1 /*block val*/, 1'b1 /*block_last*/, testcase3_cipher_256[3], testcase3_tag_256);

//LEN
aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase3_256_iv, 1'b1 /*iv val*/, testcase3_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase3_256_len, 1'b1 /*aad val*/, 1'b0 /*aad last*/, testcase1_256_block_1, 1'b0 /*block val*/, 1'b0 /*block_last*/, 128'd0, testcase3_tag_256);
check_tag(testcase3_tag_256);
$display("Checking test case 3 done with %d ERROR Ciphertext", error_cnt);
$display("");
#300
reset();
#5000
//------------------------------------------------------------------------------
//TEST CASE 4
//------------------------------------------------------------------------------
$display("Checking test case 4 AES-GCM Enc with 256b Key, only AAD without Plaintext");
error_cnt = 0;
cipher_cnt = 0;
//KEY
aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase4_256_iv, 1'b1 /*iv val*/, testcase4_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase1_256_aad_1, 1'b0 /*aad val*/, 1'b0 /*aad last*/, testcase1_256_block_1, 1'b0 /*block val*/, 1'b0 /*block_last*/, 128'd0, testcase4_tag_256);
//AAD
aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase4_256_iv, 1'b1 /*iv val*/, testcase4_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase4_256_aad_1, 1'b1 /*aad val*/, 1'b0 /*aad last*/, testcase4_256_block_empty, 1'b0 /*block val*/, 1'b0 /*block_last*/, 128'd0, testcase4_tag_256);
aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase4_256_iv, 1'b1 /*iv val*/, testcase4_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase4_256_aad_2, 1'b1 /*aad val*/, 1'b0 /*aad last*/, testcase4_256_block_empty, 1'b0 /*block val*/, 1'b0 /*block_last*/, 128'd0, testcase4_tag_256);
aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase4_256_iv, 1'b1 /*iv val*/, testcase4_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase4_256_aad_3, 1'b1 /*aad val*/, 1'b0 /*aad last*/, testcase4_256_block_empty, 1'b0 /*block val*/, 1'b0 /*block_last*/, 128'd0, testcase4_tag_256);
aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase4_256_iv, 1'b1 /*iv val*/, testcase4_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase4_256_aad_4, 1'b1 /*aad val*/, 1'b0 /*aad last*/, testcase4_256_block_empty, 1'b0 /*block val*/, 1'b0 /*block_last*/, 128'd0, testcase4_tag_256);
aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase4_256_iv, 1'b1 /*iv val*/, testcase4_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase4_256_aad_5, 1'b1 /*aad val*/, 1'b0 /*aad last*/, testcase4_256_block_empty, 1'b0 /*block val*/, 1'b0 /*block_last*/, 128'd0, testcase4_tag_256);
aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase4_256_iv, 1'b1 /*iv val*/, testcase4_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase4_256_aad_6, 1'b1 /*aad val*/, 1'b1 /*aad last*/, testcase4_256_block_empty, 1'b0 /*block val*/, 1'b0 /*block_last*/, 128'd0, testcase4_tag_256);
// //BLOCK
// aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase4_256_iv, 1'b1 /*iv val*/, testcase4_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
// testcase4_256_len, 1'b0 /*aad val*/, 1'b0 /*aad last*/, testcase4_256_block_empty, 1'b1 /*block val*/, 1'b1 /*block_last*/, 128'd0, testcase4_tag_256);
AAD_ONLY = 1'b1;
//LEN
aes_gcm_block_test(INIT_AES_GCM_CORE, ENC_MODE, testcase4_256_iv, 1'b1 /*iv val*/, testcase4_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase4_256_len, 1'b1 /*aad val*/, 1'b0 /*aad last*/, testcase4_256_block_empty, 1'b0 /*block val*/, 1'b0 /*block_last*/, 128'd0, testcase4_tag_256);
check_tag(testcase4_tag_256);
$display("Checking test case 4 done with %d ERROR Ciphertext", error_cnt);
$display("");
#300
reset();
#5000

//------------------------------------------------------------------------------
//TEST CASE 5
//------------------------------------------------------------------------------
$display("Checking test case 5 AES-GCM Dec with 256b Key, both AAD and Plaintext");
error_cnt = 0;
cipher_cnt = 0;

//KEY
AUTHENTIC_TAG = 128'h5CA597CDBB3EDB8D1A1151EA0AF7B436;
AUTHENTIC_TAG_VAL = 1;
aes_gcm_block_test(INIT_AES_GCM_CORE, DEC_MODE, testcase5_256_iv, 1'b1 /*iv val*/, testcase5_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase5_256_aad_1, 1'b0 /*aad val*/, 1'b0 /*aad last*/, testcase5_256_block_1, 1'b0 /*block val*/, 1'b0 /*block_last*/, 128'd0, testcase5_tag_256);
AUTHENTIC_TAG = 0;
AUTHENTIC_TAG_VAL = 0;
//AAD
aes_gcm_block_test(INIT_AES_GCM_CORE, DEC_MODE, testcase5_256_iv, 1'b1 /*iv val*/, testcase5_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase5_256_aad_1, 1'b1 /*aad val*/, 1'b0 /*aad last*/, testcase5_256_block_1, 1'b0 /*block val*/, 1'b0 /*block_last*/, 128'd0, testcase5_tag_256);
aes_gcm_block_test(INIT_AES_GCM_CORE, DEC_MODE, testcase5_256_iv, 1'b1 /*iv val*/, testcase5_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase5_256_aad_2, 1'b1 /*aad val*/, 1'b1 /*aad last*/, testcase5_256_block_1, 1'b0 /*block val*/, 1'b0 /*block_last*/, 128'd0, testcase5_tag_256);
//BLOCK
aes_gcm_block_test(INIT_AES_GCM_CORE, DEC_MODE, testcase5_256_iv, 1'b1 /*iv val*/, testcase5_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase5_256_aad_2, 1'b0 /*aad val*/, 1'b0 /*aad last*/, testcase5_256_block_1, 1'b1 /*block val*/, 1'b0 /*block_last*/, testcase5_cipher_256[0], testcase5_tag_256);

aes_gcm_block_test(INIT_AES_GCM_CORE, DEC_MODE, testcase5_256_iv, 1'b1 /*iv val*/, testcase5_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase5_256_aad_2, 1'b0 /*aad val*/, 1'b0 /*aad last*/, testcase5_256_block_2, 1'b1 /*block val*/, 1'b0 /*block_last*/, testcase5_cipher_256[1], testcase5_tag_256);

aes_gcm_block_test(INIT_AES_GCM_CORE, DEC_MODE, testcase5_256_iv, 1'b1 /*iv val*/, testcase5_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase5_256_len, 1'b0 /*aad val*/, 1'b0 /*aad last*/, testcase5_256_block_3, 1'b1 /*block val*/, 1'b1 /*block_last*/, testcase5_cipher_256[2], testcase5_tag_256);

//LEN
aes_gcm_block_test(INIT_AES_GCM_CORE, DEC_MODE, testcase5_256_iv, 1'b1 /*iv val*/, testcase5_256_key, 1'b1 /*key val*/, AES_256_BIT_KEY,
testcase5_256_len, 1'b1 /*aad val*/, 1'b0 /*aad last*/, testcase5_256_block_1, 1'b0 /*block val*/, 1'b0 /*block_last*/, 128'd0, testcase5_tag_256);
check_tag(testcase5_tag_256);
$display("Checking test case 5 done with %d ERROR Ciphertext", error_cnt);
$display("");
#300
reset();
#5000

$finish;
end


endmodule

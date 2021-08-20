module k_tb();

  //----------------------------------------------------------------
  // Internal constant and parameter definitions.
  //----------------------------------------------------------------
  parameter DEBUG     = 0;
  parameter DUMP_WAIT = 0;

  parameter CLK_HALF_PERIOD = 5;
  parameter CLK_PERIOD = 2 * CLK_HALF_PERIOD;

  parameter AES_128_BIT_KEY = 0;
  parameter AES_256_BIT_KEY = 1;

  parameter AES_DECIPHER = 1'b0;
  parameter AES_ENCIPHER = 1'b1;
  
  //----------------------------------------------------------------
  // Register and Wire declarations.
  //----------------------------------------------------------------
  reg [31 : 0] cycle_ctr;
  reg [31 : 0] error_ctr;
  reg [31 : 0] tc_ctr;

  reg            tb_clk;
  reg            tb_reset_n;
  reg            tb_encdec;
  reg            tb_init;
  reg            tb_next;
  wire           tb_ready;
  reg [255 : 0]  tb_key;
  reg            tb_keylen;
  reg [127 : 0]  tb_block;
  wire [127 : 0] tb_result;
  wire           tb_result_valid;


  //----------------------------------------------------------------
  // Device Under Test.
  //----------------------------------------------------------------
  aes_core_TOP dut(
	.ICLK			(tb_clk),
	.IRSTN			(tb_reset_n),
	.IENCDEC		(tb_encdec),
	.IINIT			(tb_init),
	.INEXT			(tb_next),
	.OREADY			(tb_ready),
	.IKEY			(tb_key),
	.IKEYLEN		(tb_keylen),
	.IBLOCK			(tb_block),
	.ORESULT		(tb_result),
	.ORESULT_VALID	(tb_result_valid)
  );

  //----------------------------------------------------------------
  // clk_gen
  //
  // Always running clock generator process.
  //----------------------------------------------------------------
  always
    begin : clk_gen
      #CLK_HALF_PERIOD;
      tb_clk = !tb_clk;
    end // clk_gen
    
   //----------------------------------------------------------------
  // init_sim()
  //
  // Initialize all counters and testbed functionality as well
  // as setting the DUT inputs to defined values.
  //----------------------------------------------------------------
  task init_sim;
    begin
      cycle_ctr = 0;
      error_ctr = 0;
      tc_ctr    = 0;

      tb_clk     = 0;
      tb_reset_n = 1;
      tb_encdec  = 0;
      tb_init    = 0;
      tb_next    = 0;
      tb_key     = {8{32'h00000000}};
      tb_keylen  = 0;

      tb_block  = {4{32'h00000000}};
    end
  endtask // init_sim  
  
   task reset_dut;
    begin
      $display("*** Toggle reset.");
      tb_reset_n = 0;
      #(2 * CLK_PERIOD);
      tb_reset_n = 1;
    end
  endtask // reset_dut
  
   //----------------------------------------------------------------
  // dump_dut_state()
  //
  // Dump the state of the dump when needed.
  //----------------------------------------------------------------
  task dump_dut_state;
    begin
      $display("State of DUT");
      $display("------------");
      $display("Inputs and outputs:");
      $display("encdec = 0x%01x, init = 0x%01x, next = 0x%01x",
               dut.IENCDEC, dut.IINIT, dut.INEXT);
      $display("keylen = 0x%01x, key  = 0x%032x ", dut.IKEYLEN, dut.IKEY);
      $display("block  = 0x%032x", dut.IBLOCK);
      $display("");
      $display("ready        = 0x%01x", dut.OREADY);
      $display("result_valid = 0x%01x, result = 0x%032x",
               dut.ORESULT_VALID, dut.ORESULT);
      $display("");
      $display("Encipher state::");
      $display("enc_ctrl = 0x%01x, round_ctr = 0x%01x",
               dut.U1.enc_block.enc_ctrl_reg, dut.U1.enc_block.round_ctr_reg);
      $display("");
    end
  endtask // dump_dut_state
  
  task dump_keys;
    begin
      $display("State of key memory in DUT:");
      $display("key[00] = 0x%016x", dut.U1.keymem.key_mem0);
      $display("key[01] = 0x%016x", dut.U1.keymem.key_mem1);
      $display("key[02] = 0x%016x", dut.U1.keymem.key_mem2);
      $display("key[03] = 0x%016x", dut.U1.keymem.key_mem3);
      $display("key[04] = 0x%016x", dut.U1.keymem.key_mem4);
      $display("key[05] = 0x%016x", dut.U1.keymem.key_mem5);
      $display("key[06] = 0x%016x", dut.U1.keymem.key_mem6);
      $display("key[07] = 0x%016x", dut.U1.keymem.key_mem7);
      $display("key[08] = 0x%016x", dut.U1.keymem.key_mem8);
      $display("key[09] = 0x%016x", dut.U1.keymem.key_mem9);
      $display("key[10] = 0x%016x", dut.U1.keymem.key_mem10);
      $display("key[11] = 0x%016x", dut.U1.keymem.key_mem11);
      $display("key[12] = 0x%016x", dut.U1.keymem.key_mem12);
      $display("key[13] = 0x%016x", dut.U1.keymem.key_mem13);
      $display("key[14] = 0x%016x", dut.U1.keymem.key_mem14);
      $display("");
    end
  endtask // dump_keys  
    
  //----------------------------------------------------------------
  // wait_ready()
  //
  // Wait for the ready flag in the dut to be set.
  //
  // Note: It is the callers responsibility to call the function
  // when the dut is actively processing and will in fact at some
  // point set the flag.
  //----------------------------------------------------------------  
  task wait_ready;
    begin
      while (!tb_ready)
        begin
          #(CLK_PERIOD);
          if (DUMP_WAIT)
            begin
              dump_dut_state();
            end
        end
    end
  endtask // wait_ready  
  
  //----------------------------------------------------------------
  // ecb_mode_single_block_test()
  //
  // Perform ECB mode encryption or decryption single block test.
  //----------------------------------------------------------------
  task ecb_mode_single_block_test(input [7 : 0]   tc_number,
                                  input           encdec,
                                  input [255 : 0] key,
                                  input           key_length,
                                  input [127 : 0] block,
                                  input [127 : 0] expected);
   begin
     $display("*** TC %0d ECB mode test started.", tc_number);
     tc_ctr = tc_ctr + 1;

     // Init the cipher with the given key and length.
     tb_key = key;
     tb_keylen = key_length;
     tb_init = 1;
     #(2 * CLK_PERIOD);
     tb_init = 0;
     wait_ready();

     $display("Key expansion done");
     $display("");

     dump_keys();


     // Perform encipher och decipher operation on the block.
     tb_encdec = encdec;
     tb_block = block;
     tb_next = 1;
     #(2 * CLK_PERIOD);
     tb_next = 0;
     wait_ready();

     if (tb_result == expected)
       begin
         $display("*** TC %0d successful.", tc_number);
         $display("");
       end
     else
       begin
         $display("*** ERROR: TC %0d NOT successful.", tc_number);
         $display("Expected: 0x%032x", expected);
         $display("Got:      0x%032x", tb_result);
         $display("");

         error_ctr = error_ctr + 1;
       end
   end
  endtask // ecb_mode_single_block_test
  
  
      reg [255 : 0] nist_aes256_key;
    reg [127 : 0] nist_plaintext0;
    reg [127 : 0] nist_ecb_256_enc_expected0;
  initial begin
    nist_aes256_key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
    nist_plaintext0 = 128'h00112233445566778899aabbccddeeff;
     nist_ecb_256_enc_expected0 = 128'h8ea2b7ca516745bfeafc49904b496089;
     
    $display("   -= Testbench for aes core started =-");
      $display("     ================================");
      $display("");

      init_sim();
      dump_dut_state();
      reset_dut();
      dump_dut_state();


      $display("ECB 256 bit key tests");
      $display("---------------------");
      ecb_mode_single_block_test(8'h01, AES_ENCIPHER, nist_aes256_key, AES_256_BIT_KEY,
                                 nist_plaintext0, nist_ecb_256_enc_expected0);
  end


endmodule
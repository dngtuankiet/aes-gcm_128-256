library verilog;
use verilog.vl_types.all;
entity k_tb is
    generic(
        DEBUG           : integer := 0;
        DUMP_WAIT       : integer := 0;
        CLK_HALF_PERIOD : integer := 5;
        CLK_PERIOD      : vl_notype;
        AES_128_BIT_KEY : integer := 0;
        AES_256_BIT_KEY : integer := 1;
        AES_DECIPHER    : vl_logic := Hi0;
        AES_ENCIPHER    : vl_logic := Hi1
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DEBUG : constant is 1;
    attribute mti_svvh_generic_type of DUMP_WAIT : constant is 1;
    attribute mti_svvh_generic_type of CLK_HALF_PERIOD : constant is 1;
    attribute mti_svvh_generic_type of CLK_PERIOD : constant is 3;
    attribute mti_svvh_generic_type of AES_128_BIT_KEY : constant is 1;
    attribute mti_svvh_generic_type of AES_256_BIT_KEY : constant is 1;
    attribute mti_svvh_generic_type of AES_DECIPHER : constant is 1;
    attribute mti_svvh_generic_type of AES_ENCIPHER : constant is 1;
end k_tb;

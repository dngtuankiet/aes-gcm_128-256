library verilog;
use verilog.vl_types.all;
entity tb_aes_gcm_v4 is
    generic(
        AES_GCM         : integer := 0;
        AES_ONLY        : integer := 1;
        INIT_AES_GCM_CORE: integer := 1;
        ENC_MODE        : integer := 1;
        DEC_MODE        : integer := 0;
        HASHKEY_YES     : integer := 1;
        HASHKEY_NO      : integer := 0;
        AES_128_BIT_KEY : integer := 0;
        AES_256_BIT_KEY : integer := 1
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of AES_GCM : constant is 1;
    attribute mti_svvh_generic_type of AES_ONLY : constant is 1;
    attribute mti_svvh_generic_type of INIT_AES_GCM_CORE : constant is 1;
    attribute mti_svvh_generic_type of ENC_MODE : constant is 1;
    attribute mti_svvh_generic_type of DEC_MODE : constant is 1;
    attribute mti_svvh_generic_type of HASHKEY_YES : constant is 1;
    attribute mti_svvh_generic_type of HASHKEY_NO : constant is 1;
    attribute mti_svvh_generic_type of AES_128_BIT_KEY : constant is 1;
    attribute mti_svvh_generic_type of AES_256_BIT_KEY : constant is 1;
end tb_aes_gcm_v4;

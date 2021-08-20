library verilog;
use verilog.vl_types.all;
entity aes_gcm_v4 is
    generic(
        IDLE            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        CAL_HASHKEY     : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        CAL_ADD         : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        CIPHER          : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        TAG             : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0);
        TAG2            : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi1)
    );
    port(
        iClk            : in     vl_logic;
        iRstn           : in     vl_logic;
        iCtrl           : in     vl_logic_vector(0 to 3);
        oReady          : out    vl_logic;
        iIV             : in     vl_logic_vector(0 to 95);
        iIV_valid       : in     vl_logic;
        iKey            : in     vl_logic_vector(0 to 255);
        iKey_valid      : in     vl_logic;
        iKeylen         : in     vl_logic;
        iAad            : in     vl_logic_vector(0 to 127);
        iAad_valid      : in     vl_logic;
        iBlock          : in     vl_logic_vector(0 to 127);
        iBlock_valid    : in     vl_logic;
        iTag            : in     vl_logic_vector(0 to 127);
        iTag_valid      : in     vl_logic;
        oResult         : out    vl_logic_vector(0 to 127);
        oResult_valid   : out    vl_logic;
        oTag            : out    vl_logic_vector(0 to 127);
        oTag_valid      : out    vl_logic;
        oAuthentic      : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of CAL_HASHKEY : constant is 1;
    attribute mti_svvh_generic_type of CAL_ADD : constant is 1;
    attribute mti_svvh_generic_type of CIPHER : constant is 1;
    attribute mti_svvh_generic_type of TAG : constant is 1;
    attribute mti_svvh_generic_type of TAG2 : constant is 1;
end aes_gcm_v4;

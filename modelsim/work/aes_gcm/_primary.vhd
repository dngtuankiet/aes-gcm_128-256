library verilog;
use verilog.vl_types.all;
entity aes_gcm is
    port(
        iClk            : in     vl_logic;
        iRstn           : in     vl_logic;
        iInit           : in     vl_logic;
        iEncdec         : in     vl_logic;
        iOpMode         : in     vl_logic;
        oReady          : out    vl_logic;
        iIV             : in     vl_logic_vector(0 to 95);
        iIV_valid       : in     vl_logic;
        iKey            : in     vl_logic_vector(0 to 255);
        iKey_valid      : in     vl_logic;
        iKeylen         : in     vl_logic;
        iAad            : in     vl_logic_vector(0 to 127);
        iAad_valid      : in     vl_logic;
        iAad_last       : in     vl_logic;
        iBlock          : in     vl_logic_vector(0 to 127);
        iBlock_valid    : in     vl_logic;
        iBlock_last     : in     vl_logic;
        iTag            : in     vl_logic_vector(0 to 127);
        iTag_valid      : in     vl_logic;
        oResult         : out    vl_logic_vector(0 to 127);
        oResult_valid   : out    vl_logic;
        oTag            : out    vl_logic_vector(0 to 127);
        oTag_valid      : out    vl_logic;
        oAuthentic      : out    vl_logic
    );
end aes_gcm;

library verilog;
use verilog.vl_types.all;
entity gctr_block is
    port(
        iClk            : in     vl_logic;
        iRstn           : in     vl_logic;
        iEncdec         : in     vl_logic;
        iInit           : in     vl_logic;
        iOpMode         : in     vl_logic;
        iIV             : in     vl_logic_vector(0 to 95);
        iIV_valid       : in     vl_logic;
        iKey            : in     vl_logic_vector(0 to 255);
        iKey_valid      : in     vl_logic;
        iKeylen         : in     vl_logic;
        iY0             : in     vl_logic;
        iHashKey        : in     vl_logic;
        iBlock          : in     vl_logic_vector(0 to 127);
        iBlock_valid    : in     vl_logic;
        oResult         : out    vl_logic_vector(0 to 127);
        oResult_valid   : out    vl_logic
    );
end gctr_block;

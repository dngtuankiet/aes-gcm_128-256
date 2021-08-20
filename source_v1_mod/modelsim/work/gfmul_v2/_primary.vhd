library verilog;
use verilog.vl_types.all;
entity gfmul_v2 is
    port(
        iClk            : in     vl_logic;
        iRstn           : in     vl_logic;
        iNext           : in     vl_logic;
        iCtext          : in     vl_logic_vector(0 to 127);
        iCtext_valid    : in     vl_logic;
        iHashkey        : in     vl_logic_vector(0 to 127);
        iHashkey_valid  : in     vl_logic;
        oResult         : out    vl_logic_vector(0 to 127);
        oResult_valid   : out    vl_logic
    );
end gfmul_v2;

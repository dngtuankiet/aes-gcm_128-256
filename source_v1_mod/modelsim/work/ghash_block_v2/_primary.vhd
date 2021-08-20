library verilog;
use verilog.vl_types.all;
entity ghash_block_v2 is
    port(
        iClk            : in     vl_logic;
        iRstn           : in     vl_logic;
        iNext           : in     vl_logic;
        iCtext          : in     vl_logic_vector(0 to 127);
        iCtext_valid    : in     vl_logic;
        iY              : in     vl_logic_vector(0 to 127);
        iHashkey        : in     vl_logic_vector(0 to 127);
        iHashkey_valid  : in     vl_logic;
        oY              : out    vl_logic_vector(0 to 127);
        oY_valid        : out    vl_logic
    );
end ghash_block_v2;

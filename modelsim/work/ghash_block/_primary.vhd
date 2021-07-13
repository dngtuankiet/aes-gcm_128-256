library verilog;
use verilog.vl_types.all;
entity ghash_block is
    port(
        iCtext          : in     vl_logic_vector(0 to 127);
        iY              : in     vl_logic_vector(0 to 127);
        iHashkey        : in     vl_logic_vector(0 to 127);
        oY              : out    vl_logic_vector(0 to 127)
    );
end ghash_block;

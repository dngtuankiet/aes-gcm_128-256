library verilog;
use verilog.vl_types.all;
entity gfmul is
    port(
        iCtext          : in     vl_logic_vector(0 to 127);
        iHashkey        : in     vl_logic_vector(0 to 127);
        oResult         : out    vl_logic_vector(0 to 127)
    );
end gfmul;

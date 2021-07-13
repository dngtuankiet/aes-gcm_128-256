library verilog;
use verilog.vl_types.all;
entity mixw is
    port(
        w               : in     vl_logic_vector(31 downto 0);
        \out\           : out    vl_logic_vector(31 downto 0)
    );
end mixw;

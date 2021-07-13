library verilog;
use verilog.vl_types.all;
entity aes_core_TOP_wrapper is
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        encdec          : in     vl_logic;
        init            : in     vl_logic;
        \next\          : in     vl_logic;
        ready           : out    vl_logic;
        key             : in     vl_logic_vector(255 downto 0);
        keylen          : in     vl_logic;
        \block\         : in     vl_logic_vector(127 downto 0);
        result          : out    vl_logic_vector(127 downto 0);
        result_valid    : out    vl_logic
    );
end aes_core_TOP_wrapper;

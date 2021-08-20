library verilog;
use verilog.vl_types.all;
entity aes_core_TOP is
    port(
        ICLK            : in     vl_logic;
        IRSTN           : in     vl_logic;
        IENCDEC         : in     vl_logic;
        IINIT           : in     vl_logic;
        INEXT           : in     vl_logic;
        OREADY          : out    vl_logic;
        IKEY            : in     vl_logic_vector(255 downto 0);
        IKEYLEN         : in     vl_logic;
        IBLOCK          : in     vl_logic_vector(127 downto 0);
        ORESULT         : out    vl_logic_vector(127 downto 0);
        ORESULT_VALID   : out    vl_logic
    );
end aes_core_TOP;

library verilog;
use verilog.vl_types.all;
entity aes_key_mem is
    port(
        iClk            : in     vl_logic;
        iRstn           : in     vl_logic;
        iKey            : in     vl_logic_vector(255 downto 0);
        iKeylen         : in     vl_logic;
        iInit           : in     vl_logic;
        iRound          : in     vl_logic_vector(3 downto 0);
        oRound_key      : out    vl_logic_vector(127 downto 0);
        oReady          : out    vl_logic;
        oSboxw          : out    vl_logic_vector(31 downto 0);
        iNew_sboxw      : in     vl_logic_vector(31 downto 0)
    );
end aes_key_mem;

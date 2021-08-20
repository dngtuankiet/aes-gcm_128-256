library verilog;
use verilog.vl_types.all;
entity aes_encipher_block is
    port(
        iClk            : in     vl_logic;
        iRstn           : in     vl_logic;
        iNext           : in     vl_logic;
        iKeylen         : in     vl_logic;
        oRound          : out    vl_logic_vector(3 downto 0);
        iRound_key      : in     vl_logic_vector(127 downto 0);
        oSboxw          : out    vl_logic_vector(31 downto 0);
        iNew_sboxw      : in     vl_logic_vector(31 downto 0);
        iBlock          : in     vl_logic_vector(127 downto 0);
        oNew_block      : out    vl_logic_vector(127 downto 0);
        oReady          : out    vl_logic
    );
end aes_encipher_block;

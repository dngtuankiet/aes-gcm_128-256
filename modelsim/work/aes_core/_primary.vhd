library verilog;
use verilog.vl_types.all;
entity aes_core is
    port(
        iClk            : in     vl_logic;
        iRstn           : in     vl_logic;
        iEncdec         : in     vl_logic;
        iInit           : in     vl_logic;
        iNext           : in     vl_logic;
        oReady          : out    vl_logic;
        iKey            : in     vl_logic_vector(255 downto 0);
        iKeylen         : in     vl_logic;
        iBlock          : in     vl_logic_vector(127 downto 0);
        oResult         : out    vl_logic_vector(127 downto 0);
        oResult_valid   : out    vl_logic
    );
end aes_core;

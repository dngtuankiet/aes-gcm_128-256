library verilog;
use verilog.vl_types.all;
entity aes_gcm_TOP is
    port(
        ICLK            : in     vl_logic;
        IRSTN           : in     vl_logic;
        IINIT           : in     vl_logic;
        IENCDEC         : in     vl_logic;
        IOPMODE         : in     vl_logic;
        OREADY          : out    vl_logic;
        IIV             : in     vl_logic_vector(0 to 95);
        IIV_VALID       : in     vl_logic;
        IKEY            : in     vl_logic_vector(0 to 255);
        IKEY_VALID      : in     vl_logic;
        IKEYLEN         : in     vl_logic;
        IAAD            : in     vl_logic_vector(0 to 127);
        IAAD_VALID      : in     vl_logic;
        IAAD_LAST       : in     vl_logic;
        IBLOCK          : in     vl_logic_vector(0 to 127);
        IBLOCK_VALID    : in     vl_logic;
        IBLOCK_LAST     : in     vl_logic;
        ITAG            : in     vl_logic_vector(0 to 127);
        ITAG_VALID      : in     vl_logic;
        ORESULT         : out    vl_logic_vector(0 to 127);
        ORESULT_VALID   : out    vl_logic;
        OTAG            : out    vl_logic_vector(0 to 127);
        OTAG_VALID      : out    vl_logic;
        OAUTHENTIC      : out    vl_logic
    );
end aes_gcm_TOP;

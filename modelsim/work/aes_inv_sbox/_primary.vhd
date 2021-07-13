library verilog;
use verilog.vl_types.all;
entity aes_inv_sbox is
    port(
        \in\            : in     vl_logic_vector(31 downto 0);
        \out\           : out    vl_logic_vector(31 downto 0)
    );
end aes_inv_sbox;

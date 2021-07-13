onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group TB -radix hexadecimal /tb_gctr/CLK
add wave -noupdate -expand -group TB -radix hexadecimal /tb_gctr/RST
add wave -noupdate -expand -group TB -radix hexadecimal /tb_gctr/ENCDEC
add wave -noupdate -expand -group TB -radix hexadecimal /tb_gctr/INIT
add wave -noupdate -expand -group TB -radix hexadecimal /tb_gctr/OPMODE
add wave -noupdate -expand -group TB -radix hexadecimal /tb_gctr/IV
add wave -noupdate -expand -group TB -radix hexadecimal /tb_gctr/IV_VALID
add wave -noupdate -expand -group TB -radix hexadecimal /tb_gctr/KEY
add wave -noupdate -expand -group TB -radix hexadecimal /tb_gctr/KEY_VALID
add wave -noupdate -expand -group TB -radix hexadecimal /tb_gctr/KEYLEN
add wave -noupdate -expand -group TB -radix hexadecimal /tb_gctr/Y0
add wave -noupdate -expand -group TB -radix hexadecimal /tb_gctr/HASHKEY
add wave -noupdate -expand -group TB -color {Medium Spring Green} -radix hexadecimal /tb_gctr/BLOCK
add wave -noupdate -expand -group TB -color {Medium Spring Green} -radix hexadecimal /tb_gctr/BLOCK_VALID
add wave -noupdate -expand -group TB -color Gold -radix hexadecimal /tb_gctr/RESULT
add wave -noupdate -expand -group TB -color Gold -radix hexadecimal /tb_gctr/RESULT_VALID
add wave -noupdate -divider Internal
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/counter_reg
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/counter_en
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/block_reg
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/block_wen
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/encdec_reg
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/IV_reg
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/IV_wen
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/key_reg
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/key_wen
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/key_len
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/hashkey_reg
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/hashkey_wen
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/y0_reg
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/y0_wen
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/gctr_ctrl_reg
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/gctr_ctrl_new
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/gctr_result_valid
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/State0
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/State1
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/State2
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/State3
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/muxed_aes_core_input
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/aes_core_output
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/aes_core_init
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/aes_core_next
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/aes_core_oready
add wave -noupdate -expand -group {Internal signals} -radix hexadecimal /tb_gctr/U1/aes_core_output_valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {13308 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 264
configure wave -valuecolwidth 202
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {11895 ps} {15963 ps}

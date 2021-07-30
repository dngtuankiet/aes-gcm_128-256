onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Testbench -label CLK -radix hexadecimal /tb_gfmul_v2/CLK
add wave -noupdate -expand -group Testbench -label RST -radix hexadecimal /tb_gfmul_v2/RST
add wave -noupdate -expand -group Testbench -label CTEXT -radix hexadecimal /tb_gfmul_v2/CTEXT
add wave -noupdate -expand -group Testbench -label CTEXT_VALID -radix hexadecimal /tb_gfmul_v2/CTEXT_VALID
add wave -noupdate -expand -group Testbench -label HASHKEY -radix hexadecimal /tb_gfmul_v2/HASHKEY
add wave -noupdate -expand -group Testbench -label HASHKEY_VALID -radix hexadecimal /tb_gfmul_v2/HASHKEY_VALID
add wave -noupdate -expand -group Testbench -label RESULT -radix hexadecimal /tb_gfmul_v2/RESULT
add wave -noupdate -expand -group Testbench -label RESULT_VALID -radix hexadecimal /tb_gfmul_v2/RESULT_VALID
add wave -noupdate -expand -group GF_MUL -label iClk -radix hexadecimal /tb_gfmul_v2/GFMUL/iClk
add wave -noupdate -expand -group GF_MUL -label iRstn /tb_gfmul_v2/GFMUL/iRstn
add wave -noupdate -expand -group GF_MUL -label iCtext -radix hexadecimal /tb_gfmul_v2/GFMUL/iCtext
add wave -noupdate -expand -group GF_MUL -label iCtext_valid -radix hexadecimal /tb_gfmul_v2/GFMUL/iCtext_valid
add wave -noupdate -expand -group GF_MUL -label iHashkey -radix hexadecimal /tb_gfmul_v2/GFMUL/iHashkey
add wave -noupdate -expand -group GF_MUL -label iHashkey_valid -radix hexadecimal /tb_gfmul_v2/GFMUL/iHashkey_valid
add wave -noupdate -expand -group GF_MUL -label oResult -radix hexadecimal /tb_gfmul_v2/GFMUL/oResult
add wave -noupdate -expand -group GF_MUL -label oResult_valid -radix hexadecimal /tb_gfmul_v2/GFMUL/oResult_valid
add wave -noupdate -expand -group GF_MUL -label iR -radix hexadecimal /tb_gfmul_v2/GFMUL/iR
add wave -noupdate -expand -group GF_MUL -label cnt -radix unsigned /tb_gfmul_v2/GFMUL/cnt
add wave -noupdate -expand -group GF_MUL -label overflow /tb_gfmul_v2/GFMUL/overflow
add wave -noupdate -expand -group GF_MUL -divider V
add wave -noupdate -expand -group GF_MUL -label V -radix hexadecimal /tb_gfmul_v2/GFMUL/V
add wave -noupdate -expand -group GF_MUL -label V_and_xor -radix hexadecimal /tb_gfmul_v2/GFMUL/V_and_xor
add wave -noupdate -expand -group GF_MUL -label mux_V -radix hexadecimal /tb_gfmul_v2/GFMUL/mux_V
add wave -noupdate -expand -group GF_MUL -divider Z
add wave -noupdate -expand -group GF_MUL -label Z -radix hexadecimal /tb_gfmul_v2/GFMUL/Z
add wave -noupdate -expand -group GF_MUL -label Z_and_xor -radix hexadecimal /tb_gfmul_v2/GFMUL/Z_and_xor
add wave -noupdate -expand -group GF_MUL -label mux_sel /tb_gfmul_v2/GFMUL/mux_sel
add wave -noupdate -expand -group GF_MUL -label mux_Z_1 -radix hexadecimal /tb_gfmul_v2/GFMUL/mux_Z_1
add wave -noupdate -expand -group GF_MUL -label mux_Z_2 -radix hexadecimal /tb_gfmul_v2/GFMUL/mux_Z_2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1951 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {2777 ps}

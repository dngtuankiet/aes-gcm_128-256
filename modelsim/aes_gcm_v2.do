onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group TB -label CLK /tb_aes_gcm_v2/CLK
add wave -noupdate -group TB -label RST /tb_aes_gcm_v2/RST
add wave -noupdate -group TB -label OPMODE /tb_aes_gcm_v2/OPMODE
add wave -noupdate -group TB -label INIT /tb_aes_gcm_v2/INIT
add wave -noupdate -group TB -label ENCDEC /tb_aes_gcm_v2/ENCDEC
add wave -noupdate -group TB -label IV -radix hexadecimal /tb_aes_gcm_v2/IV
add wave -noupdate -group TB -label IV_VAL /tb_aes_gcm_v2/IV_VAL
add wave -noupdate -group TB -label KEY -radix hexadecimal /tb_aes_gcm_v2/KEY
add wave -noupdate -group TB -label KEY_VAL /tb_aes_gcm_v2/KEY_VAL
add wave -noupdate -group TB -label KEYLEN /tb_aes_gcm_v2/KEYLEN
add wave -noupdate -group TB -label AAD -radix hexadecimal /tb_aes_gcm_v2/AAD
add wave -noupdate -group TB -label AAD_VAL /tb_aes_gcm_v2/AAD_VAL
add wave -noupdate -group TB -label AAD_LAST /tb_aes_gcm_v2/AAD_LAST
add wave -noupdate -group TB -label BLOCK -radix hexadecimal /tb_aes_gcm_v2/BLOCK
add wave -noupdate -group TB -label BLOCK_VAL /tb_aes_gcm_v2/BLOCK_VAL
add wave -noupdate -group TB -label BLOCK_LAST /tb_aes_gcm_v2/BLOCK_LAST
add wave -noupdate -group TB -label AUTHENTIC_TAG -radix hexadecimal /tb_aes_gcm_v2/AUTHENTIC_TAG
add wave -noupdate -group TB -label AUTHENTIC_TAG_VAL /tb_aes_gcm_v2/AUTHENTIC_TAG_VAL
add wave -noupdate -group TB -label READY /tb_aes_gcm_v2/READY
add wave -noupdate -group TB -label RESULT -radix hexadecimal /tb_aes_gcm_v2/RESULT
add wave -noupdate -group TB -label RESULT_VAL /tb_aes_gcm_v2/RESULT_VAL
add wave -noupdate -group TB -label TAG -radix hexadecimal /tb_aes_gcm_v2/TAG
add wave -noupdate -group TB -label TAG_VAL /tb_aes_gcm_v2/TAG_VAL
add wave -noupdate -group TB -label AUTHENTIC /tb_aes_gcm_v2/AUTHENTIC
add wave -noupdate -expand -group GCTR -label gctr_init /tb_aes_gcm_v2/DUT/gctr_init
add wave -noupdate -expand -group GCTR -label gctr_mode /tb_aes_gcm_v2/DUT/gctr_mode
add wave -noupdate -expand -group GCTR -label gctr_hashkey_proc /tb_aes_gcm_v2/DUT/gctr_hashkey_proc
add wave -noupdate -expand -group GCTR -label gctr_y0 /tb_aes_gcm_v2/DUT/gctr_y0
add wave -noupdate -expand -group GCTR -label gctr_result -radix hexadecimal /tb_aes_gcm_v2/DUT/gctr_result
add wave -noupdate -expand -group GCTR -label gctr_result_valid /tb_aes_gcm_v2/DUT/gctr_result_valid
add wave -noupdate -expand -group GHASH -label ghash_result_reg -radix hexadecimal /tb_aes_gcm_v2/DUT/ghash_result_reg
add wave -noupdate -expand -group GHASH -label ghash_result_wen /tb_aes_gcm_v2/DUT/ghash_result_wen
add wave -noupdate -expand -group GHASH -label ghash_result_dec_wen /tb_aes_gcm_v2/DUT/ghash_result_dec_wen
add wave -noupdate -expand -group GHASH -label ghash_result -radix hexadecimal /tb_aes_gcm_v2/DUT/ghash_result
add wave -noupdate -expand -group GHASH -label ghash_input_signal /tb_aes_gcm_v2/DUT/ghash_input_signal
add wave -noupdate -expand -group Internal -label hash_key_reg -radix hexadecimal /tb_aes_gcm_v2/DUT/hash_key_reg
add wave -noupdate -expand -group Internal -label hash_key_wen /tb_aes_gcm_v2/DUT/hash_key_wen
add wave -noupdate -expand -group Internal -label y0_reg -radix hexadecimal /tb_aes_gcm_v2/DUT/y0_reg
add wave -noupdate -expand -group Internal -label y0_wen /tb_aes_gcm_v2/DUT/y0_wen
add wave -noupdate -expand -group Internal -label last_block /tb_aes_gcm_v2/DUT/last_block
add wave -noupdate -expand -group Internal -label muxed_ghash_input1 -radix hexadecimal /tb_aes_gcm_v2/DUT/muxed_ghash_input1
add wave -noupdate -expand -group Internal -label muxed_ghash_input2 -radix hexadecimal /tb_aes_gcm_v2/DUT/muxed_ghash_input2
add wave -noupdate -expand -group STATE -label aes_gcm_ctrl_reg -radix unsigned -radixenum symbolic /tb_aes_gcm_v2/DUT/aes_gcm_ctrl_reg
add wave -noupdate -expand -group STATE -label aes_gcm_ctrl_new -radix unsigned -radixenum symbolic /tb_aes_gcm_v2/DUT/aes_gcm_ctrl_new
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1106 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 182
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
WaveRestoreZoom {0 ps} {2090 ps}

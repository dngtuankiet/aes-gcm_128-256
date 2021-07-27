onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group TB -radix hexadecimal /tb_aes_gcm/CLK
add wave -noupdate -expand -group TB -radix hexadecimal /tb_aes_gcm/RST
add wave -noupdate -expand -group TB -radix hexadecimal /tb_aes_gcm/INIT
add wave -noupdate -expand -group TB -radix hexadecimal /tb_aes_gcm/ENCDEC
add wave -noupdate -expand -group TB /tb_aes_gcm/OPMODE
add wave -noupdate -expand -group TB -radix hexadecimal /tb_aes_gcm/IV
add wave -noupdate -expand -group TB -radix hexadecimal /tb_aes_gcm/IV_VAL
add wave -noupdate -expand -group TB -radix hexadecimal /tb_aes_gcm/KEY
add wave -noupdate -expand -group TB -radix hexadecimal /tb_aes_gcm/KEY_VAL
add wave -noupdate -expand -group TB -radix hexadecimal /tb_aes_gcm/KEYLEN
add wave -noupdate -expand -group TB -radix hexadecimal /tb_aes_gcm/AAD
add wave -noupdate -expand -group TB -radix hexadecimal /tb_aes_gcm/AAD_VAL
add wave -noupdate -expand -group TB -radix hexadecimal /tb_aes_gcm/AAD_LAST
add wave -noupdate -expand -group TB -radix hexadecimal /tb_aes_gcm/BLOCK
add wave -noupdate -expand -group TB -radix hexadecimal /tb_aes_gcm/BLOCK_VAL
add wave -noupdate -expand -group TB -radix hexadecimal /tb_aes_gcm/BLOCK_LAST
add wave -noupdate -expand -group TB -radix hexadecimal /tb_aes_gcm/READY
add wave -noupdate -expand -group TB -color Cyan -radix hexadecimal /tb_aes_gcm/RESULT
add wave -noupdate -expand -group TB -color Cyan -radix hexadecimal /tb_aes_gcm/RESULT_VAL
add wave -noupdate -expand -group TB -color Gold -radix hexadecimal /tb_aes_gcm/TAG
add wave -noupdate -expand -group TB -color Gold -radix hexadecimal /tb_aes_gcm/TAG_VAL
add wave -noupdate -radix hexadecimal /tb_aes_gcm/AUTHENTIC
add wave -noupdate -divider AES_GCM
add wave -noupdate -group AES_GCM -radix hexadecimal /tb_aes_gcm/DUT/iClk
add wave -noupdate -group AES_GCM -radix hexadecimal /tb_aes_gcm/DUT/iRstn
add wave -noupdate -group AES_GCM -radix hexadecimal /tb_aes_gcm/DUT/iInit
add wave -noupdate -group AES_GCM -radix hexadecimal /tb_aes_gcm/DUT/iEncdec
add wave -noupdate -group AES_GCM -radix hexadecimal /tb_aes_gcm/DUT/oReady
add wave -noupdate -group AES_GCM -radix hexadecimal /tb_aes_gcm/DUT/iIV
add wave -noupdate -group AES_GCM -radix hexadecimal /tb_aes_gcm/DUT/iIV_valid
add wave -noupdate -group AES_GCM -color Cyan -radix hexadecimal /tb_aes_gcm/DUT/iKey
add wave -noupdate -group AES_GCM -color Cyan -radix hexadecimal /tb_aes_gcm/DUT/iKey_valid
add wave -noupdate -group AES_GCM -color Cyan -radix hexadecimal /tb_aes_gcm/DUT/iKeylen
add wave -noupdate -group AES_GCM -color Magenta -radix hexadecimal /tb_aes_gcm/DUT/iAad
add wave -noupdate -group AES_GCM -color Magenta -radix hexadecimal /tb_aes_gcm/DUT/iAad_valid
add wave -noupdate -group AES_GCM -color Magenta -radix hexadecimal /tb_aes_gcm/DUT/iAad_last
add wave -noupdate -group AES_GCM -color Gold -radix hexadecimal /tb_aes_gcm/DUT/iBlock
add wave -noupdate -group AES_GCM -color Gold -radix hexadecimal /tb_aes_gcm/DUT/iBlock_valid
add wave -noupdate -group AES_GCM -color Gold -radix hexadecimal /tb_aes_gcm/DUT/iBlock_last
add wave -noupdate -group AES_GCM /tb_aes_gcm/DUT/last_block
add wave -noupdate -divider -height 30 Internal
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_aes_gcm/DUT/aes_gcm_ctrl_reg
add wave -noupdate -expand -group Internal -radix hexadecimal -childformat {{{/tb_aes_gcm/DUT/aes_gcm_ctrl_new[2]} -radix hexadecimal} {{/tb_aes_gcm/DUT/aes_gcm_ctrl_new[1]} -radix hexadecimal} {{/tb_aes_gcm/DUT/aes_gcm_ctrl_new[0]} -radix hexadecimal}} -subitemconfig {{/tb_aes_gcm/DUT/aes_gcm_ctrl_new[2]} {-height 15 -radix hexadecimal} {/tb_aes_gcm/DUT/aes_gcm_ctrl_new[1]} {-height 15 -radix hexadecimal} {/tb_aes_gcm/DUT/aes_gcm_ctrl_new[0]} {-height 15 -radix hexadecimal}} /tb_aes_gcm/DUT/aes_gcm_ctrl_new
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_aes_gcm/DUT/aes_gcm_ready
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_aes_gcm/DUT/gctr_init
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_aes_gcm/DUT/gctr_hashkey_proc
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_aes_gcm/DUT/gctr_result
add wave -noupdate -expand -group Internal -color {Steel Blue} -radix hexadecimal /tb_aes_gcm/DUT/gctr_result_valid
add wave -noupdate -expand -group Internal /tb_aes_gcm/DUT/gctr_y0
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_aes_gcm/DUT/y0_reg
add wave -noupdate -expand -group Internal /tb_aes_gcm/DUT/y0_wen
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_aes_gcm/DUT/hash_key_reg
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_aes_gcm/DUT/hash_key_wen
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_aes_gcm/DUT/ghash_result_reg
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_aes_gcm/DUT/ghash_result_wen
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_aes_gcm/DUT/ghash_input_signal
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_aes_gcm/DUT/ghash_result
add wave -noupdate -divider GHASH
add wave -noupdate -radix hexadecimal /tb_aes_gcm/DUT/GHASH/iCtext
add wave -noupdate -radix hexadecimal /tb_aes_gcm/DUT/GHASH/iY
add wave -noupdate -radix hexadecimal /tb_aes_gcm/DUT/GHASH/iHashkey
add wave -noupdate -radix hexadecimal /tb_aes_gcm/DUT/GHASH/oY
add wave -noupdate -radix hexadecimal /tb_aes_gcm/DUT/GHASH/wXor
add wave -noupdate -radix hexadecimal /tb_aes_gcm/DUT/GHASH/R
add wave -noupdate -divider GCTR
add wave -noupdate -group GCTR -radix hexadecimal /tb_aes_gcm/DUT/GCTR/iEncdec
add wave -noupdate -group GCTR -radix hexadecimal /tb_aes_gcm/DUT/GCTR/iInit
add wave -noupdate -group GCTR -radix hexadecimal /tb_aes_gcm/DUT/GCTR/iIV
add wave -noupdate -group GCTR -radix hexadecimal /tb_aes_gcm/DUT/GCTR/iIV_valid
add wave -noupdate -group GCTR -radix hexadecimal /tb_aes_gcm/DUT/GCTR/iKey
add wave -noupdate -group GCTR -radix hexadecimal /tb_aes_gcm/DUT/GCTR/iKey_valid
add wave -noupdate -group GCTR -radix hexadecimal /tb_aes_gcm/DUT/GCTR/iKeylen
add wave -noupdate -group GCTR /tb_aes_gcm/DUT/GCTR/iY0
add wave -noupdate -group GCTR /tb_aes_gcm/DUT/GCTR/y0_reg
add wave -noupdate -group GCTR /tb_aes_gcm/DUT/GCTR/y0_wen
add wave -noupdate -group GCTR -radix hexadecimal /tb_aes_gcm/DUT/GCTR/iHkey_indicator
add wave -noupdate -group GCTR -radix hexadecimal /tb_aes_gcm/DUT/GCTR/iBlock
add wave -noupdate -group GCTR -radix hexadecimal /tb_aes_gcm/DUT/GCTR/iBlock_valid
add wave -noupdate -group GCTR -radix hexadecimal /tb_aes_gcm/DUT/GCTR/oResult
add wave -noupdate -group GCTR -radix hexadecimal /tb_aes_gcm/DUT/GCTR/oResult_valid
add wave -noupdate -group GCTR -radix hexadecimal /tb_aes_gcm/DUT/GCTR/gctr_ctrl_reg
add wave -noupdate -group GCTR -radix hexadecimal /tb_aes_gcm/DUT/GCTR/gctr_ctrl_new
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14915 ps} 0}
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
WaveRestoreZoom {0 ps} {25930 ps}

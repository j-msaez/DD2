onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group agente /test_top/agente_spi/pos_X
add wave -noupdate -expand -group agente /test_top/agente_spi/pos_Y
add wave -noupdate -expand -group agente /test_top/agente_spi/estado
add wave -noupdate -expand -group agente -radix hexadecimal /test_top/agente_spi/reg_comandos
add wave -noupdate -expand -group agente -radix hexadecimal -childformat {{/test_top/agente_spi/reg_lecturas(31) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(30) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(29) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(28) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(27) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(26) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(25) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(24) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(23) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(22) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(21) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(20) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(19) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(18) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(17) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(16) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(15) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(14) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(13) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(12) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(11) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(10) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(9) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(8) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(7) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(6) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(5) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(4) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(3) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(2) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(1) -radix hexadecimal} {/test_top/agente_spi/reg_lecturas(0) -radix hexadecimal}} -subitemconfig {/test_top/agente_spi/reg_lecturas(31) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(30) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(29) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(28) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(27) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(26) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(25) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(24) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(23) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(22) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(21) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(20) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(19) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(18) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(17) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(16) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(15) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(14) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(13) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(12) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(11) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(10) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(9) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(8) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(7) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(6) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(5) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(4) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(3) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(2) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(1) {-height 15 -radix hexadecimal} /test_top/agente_spi/reg_lecturas(0) {-height 15 -radix hexadecimal}} /test_top/agente_spi/reg_lecturas
add wave -noupdate /test_top/agente_spi/cnt_rd_muestras
add wave -noupdate /test_top/agente_spi/SDI
add wave -noupdate /test_top/agente_spi/SDO
add wave -noupdate -expand -group spi_master /test_top/spi_master/clk
add wave -noupdate -expand -group spi_master /test_top/spi_master/nRst
add wave -noupdate -expand -group spi_master /test_top/spi_master/nCS
add wave -noupdate -expand -group spi_master /test_top/spi_master/SPC
add wave -noupdate -expand -group spi_master /test_top/spi_master/SPC_ena_rd
add wave -noupdate -expand -group spi_master /test_top/spi_master/SPC_ena_wr
add wave -noupdate -expand -group spi_master /test_top/spi_master/MISO
add wave -noupdate -expand -group spi_master /test_top/spi_master/MOSI
add wave -noupdate -expand -group spi_master /test_top/spi_master/ini_tx
add wave -noupdate -expand -group spi_master /test_top/spi_master/tipo_op_nW_R
add wave -noupdate -expand -group spi_master /test_top/spi_master/reg_addr
add wave -noupdate -expand -group spi_master -radix hexadecimal /test_top/spi_master/dato_wr
add wave -noupdate -expand -group spi_master /test_top/spi_master/ena_rd
add wave -noupdate -expand -group spi_master -radix hexadecimal /test_top/spi_master/dato_rd
add wave -noupdate -expand -group spi_master /test_top/spi_master/ready_tx
add wave -noupdate -expand -group spi_master /test_top/spi_master/estado
add wave -noupdate -expand -group spi_master /test_top/spi_master/SPC_ena
add wave -noupdate -expand -group spi_master -radix unsigned /test_top/spi_master/SPC_cnt
add wave -noupdate -expand -group spi_master -radix hexadecimal /test_top/spi_master/reg_MOSI
add wave -noupdate -expand -group spi_master -radix hexadecimal /test_top/spi_master/reg_MISO
add wave -noupdate -expand -group spi_master -radix unsigned /test_top/spi_master/cnt_bits_tx
add wave -noupdate -expand -group spi_master /test_top/spi_master/fin_tx
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {201872926 ps} 1} {{Cursor 2} {203168989 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {177469046 ps} {230002550 ps}

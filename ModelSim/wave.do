onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group agente /test_top/agente_spi/pos_X
add wave -noupdate -expand -group agente /test_top/agente_spi/pos_Y
add wave -noupdate -expand -group agente /test_top/agente_spi/estado
add wave -noupdate -expand -group agente /test_top/agente_spi/reg_comandos
add wave -noupdate -expand -group agente -radix hexadecimal /test_top/agente_spi/reg_lecturas
add wave -noupdate -expand -group agente /test_top/agente_spi/cnt_rd_muestras
add wave -noupdate -expand -group spi_master /test_top/spi_master/clk
add wave -noupdate -expand -group spi_master /test_top/spi_master/nRst
add wave -noupdate -expand -group spi_master /test_top/spi_master/nCS
add wave -noupdate -expand -group spi_master /test_top/spi_master/SPC
add wave -noupdate -expand -group spi_master /test_top/spi_master/SDI
add wave -noupdate -expand -group spi_master /test_top/spi_master/SDO
add wave -noupdate -expand -group spi_master /test_top/spi_master/ini_tx
add wave -noupdate -expand -group spi_master /test_top/spi_master/tipo_op_nW_R
add wave -noupdate -expand -group spi_master /test_top/spi_master/reg_addr
add wave -noupdate -expand -group spi_master -radix hexadecimal /test_top/spi_master/dato_wr
add wave -noupdate -expand -group spi_master /test_top/spi_master/ena_rd
add wave -noupdate -expand -group spi_master -radix hexadecimal /test_top/spi_master/dato_rd
add wave -noupdate -expand -group spi_master /test_top/spi_master/ready_tx
add wave -noupdate -expand -group spi_master /test_top/spi_master/estado
add wave -noupdate -expand -group spi_master -radix unsigned /test_top/spi_master/SPC_cnt
add wave -noupdate -expand -group spi_master /test_top/spi_master/SPC_ena_rd
add wave -noupdate -expand -group spi_master /test_top/spi_master/SPC_ena_wr
add wave -noupdate -expand -group spi_master /test_top/spi_master/SPC_ena
add wave -noupdate -expand -group spi_master -radix hexadecimal /test_top/spi_master/reg_SDO
add wave -noupdate -expand -group spi_master -radix hexadecimal /test_top/spi_master/reg_SDI
add wave -noupdate -expand -group spi_master -radix unsigned /test_top/spi_master/cnt_bits_tx
add wave -noupdate -expand -group spi_master /test_top/spi_master/fin_tx
add wave -noupdate -expand -group spi_master /test_top/spi_master/SPI_T_CLK
add wave -noupdate -expand -group spi_master /test_top/spi_master/SPI_T_2_CLK
add wave -noupdate -expand -group spi_master /test_top/spi_master/SPI_ENA_RD
add wave -noupdate -expand -group spi_master /test_top/spi_master/SPI_ENA_WR
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ps} {1 ns}

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group agente_spi /test_top_fase_3/agente_spi/pos_X
add wave -noupdate -expand -group agente_spi /test_top_fase_3/agente_spi/pos_Y
add wave -noupdate -expand -group agente_spi /test_top_fase_3/agente_spi/nCS
add wave -noupdate -expand -group agente_spi /test_top_fase_3/agente_spi/SPC
add wave -noupdate -expand -group agente_spi /test_top_fase_3/agente_spi/SDI
add wave -noupdate -expand -group agente_spi /test_top_fase_3/agente_spi/SDO
add wave -noupdate -expand -group agente_spi /test_top_fase_3/agente_spi/estado
add wave -noupdate -expand -group agente_spi -radix hexadecimal /test_top_fase_3/agente_spi/reg_comandos
add wave -noupdate -expand -group agente_spi -radix hexadecimal /test_top_fase_3/agente_spi/reg_lecturas
add wave -noupdate -expand -group agente_spi /test_top_fase_3/agente_spi/cnt_rd_muestras
add wave -noupdate -group spi_master /test_top_fase_3/spi_master/clk
add wave -noupdate -group spi_master /test_top_fase_3/spi_master/nRst
add wave -noupdate -group spi_master /test_top_fase_3/spi_master/nCS
add wave -noupdate -group spi_master /test_top_fase_3/spi_master/SPC
add wave -noupdate -group spi_master /test_top_fase_3/spi_master/MISO
add wave -noupdate -group spi_master /test_top_fase_3/spi_master/MOSI
add wave -noupdate -group spi_master /test_top_fase_3/spi_master/ini_tx
add wave -noupdate -group spi_master /test_top_fase_3/spi_master/tipo_op_nW_R
add wave -noupdate -group spi_master /test_top_fase_3/spi_master/reg_addr
add wave -noupdate -group spi_master /test_top_fase_3/spi_master/dato_wr
add wave -noupdate -group spi_master /test_top_fase_3/spi_master/ena_rd
add wave -noupdate -group spi_master /test_top_fase_3/spi_master/dato_rd
add wave -noupdate -group spi_master /test_top_fase_3/spi_master/ready_tx
add wave -noupdate -group spi_master /test_top_fase_3/spi_master/estado
add wave -noupdate -group spi_master /test_top_fase_3/spi_master/SPC_ena
add wave -noupdate -group spi_master /test_top_fase_3/spi_master/SPC_ena_rd
add wave -noupdate -group spi_master /test_top_fase_3/spi_master/SPC_ena_wr
add wave -noupdate -group spi_master /test_top_fase_3/spi_master/SPC_cnt
add wave -noupdate -group spi_master /test_top_fase_3/spi_master/reg_MOSI
add wave -noupdate -group spi_master /test_top_fase_3/spi_master/reg_MISO
add wave -noupdate -group spi_master /test_top_fase_3/spi_master/cnt_bits_tx
add wave -noupdate -group spi_master /test_top_fase_3/spi_master/fin_tx
add wave -noupdate -group spi_master /test_top_fase_3/spi_master/SPC_aux
add wave -noupdate -group spi_controlador /test_top_fase_3/spi_controlador/clk
add wave -noupdate -group spi_controlador /test_top_fase_3/spi_controlador/nRst
add wave -noupdate -group spi_controlador /test_top_fase_3/spi_controlador/ini_tx
add wave -noupdate -group spi_controlador /test_top_fase_3/spi_controlador/tipo_op_nW_R
add wave -noupdate -group spi_controlador /test_top_fase_3/spi_controlador/reg_addr
add wave -noupdate -group spi_controlador /test_top_fase_3/spi_controlador/dato_wr
add wave -noupdate -group spi_controlador /test_top_fase_3/spi_controlador/ready_tx
add wave -noupdate -group spi_controlador /test_top_fase_3/spi_controlador/estado
add wave -noupdate -group spi_controlador /test_top_fase_3/spi_controlador/cnt_t_meas
add wave -noupdate -group spi_controlador /test_top_fase_3/spi_controlador/conf_op
add wave -noupdate -expand -group calc_offset /test_top_fase_3/calc_offset/nRst
add wave -noupdate -expand -group calc_offset /test_top_fase_3/calc_offset/clk
add wave -noupdate -expand -group calc_offset /test_top_fase_3/calc_offset/ena_rd
add wave -noupdate -expand -group calc_offset -radix decimal /test_top_fase_3/calc_offset/dato_rd
add wave -noupdate -expand -group calc_offset -radix decimal /test_top_fase_3/calc_offset/X_out_bias
add wave -noupdate -expand -group calc_offset -radix decimal /test_top_fase_3/calc_offset/Y_out_bias
add wave -noupdate -expand -group calc_offset /test_top_fase_3/calc_offset/muestra_bias_rdy
add wave -noupdate -expand -group calc_offset -radix binary /test_top_fase_3/calc_offset/cnt_rd
add wave -noupdate -expand -group calc_offset /test_top_fase_3/calc_offset/ena_calc
add wave -noupdate -expand -group calc_offset /test_top_fase_3/calc_offset/offset_rdy
add wave -noupdate -expand -group calc_offset -radix decimal /test_top_fase_3/calc_offset/muestra_X
add wave -noupdate -expand -group calc_offset -radix decimal /test_top_fase_3/calc_offset/muestra_Y
add wave -noupdate -expand -group calc_offset -radix decimal /test_top_fase_3/calc_offset/offset_X
add wave -noupdate -expand -group calc_offset -radix decimal /test_top_fase_3/calc_offset/offset_Y
add wave -noupdate -expand -group calc_offset -radix decimal /test_top_fase_3/calc_offset/acum_X
add wave -noupdate -expand -group calc_offset -radix decimal /test_top_fase_3/calc_offset/acum_Y
add wave -noupdate -expand -group estimador /test_top_fase_3/estimador/nRst
add wave -noupdate -expand -group estimador /test_top_fase_3/estimador/clk
add wave -noupdate -expand -group estimador -radix decimal /test_top_fase_3/estimador/X_out_bias
add wave -noupdate -expand -group estimador -radix decimal /test_top_fase_3/estimador/Y_out_bias
add wave -noupdate -expand -group estimador /test_top_fase_3/estimador/muestra_bias_rdy
add wave -noupdate -expand -group estimador -radix decimal /test_top_fase_3/estimador/X_media
add wave -noupdate -expand -group estimador -radix decimal /test_top_fase_3/estimador/Y_media
add wave -noupdate -expand -group estimador -radix decimal /test_top_fase_3/estimador/reg_muestra
add wave -noupdate -expand -group estimador -radix decimal /test_top_fase_3/estimador/reg_file_aux
add wave -noupdate -expand -group estimador -radix decimal /test_top_fase_3/estimador/dif_X_muestra_N
add wave -noupdate -expand -group estimador -radix decimal /test_top_fase_3/estimador/dif_Y_muestra_N
add wave -noupdate -expand -group estimador -radix decimal /test_top_fase_3/estimador/X_media_N
add wave -noupdate -expand -group estimador -radix decimal /test_top_fase_3/estimador/Y_media_N
add wave -noupdate -expand -group representacion /test_top_fase_3/representacion/clk
add wave -noupdate -expand -group representacion /test_top_fase_3/representacion/nRst
add wave -noupdate -expand -group representacion /test_top_fase_3/representacion/X_media
add wave -noupdate -expand -group representacion /test_top_fase_3/representacion/Y_media
add wave -noupdate -expand -group representacion /test_top_fase_3/representacion/seg
add wave -noupdate -expand -group representacion /test_top_fase_3/representacion/disp
add wave -noupdate -expand -group representacion /test_top_fase_3/representacion/leds
add wave -noupdate -expand -group representacion /test_top_fase_3/representacion/N_X
add wave -noupdate -expand -group representacion /test_top_fase_3/representacion/N_Y
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {81563697513 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ps} {840000157500 ps}

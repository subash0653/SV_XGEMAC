`timescale 1ps/1ps

`include "xgemac_defines.sv"
`include "xgemac_tx_interface.sv"
`include "xgemac_rx_interface.sv"
`include "xgemac_xgmii_txrx_interface.sv"
`include "xgemac_wb_interface.sv"
`include "xgemac_clk_interface.sv"
`include "xgemac_rst_interface.sv"
`include "xgemac_package.sv"
import xgemac_package::*;
`include "../rtl/verilog/xgemac_rtl_list.sv"
`include "xgemac_test_top.sv"

module tb_top();

  //clock interface
  xgemac_clk_interface wb_clk_i();
  xgemac_clk_interface clk_156m25();
  xgemac_clk_interface clk_xgmii_txrx();

  //reset interface
  xgemac_rst_interface wb_rst_i(wb_clk_i.clk);
  xgemac_rst_interface reset_156m25_n(clk_156m25.clk);
  xgemac_rst_interface reset_xgmii_txrx_n(clk_xgmii_txrx.clk);

  //tx and rx interface
  xgemac_tx_interface tx_intff(.clk(clk_156m25.clk), .rst_n(reset_156m25_n.rst));
  xgemac_rx_interface rx_intff(.clk(clk_156m25.clk), .rst_n(reset_156m25_n.rst));

  //xgmii interface
  xgemac_xgmii_txrx_interface xgmii_intff(.clk(clk_xgmii_txrx.clk), .rst_n(reset_xgmii_txrx_n.rst));

  //wishbone interface
  xgemac_wb_interface wb_intff(.wb_clk_i(wb_clk_i.clk), .wb_rst_i(wb_rst_i.rst));

  //dut instance
  xge_mac dut(.xgmii_txd(xgmii_intff.xgmii_txrxd), .xgmii_txc(xgmii_intff.xgmii_txrxc), .wb_int_o(wb_intff.wb_int_o), 
              .wb_dat_o(wb_intff.wb_dat_o), .wb_ack_o(wb_intff.wb_ack_o), .pkt_tx_full(tx_intff.pkt_tx_full),
              .pkt_rx_val(rx_intff.pkt_rx_val), .pkt_rx_sop(rx_intff.pkt_rx_sop), .pkt_rx_mod(rx_intff.pkt_rx_mod), 
              .pkt_rx_err(rx_intff.pkt_rx_err), .pkt_rx_eop(rx_intff.pkt_rx_eop), .pkt_rx_data(rx_intff.pkt_rx_data), 
              .pkt_rx_avail(rx_intff.pkt_rx_avail),
              .xgmii_rxd(xgmii_intff.xgmii_txrxd), .xgmii_rxc(xgmii_intff.xgmii_txrxc), .wb_we_i(wb_intff.wb_we_i), 
              .wb_stb_i(wb_intff.wb_stb_i), .wb_rst_i(wb_intff.wb_rst_i), .wb_dat_i(wb_intff.wb_dat_i),
              .wb_cyc_i(wb_intff.wb_cyc_i), .wb_clk_i(wb_intff.wb_clk_i), .wb_adr_i(wb_intff.wb_adr_i), 
              .reset_xgmii_tx_n(xgmii_intff.rst_n), .reset_xgmii_rx_n(xgmii_intff.rst_n), .reset_156m25_n(tx_intff.rst_n),
              .pkt_tx_val(tx_intff.pkt_tx_val), .pkt_tx_sop(tx_intff.pkt_tx_sop), .pkt_tx_mod(tx_intff.pkt_tx_mod), 
              .pkt_tx_eop(tx_intff.pkt_tx_eop), .pkt_tx_data(tx_intff.pkt_tx_data), .pkt_rx_ren(rx_intff.pkt_rx_ren), 
              .clk_xgmii_tx(xgmii_intff.clk), .clk_xgmii_rx(xgmii_intff.clk), .clk_156m25(tx_intff.clk));

   //test_top instance
   xgemac_test_top t_top(.tx_intff(tx_intff), .rx_intff(rx_intff), .wb_intff(wb_intff), .wb_clk_i(wb_clk_i), 
                         .clk_156m25(clk_156m25), .clk_xgmii_txrx(clk_xgmii_txrx), .wb_rst_i(wb_rst_i), 
                         .reset_156m25_n(reset_156m25_n), .xgmii_intff(xgmii_intff), 
                         .reset_xgmii_txrx_n(reset_xgmii_txrx_n));
  
endmodule: tb_top

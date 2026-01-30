package xgemac_package;

  //clock interface type
  typedef virtual xgemac_clk_interface wb_clk_i_vif_t;
  typedef virtual xgemac_clk_interface clk_156m25_vif_t;
  typedef virtual xgemac_clk_interface clk_xgmii_txrx_vif_t;

  //reset interface type
  typedef virtual xgemac_rst_interface wb_rst_i_vif_t;
  typedef virtual xgemac_rst_interface reset_156m25_n_vif_t;
  typedef virtual xgemac_rst_interface reset_xgmii_txrx_n_vif_t;

  //tx and rx interface type
  typedef virtual xgemac_tx_interface tx_vif_t;
  typedef virtual xgemac_rx_interface rx_vif_t;

  //xgmii interface type
  typedef virtual xgemac_xgmii_txrx_interface xgmii_vif_t;

  //wishbone interface type
  typedef virtual xgemac_wb_interface wb_vif_t;

  typedef enum bit{POS_RESET, NEG_RESET} rst_type_t;

  `include "xgemac_tb_config.sv"
  `include "xgemac_clk_driver.sv"
  `include "xgemac_rst_gen.sv"
  `include "xgemac_rst_driver.sv"
  `include "xgemac_rst_monitor.sv"
  `include "xgemac_tx_pkt.sv"
  `include "xgemac_tx_driver.sv"
  `include "xgemac_tx_gen.sv"
  `include "xgemac_tx_monitor.sv"
  `include "xgemac_rx_pkt.sv"
  `include "xgemac_rx_driver.sv"
  `include "xgemac_rx_monitor.sv"
  `include "xgemac_wb_pkt.sv"
  `include "xgemac_wb_gen.sv"
  `include "xgemac_wb_driver.sv" 
  `include "xgemac_wb_monitor.sv"
  `include "xgemac_scoreboard.sv"
  `include "xgemac_environment.sv"
  `include "xgemac_test_lib.sv"

endpackage: xgemac_package

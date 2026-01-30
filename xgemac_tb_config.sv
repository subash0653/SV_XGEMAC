class xgemac_tb_config;
  
  //knobs
  bit has_env     = 1;
  bit has_clk_drv = 1;
  bit has_rst_gen = 1;
  bit has_rst_drv = 1;
  bit has_rst_mon = 1;
  bit has_tx_gen  = 1;
  bit has_tx_drv  = 1;
  bit has_tx_mon  = 1;
  bit has_rx_drv  = 1;
  bit has_rx_mon  = 1;
  bit has_scbd    = 1;
  bit has_wb_gen  = 1;
  bit has_wb_drv  = 1;
  bit has_wb_mon  = 1;
  
  int unsigned trans_count, act_count;

  string print_string;
  bit test_status;

  bit [`DATA_WIDTH - 1:0] incr_start_data;
  
  //clock virtual interface
  wb_clk_i_vif_t wb_clk_i_vif;
  clk_156m25_vif_t clk_156m25_vif;
  clk_xgmii_txrx_vif_t clk_xgmii_txrx_vif;
  
  //reset virtual interface
  wb_rst_i_vif_t wb_rst_i_vif;
  reset_156m25_n_vif_t reset_156m25_n_vif;
  reset_xgmii_txrx_n_vif_t reset_xgmii_txrx_n_vif;
  
  //tx and rx virtual interface
  tx_vif_t tx_vif;
  rx_vif_t rx_vif;
  
  //wishbone virtual interface
  wb_vif_t wb_vif;
  
  //xgmii virtual interface
  xgmii_vif_t xgmii_vif;
  
  function new();
    $display("TB_CONFIG");
  endfunction: new
  
endclass: xgemac_tb_config

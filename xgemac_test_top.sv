program xgemac_test_top(xgemac_tx_interface tx_intff, xgemac_rx_interface rx_intff, xgemac_wb_interface wb_intff, 
                        xgemac_clk_interface wb_clk_i, xgemac_clk_interface clk_156m25, 
                        xgemac_clk_interface clk_xgmii_txrx, xgemac_xgmii_txrx_interface xgmii_intff, 
                        xgemac_rst_interface wb_rst_i, xgemac_rst_interface reset_156m25_n, 
                        xgemac_rst_interface reset_xgmii_txrx_n);

  xgemac_base_test h_test;

  xgemac_tb_config h_cfg;

  initial begin
    create_config_and_assign_vif();
    create_test_and_initiate_component();
  end
    
  function void create_config_and_assign_vif();
    h_cfg                         =     new();
    h_cfg.tx_vif                  =     tx_intff;
    h_cfg.rx_vif                  =     rx_intff;
    h_cfg.wb_vif                  =     wb_intff;
    h_cfg.wb_clk_i_vif            =     wb_clk_i;
    h_cfg.clk_156m25_vif          =     clk_156m25;
    h_cfg.clk_xgmii_txrx_vif      =     clk_xgmii_txrx;
    h_cfg.wb_rst_i_vif            =     wb_rst_i;
    h_cfg.reset_156m25_n_vif      =     reset_156m25_n;
    h_cfg.reset_xgmii_txrx_n_vif  =     reset_xgmii_txrx_n;
    h_cfg.xgmii_vif               =     xgmii_intff;
  endfunction: create_config_and_assign_vif

  task create_test_and_initiate_component();
    string test_name;
    if(!$value$plusargs("TEST_NAME=%s", test_name)) begin
      $fatal(1, "NOT RECEIVED TEST NAME");
    end
    else begin
      $display("RECEIVED TEST NAME = %0s", test_name);
    end
    case(test_name)

      "xgemac_base_test": h_test=new(h_cfg);

      "xgemac_direct_test":         begin
                                      xgemac_direct_test h_dir_test;
                                      h_dir_test=new(h_cfg);
                                      $cast(h_test, h_dir_test);
                                    end
      "xgemac_incremental_test":    begin
                                      xgemac_incremental_test h_incr_test;
                                      h_incr_test=new(h_cfg);
                                      $cast(h_test, h_incr_test);
                                    end
      "xgemac_random_test":         begin 
                                      xgemac_random_test h_rand_test;
                                      h_rand_test=new(h_cfg);
                                      $cast(h_test, h_rand_test);
                                    end
      "xgemac_wb_test":             begin
                                      xgemac_wb_test h_wb_test;
                                      h_wb_test=new(h_cfg);
                                      $cast(h_test, h_wb_test);
                                    end
      "xgemac_padding_test":        begin
                                      xgemac_padding_test h_padding_test;
                                      h_padding_test=new(h_cfg);
                                      $cast(h_test, h_padding_test);
                                    end
      "xgemac_tx_full_test":        begin
                                      xgemac_tx_full_test h_tx_full_test;
                                      h_tx_full_test=new(h_cfg);
                                      $cast(h_test, h_tx_full_test);
                                    end
      "xgemac_tx_reset_test":       begin
                                      xgemac_tx_reset_test h_tx_reset_test;
                                      h_tx_reset_test=new(h_cfg);
                                      $cast(h_test, h_tx_reset_test);
                                    end
      "xgemac_rx_reset_test":       begin
                                      xgemac_rx_reset_test h_rx_reset_test;
                                      h_rx_reset_test=new(h_cfg);
                                      $cast(h_test, h_rx_reset_test);
                                    end
    endcase
    h_test.build();
    h_test.connect();
    h_test.run();
    h_test.report();
  endtask: create_test_and_initiate_component

endprogram: xgemac_test_top

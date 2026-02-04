class xgemac_env;

  string TAG = "XGEMAC_ENV";
  
  xgemac_tb_config h_cfg;

  //clock driver
  xgemac_clk_driver#(.t(int), .CLOCK_PERIOD(`WB_CLOCK_PERIOD), .vif_t(wb_clk_i_vif_t)) wb_clk_drv;
  xgemac_clk_driver#(.t(int), .CLOCK_PERIOD(`TXRX_CLOCK_PERIOD), .vif_t(clk_156m25_vif_t)) txrx_clk_drv;
  xgemac_clk_driver#(.t(int), .CLOCK_PERIOD(`XGMII_CLOCK_PERIOD), .vif_t(clk_xgmii_txrx_vif_t)) xgmii_clk_drv;

  //reset generator
  xgemac_rst_gen wb_rst_gen;
  xgemac_rst_gen txrx_rst_gen;
  xgemac_rst_gen xgmii_rst_gen;

  //reset driver
  xgemac_rst_driver#(.rst_type(POS_RESET), .vif_t(wb_rst_i_vif_t)) wb_rst_drv;
  xgemac_rst_driver#(.rst_type(NEG_RESET), .vif_t(reset_156m25_n_vif_t)) txrx_rst_drv;
  xgemac_rst_driver#(.rst_type(NEG_RESET), .vif_t(reset_xgmii_txrx_n_vif_t)) xgmii_rst_drv;

  //reset monitor
  xgemac_rst_monitor#(.vif_t(wb_rst_i_vif_t), .rst_type(POS_RESET)) wb_rst_mon;
  xgemac_rst_monitor#(.vif_t(reset_156m25_n_vif_t), .rst_type(NEG_RESET)) txrx_rst_mon;
  xgemac_rst_monitor#(.vif_t(reset_xgmii_txrx_n_vif_t), .rst_type(NEG_RESET)) xgmii_rst_mon;

  //tx generator
  xgemac_tx_gen h_tx_gen;

  //tx driver
  xgemac_tx_driver h_tx_drv;

  //tx monitor
  xgemac_tx_monitor h_tx_mon;

  //rx driver
  xgemac_rx_driver h_rx_drv;

  //rx monitor
  xgemac_rx_monitor h_rx_mon;

  //tx-rx scoreboard
  xgemac_scoreboard h_scbd;

  //wishbone generator
  xgemac_wb_gen h_wb_gen;

  //wishbone driver
  xgemac_wb_driver h_wb_drv;

  //wishbone monitor
  xgemac_wb_monitor h_wb_mon;
  
  function void build();

    $display("%0s: Build method", TAG);

    if(h_cfg.has_clk_drv) begin
      wb_clk_drv    =   new(h_cfg.wb_clk_i_vif);
      txrx_clk_drv  =   new(h_cfg.clk_156m25_vif);
      xgmii_clk_drv =   new(h_cfg.clk_xgmii_txrx_vif);
      wb_clk_drv.build();
      txrx_clk_drv.build();
      xgmii_clk_drv.build();
    end

    if(h_cfg.has_rst_gen) begin
      wb_rst_gen    =   new();
      txrx_rst_gen  =   new();
      xgmii_rst_gen =   new();
      wb_rst_gen.build();
      txrx_rst_gen.build();
      xgmii_rst_gen.build();
    end

    if(h_cfg.has_rst_drv) begin
      wb_rst_drv    =   new(h_cfg.wb_rst_i_vif);
      txrx_rst_drv  =   new(h_cfg.reset_156m25_n_vif);
      xgmii_rst_drv =   new(h_cfg.reset_xgmii_txrx_n_vif);
      wb_rst_drv.build();
      txrx_rst_drv.build();
      xgmii_rst_drv.build();
    end

    if(h_cfg.has_rst_mon) begin
      wb_rst_mon    =   new(h_cfg.wb_rst_i_vif);
      txrx_rst_mon  =   new(h_cfg.reset_156m25_n_vif);
      xgmii_rst_mon =   new(h_cfg.reset_xgmii_txrx_n_vif);
      wb_rst_mon.build();
      txrx_rst_mon.build();
      xgmii_rst_mon.build();
    end

    if(h_cfg.has_tx_gen) begin
      h_tx_gen      =   new(h_cfg);
      h_tx_gen.build();
    end

    if(h_cfg.has_tx_drv) begin
      h_tx_drv      =   new(h_cfg);
      h_tx_drv.build();
    end

    if(h_cfg.has_tx_mon) begin
      h_tx_mon      =   new(h_cfg);
      h_tx_mon.build();
    end

    if(h_cfg.has_rx_drv) begin
      h_rx_drv      =   new(h_cfg);
      h_rx_drv.build();
    end

    if(h_cfg.has_rx_mon) begin
      h_rx_mon      =   new(h_cfg);
      h_rx_mon.build();
    end

    if(h_cfg.has_scbd) begin
      h_scbd        =   new(h_cfg);
      h_scbd.build();
    end

    if(h_cfg.has_wb_gen) begin
      h_wb_gen      =   new(h_cfg);
      h_wb_gen.build();
    end

    if(h_cfg.has_wb_drv) begin
      h_wb_drv      =   new(h_cfg);
      h_wb_drv.build();
    end

    if(h_cfg.has_wb_mon) begin
      h_wb_mon      =   new(h_cfg);
      h_wb_mon.build();
    end

  endfunction: build
  
  function void connect();

    $display("%0s: Connect method", TAG);

    if(h_cfg.has_clk_drv) begin
      wb_clk_drv.connect();
      txrx_clk_drv.connect();
      xgmii_clk_drv.connect();
    end

    if(h_cfg.has_rst_gen) begin
      wb_rst_gen.connect();
      txrx_rst_gen.connect();
      xgmii_rst_gen.connect();
    end

    if(h_cfg.has_rst_drv) begin
      wb_rst_drv.connect();
      txrx_rst_drv.connect();
      xgmii_rst_drv.connect();
      wb_rst_drv.rst_mbx    = wb_rst_gen.rst_mbx;
      txrx_rst_drv.rst_mbx  = txrx_rst_gen.rst_mbx;
      xgmii_rst_drv.rst_mbx = xgmii_rst_gen.rst_mbx;
    end

    if(h_cfg.has_rst_mon) begin
      wb_rst_mon.connect();
      txrx_rst_mon.connect();
      xgmii_rst_mon.connect();
    end

    if(h_cfg.has_tx_gen) begin
      h_tx_gen.connect();
    end

    if(h_cfg.has_tx_drv) begin
      h_tx_drv.connect();
      h_tx_drv.tx_mbx = h_tx_gen.tx_mbx;
    end

    if(h_cfg.has_tx_mon) begin
      h_tx_mon.connect();
    end

    if(h_cfg.has_rx_drv) begin
      h_rx_drv.connect();
    end

    if(h_cfg.has_rx_mon) begin
      h_rx_mon.connect();
    end

    if(h_cfg.has_scbd) begin
      h_scbd.connect();
      h_scbd.tx_mbx = h_tx_mon.tx_mbx;
      h_scbd.rx_mbx = h_rx_mon.rx_mbx;
      h_scbd.rst_mbx= txrx_rst_mon.rst_mbx; 
      h_scbd.wb_mbx = h_wb_mon.wb_mbx;
    end

    if(h_cfg.has_wb_gen) begin
      h_wb_gen.connect();
    end

    if(h_cfg.has_wb_drv) begin
      h_wb_drv.connect();
      h_wb_drv.wb_mbx = h_wb_gen.wb_mbx;
    end

    if(h_cfg.has_wb_mon) begin
      h_wb_mon.connect();
    end

  endfunction: connect
  
  task run();

    $display("%0s: Run method", TAG);

    fork
      
    begin
      if(h_cfg.has_clk_drv) begin
        fork
          wb_clk_drv.run();
          txrx_clk_drv.run();
          xgmii_clk_drv.run();
        join_none
      end
    end

    begin
      if(h_cfg.has_rst_gen) begin
        fork
          wb_rst_gen.gen_rst_and_put_in_mbx();
          txrx_rst_gen.gen_rst_and_put_in_mbx();
          xgmii_rst_gen.gen_rst_and_put_in_mbx();
        join_none
      end
    end

    begin
      if(h_cfg.has_rst_drv) begin
        fork
          wb_rst_drv.run();
          txrx_rst_drv.run();
          xgmii_rst_drv.run();
          wb_rst_drv.wait_for_pkt();
          txrx_rst_drv.wait_for_pkt();
          xgmii_rst_drv.wait_for_pkt();
        join_none
      end
    end

    begin
      if(h_cfg.has_rst_mon) begin
        fork
          wb_rst_mon.run();
          txrx_rst_mon.run();
          xgmii_rst_mon.run();
        join_none
      end
    end

    begin
      if(h_cfg.has_tx_drv) begin
        h_tx_drv.run();
      end
    end

    begin
      if(h_cfg.has_tx_mon) begin
        h_tx_mon.run();
      end
    end

    begin
      if(h_cfg.has_rx_drv) begin
        h_rx_drv.run();
      end
    end

    begin
      if(h_cfg.has_rx_mon) begin
        h_rx_mon.run();
      end
    end

    begin
      if(h_cfg.has_scbd) begin
        h_scbd.run();
      end
    end

    begin
      if(h_cfg.has_wb_drv) begin
        h_wb_drv.run();
      end
    end

    begin
      if(h_cfg.has_wb_mon) begin
        h_wb_mon.run();
      end
    end

    join_none

  endtask: run

  function void report();
    $display("%0s: Report method", TAG);
    if(h_cfg.has_env) begin
      h_scbd.report();
    end
  endfunction: report

  function new(xgemac_tb_config h_cfg);
    this.h_cfg=h_cfg;
  endfunction: new
  
endclass: xgemac_env

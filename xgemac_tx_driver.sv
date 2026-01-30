class xgemac_tx_driver;

  string TAG = "XGEMAC_TX_DRIVER";

  xgemac_tb_config h_cfg;
  tx_vif_t vif;
  mailbox#(xgemac_tx_pkt) tx_mbx;

  function new(xgemac_tb_config h_cfg);
    this.h_cfg=h_cfg;
  endfunction: new

  function void build();
    $display("%0s: Build method", TAG);
  endfunction: build

  function void connect();
    $display("%0s: Connect method", TAG);
    vif=h_cfg.tx_vif;
  endfunction: connect

  task run();
    $display("%0s: Run method", TAG);
    forever begin
      reset_input_signals();
      wait_for_reset_done();
      drive_transfer();
    end
  endtask: run

  task wait_for_reset_done();
    wait(vif.rst_n === 0);
    @(posedge vif.rst_n);
  endtask: wait_for_reset_done

  function void reset_input_signals();
    vif.pkt_tx_data   =   'hx;
    vif.pkt_tx_val    =   'h0;
    vif.pkt_tx_sop    =   'h0;
    vif.pkt_tx_eop    =   'h0;
    vif.pkt_tx_mod    =   'hx;
  endfunction: reset_input_signals

  task drive_transfer();
    process p[2];
    fork 
      begin
        p[0]=process::self();
        get_and_drive();
      end
      begin
        p[1]=process::self();
        wait_for_reset();
      end
    join_any
    foreach(p[i]) begin
      p[i].kill();
    end
  endtask: drive_transfer

  task get_and_drive();
    xgemac_tx_pkt h_tx_pkt, h_tx_cl_pkt;
    forever begin
      tx_mbx.get(h_tx_pkt);
      $cast(h_tx_cl_pkt, h_tx_pkt.clone());
      //$display("From tx generator to driver : ");
      //h_tx_cl_pkt.display();
      drive_into_pins(h_tx_cl_pkt);
      @(posedge vif.clk);
      reset_input_signals();
    end
  endtask: get_and_drive

  task drive_into_pins(xgemac_tx_pkt h_pkt);
    wait(vif.mrcb.pkt_tx_full===0);
    vif.drcb.pkt_tx_val   <=  'b1;
    vif.drcb.pkt_tx_data  <=  h_pkt.pkt_tx_data;
    vif.drcb.pkt_tx_sop   <=  h_pkt.pkt_tx_sop;
    vif.drcb.pkt_tx_eop   <=  h_pkt.pkt_tx_eop;
    vif.drcb.pkt_tx_mod   <=  h_pkt.pkt_tx_mod;
  endtask: drive_into_pins

  task wait_for_reset();
    @(negedge vif.rst_n);
  endtask: wait_for_reset

endclass: xgemac_tx_driver

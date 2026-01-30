class xgemac_rx_driver;

  string TAG = "XGEMAC_RX_DRIVER";

  xgemac_tb_config h_cfg;
  rx_vif_t vif;

  function new(xgemac_tb_config h_cfg);
    this.h_cfg=h_cfg;
  endfunction: new

  function void build();
    $display("%0s: Build method", TAG);
  endfunction: build

  function void connect();
    $display("%0s: Connect method", TAG);
    vif=h_cfg.rx_vif;
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
    wait(vif.rst_n===0);
    @(posedge vif.rst_n);
  endtask: wait_for_reset_done

  function void reset_input_signals();
    vif.pkt_rx_ren=0;
  endfunction: reset_input_signals

  task drive_transfer();
    process p[2];
    fork
      begin
        p[0]=process::self();
        wait_and_drive();
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

  task wait_and_drive();
    forever begin
      wait(vif.mrcb.pkt_rx_avail===1);
      drive_into_pins();
      wait(vif.mrcb.pkt_rx_val === 1 && vif.mrcb.pkt_rx_eop ===1);
      reset_input_signals();
    end
  endtask: wait_and_drive

  task drive_into_pins();
    vif.drcb.pkt_rx_ren <= 'h1;
  endtask: drive_into_pins

  task wait_for_reset();
    @(negedge vif.rst_n);
  endtask: wait_for_reset

endclass: xgemac_rx_driver

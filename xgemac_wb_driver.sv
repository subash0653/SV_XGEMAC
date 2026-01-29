class xgemac_wb_driver;

  string TAG = "XGEMAC_WB_DRIVER";

  xgemac_tb_config h_cfg;
  wb_vif_t vif;
  mailbox#(xgemac_wb_pkt) wb_mbx;

  function new(xgemac_tb_config h_cfg);
    this.h_cfg=h_cfg;
  endfunction: new

  function void build();
    $display("%0s: Build method", TAG);
  endfunction: build

  function void connect();
    $display("%0s: Connect method", TAG);
    vif=h_cfg.wb_vif;
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
    wait(vif.wb_rst_i===0);
    @(negedge vif.wb_rst_i);
  endtask: wait_for_reset_done

  function void reset_input_signals();
    vif.wb_adr_i='hx;
    vif.wb_cyc_i='h0;
    vif.wb_dat_i='hx;
    vif.wb_stb_i='h0;
    vif.wb_we_i='h0;
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
    xgemac_wb_pkt h_wb_pkt, h_wb_cl_pkt;
    forever begin
      wb_mbx.get(h_wb_pkt);
      $cast(h_wb_cl_pkt, h_wb_pkt.clone());
      $display("From wb generator to driver: at %0t", $time);
      //h_wb_cl_pkt.display(); //FIXME
      drive_into_pins(h_wb_cl_pkt);
      @(posedge vif.wb_clk_i);
      reset_input_signals();
    end
  endtask: get_and_drive

  task wait_for_reset();
    @(posedge vif.wb_rst_i);
  endtask: wait_for_reset

  task drive_into_pins(xgemac_wb_pkt h_pkt);
    vif.drcb.wb_cyc_i  <=  'h1;
    vif.drcb.wb_stb_i  <=  'h1;
    vif.drcb.wb_adr_i  <=  h_pkt.wb_adr_i;
    vif.drcb.wb_dat_i  <=  h_pkt.wb_dat_i;
    vif.drcb.wb_we_i   <=  h_pkt.wb_we_i;
    wait(vif.mrcb.wb_ack_o === 1);
  endtask: drive_into_pins

endclass: xgemac_wb_driver

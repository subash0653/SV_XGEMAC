class xgemac_wb_monitor;

  string TAG = "XGEMAC_WB_MONITOR";

  mailbox#(xgemac_wb_pkt) wb_mbx;
  wb_vif_t vif;
  xgemac_tb_config h_cfg;

  function new(xgemac_tb_config h_cfg);
    this.h_cfg = h_cfg;
  endfunction: new

  function void build();
    $display("%0s: Build method", TAG);
    wb_mbx = new();
  endfunction: build

  function void connect();
    $display("%0s: Connect method", TAG);
    vif = h_cfg.wb_vif;
  endfunction: connect

  task run();
    $display("%0s: Run method", TAG);
    forever begin
      wait_for_reset_done();
      collect_transfer();
    end
  endtask: run

  task wait_for_reset_done();
    wait(vif.wb_rst_i===0);
    @(negedge vif.wb_rst_i);
  endtask: wait_for_reset_done

  task collect_transfer();
    process p[2];
    fork
      begin
        p[0]=process::self();
        collect_from_vif();
      end
      begin
        p[1]=process::self();
        wait_for_reset();
      end
    join_any
    foreach(p[i]) begin
      p[i].kill();
    end
  endtask: collect_transfer

  task wait_for_reset();
    @(posedge vif.wb_rst_i);
  endtask: wait_for_reset

  task collect_from_vif();
    xgemac_wb_pkt h_pkt, h_cl_pkt;
    h_pkt=new();
    forever begin
      if(vif.mrcb.wb_cyc_i && vif.mrcb.wb_stb_i) begin
        h_pkt.wb_we_i   =   vif.mrcb.wb_we_i;
        h_pkt.wb_adr_i  =   vif.mrcb.wb_adr_i;
        h_pkt.wb_dat_i  =   vif.mrcb.wb_dat_i;
        if(vif.mrcb.wb_we_i === 0) begin
          wait(vif.mrcb.wb_ack_o === 1);
          h_pkt.wb_dat_o  = vif.mrcb.wb_dat_o;
        end
        $cast(h_cl_pkt, h_pkt.clone());
        wb_mbx.put(h_cl_pkt);
      end
      @(vif.mrcb);
    end
  endtask: collect_from_vif

endclass: xgemac_wb_monitor

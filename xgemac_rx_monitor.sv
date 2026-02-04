class xgemac_rx_monitor;

  string TAG = "XGEMAC_RX_MONITOR";

  mailbox#(xgemac_rx_pkt) rx_mbx;
  rx_vif_t vif;
  xgemac_tb_config h_cfg;

  function new(xgemac_tb_config h_cfg);
    this.h_cfg = h_cfg;
  endfunction: new

  function void build();
    $display("%0s: Build method", TAG);
    rx_mbx=new(1);
  endfunction: build

  function void connect();
    $display("%0s: Connect method", TAG);
    vif = h_cfg.rx_vif;
  endfunction: connect

  task run();
    $display("%0s: Run method", TAG);
    forever begin
      wait_for_reset_done();
      collect_transfer();
    end
  endtask: run

  task wait_for_reset_done();
    wait(vif.rst_n===0)
    @(posedge vif.rst_n);
  endtask: wait_for_reset_done

  task collect_transfer();
    process p[2];
    fork 
      begin
        p[0]=process::self();
        wait_for_reset();
      end
      begin
        p[1]=process::self();
        collect_from_vif();
      end
    join_any
    foreach(p[i]) begin
      if(p[i]!=null) begin
        p[i].kill();
      end
    end
  endtask: collect_transfer

  task wait_for_reset();
    @(negedge vif.rst_n);
  endtask: wait_for_reset

  task collect_from_vif();
    xgemac_rx_pkt h_pkt, h_cl_pkt;
    h_pkt = new();
    forever begin
      if(vif.mrcb.pkt_rx_val===1) begin
        h_pkt.pkt_rx_sop  =   vif.mrcb.pkt_rx_sop;
        h_pkt.pkt_rx_eop  =   vif.mrcb.pkt_rx_eop;
        h_pkt.pkt_rx_data =   vif.mrcb.pkt_rx_data;
        h_pkt.pkt_rx_err  =   vif.mrcb.pkt_rx_err;
        h_pkt.pkt_rx_mod  =   vif.mrcb.pkt_rx_mod;
        $cast(h_cl_pkt, h_pkt.clone());
        rx_mbx.put(h_cl_pkt);
      end
      @(vif.mrcb);
    end
  endtask: collect_from_vif

endclass: xgemac_rx_monitor

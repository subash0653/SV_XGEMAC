class xgemac_tx_monitor;

  string TAG = "XGEMAC_TX_MONITOR";

  mailbox#(xgemac_tx_pkt) tx_mbx;
  xgemac_tb_config h_cfg;
  tx_vif_t vif;

  function new(xgemac_tb_config h_cfg);
    this.h_cfg = h_cfg;
  endfunction: new

  function void build();
    $display("%0s: Build method", TAG);
    tx_mbx=new(1);
  endfunction: build

  function void connect();
    $display("%0s: Connect method", TAG);
    vif=h_cfg.tx_vif;
  endfunction: connect

  task run();
    $display("%0s: Run method", TAG);
    forever begin
      wait_for_reset_done();
      collect_transfer();
    end
  endtask: run

  task wait_for_reset_done();
    wait(vif.rst_n === 1);
    @(posedge vif.rst_n);
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
      if(p[i]!=null) begin
        p[i].kill();
      end
    end
  endtask: collect_transfer

  task wait_for_reset();
    @(negedge vif.rst_n);
  endtask: wait_for_reset

  task collect_from_vif();
    xgemac_tx_pkt h_pkt, h_cl_pkt;
    h_pkt = new();
    forever begin
      if(vif.mrcb.pkt_tx_val===1) begin
        h_pkt.pkt_tx_data = vif.mrcb.pkt_tx_data;
        h_pkt.pkt_tx_sop  = vif.mrcb.pkt_tx_sop;
        h_pkt.pkt_tx_eop  = vif.mrcb.pkt_tx_eop;
        h_pkt.pkt_tx_mod  = vif.mrcb.pkt_tx_mod;
        $cast(h_cl_pkt, h_pkt.clone());
        tx_mbx.put(h_cl_pkt);
      end
      @(vif.mrcb);
    end
  endtask: collect_from_vif

endclass: xgemac_tx_monitor

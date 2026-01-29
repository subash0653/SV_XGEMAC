class xgemac_rst_monitor#(type vif_t);

  string TAG = "XGEMAC_RESET_MONITOR";

  mailbox mbx;
  vif_t vif;
  xgemac_tb_config h_cfg;

  function new(vif_t vif);
    this.vif = vif;
  endfunction: new

  function void build();
    $display("%0s: Build method", TAG);
    mbx = new();
  endfunction: build

  function void connect();
    $display("%0s: Connect method", TAG);
  endfunction: connect

  task run();
    $display("%0s: Run method", TAG);
    collect_from_vif();
  endtask: run

  task collect_from_vif();
    forever begin
      if(vif.mrcb.rst) begin
        mbx.put(vif.mrcb.rst);
      end
      @(vif.mrcb);
    end
  endtask: collect_from_vif

endclass: xgemac_rst_monitor

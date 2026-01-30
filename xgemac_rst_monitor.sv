class xgemac_rst_monitor#(type vif_t, rst_type_t rst_type);

  string TAG = "XGEMAC_RESET_MONITOR";

  mailbox#(bit) rst_mbx;
  vif_t vif;

  function new(vif_t vif);
    this.vif = vif;
  endfunction: new

  function void build();
    $display("%0s: Build method", TAG);
    rst_mbx = new();
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
      if(vif.rst===~rst_type) begin
        rst_mbx.put(1);
      end
      @(posedge vif.clk);
    end
  endtask: collect_from_vif

endclass: xgemac_rst_monitor

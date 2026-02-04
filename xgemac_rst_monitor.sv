class xgemac_rst_monitor#(type vif_t, rst_type_t rst_type);

  string TAG = "XGEMAC_RESET_MONITOR";

  mailbox#(xgemac_rst_pkt) rst_mbx;
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
    forever begin
      wait_for_reset_done();
      collect_transfer();
    end
  endtask: run

  task wait_for_reset_done();
    wait(vif.rst==~rst_type);
    if(rst_type == POS_RESET) begin
      @(negedge vif.rst);
    end
    else begin
      @(posedge vif.rst);
    end
  endtask: wait_for_reset_done

  task collect_transfer();
    wait_for_reset();
  endtask: collect_transfer

  task wait_for_reset();
    xgemac_rst_pkt h_pkt, h_cl_pkt;
    if(rst_type == POS_RESET) begin
      @(posedge vif.rst);
    end
    else begin
      @(negedge vif.rst);
    end
    h_pkt=new();
    $cast(h_cl_pkt, h_pkt.clone());
    rst_mbx.put(h_cl_pkt);
  endtask: wait_for_reset

endclass: xgemac_rst_monitor

class xgemac_rst_driver#(rst_type_t rst_type, type vif_t);

  string TAG = "XGEMAC_RST_DRIVER";

  vif_t vif;
  mailbox#(xgemac_rst_pkt) rst_mbx;

  function new(vif_t vif);
    this.vif=vif;
  endfunction: new

  function void build();
    $display("%0s: Build method", TAG);
    vif.rst=rst_type;
  endfunction: build

  function void connect();
    $display("%0s: Connect method", TAG);
  endfunction: connect

  task run();
    $display("%0s: Run method", TAG);
    @(posedge vif.clk);
    vif.rst = ~rst_type;
    repeat(`RESET_PERIOD) begin
      @(posedge vif.clk);
    end
    vif.rst = rst_type;
  endtask: run

  task wait_for_pkt();
    xgemac_rst_pkt h_pkt, h_cl_pkt;
    forever begin
      rst_mbx.get(h_pkt);
      $cast(h_cl_pkt, h_pkt.clone());
      @(posedge vif.clk);
      vif.rst = ~rst_type;
      repeat(h_cl_pkt.rst_period) begin
        @(posedge vif.clk);
      end
      vif.rst = rst_type;
    end
  endtask: wait_for_pkt

endclass: xgemac_rst_driver

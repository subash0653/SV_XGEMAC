class xgemac_rst_driver#(rst_type_t rst_type, type vif_t);

  string TAG = "XGEMAC_RST_DRIVER";

  vif_t vif;
  mailbox#(byte) rst_mbx;

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
    byte rst_period;
    $display("%0s: Run method", TAG);
    forever begin
      rst_mbx.get(rst_period);
      if(rst_period==0) begin
        rst_period=`RESET_PERIOD;
      end
      @(posedge vif.clk);
      vif.rst = ~rst_type;
      repeat(rst_period) begin
        @(posedge vif.clk);
      end
      vif.rst = rst_type;
    end
  endtask: run

endclass: xgemac_rst_driver

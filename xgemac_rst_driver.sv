class xgemac_rst_driver#(RST_PERIOD, rst_type_t rst_type, type vif_t);

  string TAG = "XGEMAC_RST_DRIVER";

  vif_t vif;
  mailbox#(bit) rst_mbx;

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
    forever begin
      bit b;
      rst_mbx.get(b);
      @(posedge vif.clk);
      vif.rst = ~rst_type;
      repeat(RST_PERIOD) begin
        @(posedge vif.clk);
      end
      vif.rst = rst_type;
    end
  endtask: run

endclass: xgemac_rst_driver

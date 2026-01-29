class xgemac_clk_driver#(type t=int, t CLOCK_PERIOD, type vif_t);

  string TAG = "XGEMAC_CLK_DRIVER";

  vif_t vif;

  function new(vif_t vif);
    this.vif=vif;
  endfunction: new

  function void build();
    vif.clk=0;
    $display("%0s: Build method", TAG);
  endfunction: build

  function void connect();
    $display("%0s: Connect method", TAG);
  endfunction: connect

  task run();
    $display("%0s: Run method", TAG);
    forever begin
      #(CLOCK_PERIOD/2);
      vif.clk=~(vif.clk);
    end
  endtask: run

endclass: xgemac_clk_driver

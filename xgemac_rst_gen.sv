class xgemac_rst_gen;

  string TAG = "XGEMAC_RST_GEN";

  mailbox#(byte) rst_mbx;

  function void build();
    $display("%0s: Build method", TAG);
    rst_mbx=new();
  endfunction: build

  function void connect();
    $display("%0s: Connect method", TAG);
  endfunction: connect

  task gen_rst_and_put_in_mbx(int rst_period=0);
    $display("%0s: Run method", TAG);
    rst_mbx.put(0);
  endtask: gen_rst_and_put_in_mbx

endclass: xgemac_rst_gen

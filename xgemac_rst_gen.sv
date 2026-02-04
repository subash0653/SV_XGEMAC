class xgemac_rst_gen;

  string TAG = "XGEMAC_RST_GEN";

  mailbox#(xgemac_rst_pkt) rst_mbx;

  function void build();
    $display("%0s: Build method", TAG);
    rst_mbx=new();
  endfunction: build

  function void connect();
    $display("%0s: Connect method", TAG);
  endfunction: connect

  task gen_rst_and_put_in_mbx(int unsigned rst_period = `RESET_PERIOD);
    xgemac_rst_pkt h_pkt, h_cl_pkt;
    $display("%0s: Generate reset method", TAG);
    h_pkt=new();
    h_pkt.rst_period = rst_period;
    $cast(h_cl_pkt, h_pkt.clone());
    rst_mbx.put(h_cl_pkt);
  endtask: gen_rst_and_put_in_mbx

endclass: xgemac_rst_gen

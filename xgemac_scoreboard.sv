class xgemac_scoreboard;

  string TAG = "XGEMAC_SCOREBOARD";

  xgemac_tb_config h_cfg;
  mailbox#(xgemac_tx_pkt) tx_mbx;
  mailbox#(xgemac_rx_pkt) rx_mbx;
  mailbox#(xgemac_wb_pkt) wb_mbx;

  xgemac_tx_pkt expected[$];

  function new(xgemac_tb_config h_cfg);
    this.h_cfg = h_cfg;
  endfunction: new

  function void build();
    $display("%0s: Build method", TAG);
  endfunction: build

  function void connect();
    $display("%0s: Connect method", TAG);
  endfunction: connect

  task run();
    $display("%0s: Run method", TAG);
    fork
      wait_for_tx_pkt();
      wait_for_rx_pkt();
      wait_for_wb_pkt();
    join_none
  endtask: run

  task wait_for_tx_pkt();
    xgemac_tx_pkt h_pkt, h_cl_pkt;
    forever begin
      tx_mbx.get(h_pkt);
      $cast(h_cl_pkt, h_pkt.clone());
      $display("From tx monitor to scoreboard");
      h_cl_pkt.display();
      expected.push_back(h_cl_pkt);
    end
  endtask: wait_for_tx_pkt

  task wait_for_rx_pkt();
    xgemac_rx_pkt h_pkt, h_cl_pkt;
    forever begin
      rx_mbx.get(h_pkt);
      $cast(h_cl_pkt, h_pkt.clone());
      $display("From rx monitor to scoreboard");
      h_cl_pkt.display();
      check_exp_data_and_act_data(h_cl_pkt);
      h_cfg.act_count++;
    end
  endtask: wait_for_rx_pkt

  function bit[`DATA_WIDTH - 1 : 0] check_mod(bit[`MOD_WIDTH - 1 : 0] mod);
    bit[`DATA_WIDTH - 1 : 0] temp;
    temp = 2**(8*mod) - 1;
    temp = {<<{temp}};
    return temp;
  endfunction: check_mod

  function void check_exp_data_and_act_data(xgemac_rx_pkt h_act_pkt);
    xgemac_tx_pkt h_exp_pkt;
    h_exp_pkt = expected.pop_front();
    if(h_act_pkt.pkt_rx_sop   !==    h_exp_pkt.pkt_tx_sop) begin
      $error("SOP does not match");
      h_cfg.test_status=1;
      h_cfg.print_string={h_cfg.print_string, $sformatf("Actual count = %0d; Expected SOP = %0h, Actual SOP = %0h\n", h_cfg.act_count, h_exp_pkt.pkt_tx_sop, h_act_pkt.pkt_rx_sop)};
    end
    if(h_act_pkt.pkt_rx_eop   !==    h_exp_pkt.pkt_tx_eop) begin
      $error("EOP does not match");
      h_cfg.test_status=1;
      h_cfg.print_string={h_cfg.print_string, $sformatf("Actual count = %0d; Expected EOP = %0h, Actual EOP = %0h\n", h_cfg.act_count, h_exp_pkt.pkt_tx_eop, h_act_pkt.pkt_rx_eop)};
    end
    if(h_act_pkt.pkt_rx_mod === 0 ? h_act_pkt.pkt_rx_data !== h_exp_pkt.pkt_tx_data : h_act_pkt.pkt_rx_data & check_mod(h_act_pkt.pkt_rx_mod)  !==    h_exp_pkt.pkt_tx_data & check_mod(h_exp_pkt.pkt_tx_mod)) begin
      $error("DATA does not match");
      h_cfg.test_status=1;
      h_cfg.print_string={h_cfg.print_string, $sformatf("Actual count = %0d; Expected DATA = %0h, Actual DATA = %0h, exp_mod = %0h, act_mod = %0h\n", h_cfg.act_count, h_exp_pkt.pkt_tx_data, h_act_pkt.pkt_rx_data, h_exp_pkt.pkt_tx_mod, h_act_pkt.pkt_rx_mod)};
    end
    if((h_act_pkt.pkt_rx_eop === 1) && (h_act_pkt.pkt_rx_mod  !==  h_exp_pkt.pkt_tx_mod)) begin
      $error("MOD does not match");
      h_cfg.test_status=1;
      h_cfg.print_string={h_cfg.print_string, $sformatf("Actual count = %0d; Expected MOD = %0h, Actual MOD = %0h\n", h_cfg.act_count, h_exp_pkt.pkt_tx_mod, h_act_pkt.pkt_rx_mod)};
    end
  endfunction: check_exp_data_and_act_data

  task wait_for_wb_pkt();
    xgemac_wb_pkt h_pkt;
    forever begin
      wb_mbx.get(h_pkt);
      $display("---------------> WISHBONE PACKET <---------------------------");
      $display("wb_dat_i = %0h, wb_adr_i = %0h, wb_we_i = %0h, wb_dat_o = %0h", h_pkt.wb_dat_i, h_pkt.wb_adr_i, h_pkt.wb_we_i, h_pkt.wb_dat_o);
      $display("-------------------------------------------------------------");
    end
  endtask: wait_for_wb_pkt

  function void report();
    if(expected.size()!=0) begin
      $error("EXPECTED QUEUE IS NOT EMPTY");
    end
    if(h_cfg.test_status) begin
      $error("%0s: TEST FAILED, REASON IS: %0s", TAG, h_cfg.print_string);
    end
    else begin
      $display("%0s: TEST PASS | ACTUAL COUNT IS = %0d", TAG, h_cfg.act_count);
    end
  endfunction: report

endclass: xgemac_scoreboard

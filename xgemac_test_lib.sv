class xgemac_base_test;

  xgemac_tb_config h_cfg;
  xgemac_env h_env;

  string TAG="XGEMAC_BASE_TEST";

  function void build();
    $display("%0s: Build method", TAG);
    set_test_specific_configuration();
    if(h_cfg.has_env) begin
      h_env=new(h_cfg);
      h_env.build();
    end
  endfunction: build

  function void connect();
    $display("%0s: Connect method", TAG);
    if(h_cfg.has_env) begin
      h_env.connect();
    end
  endfunction: connect

  task run();
    $display("%0s: Run method", TAG);
    if(h_cfg.has_env) begin
      h_env.run();
    end
    fork
      give_stimulus();
      wait_for_finish();
    join
  endtask: run

  function void report();
    $display("%0s: Report method", TAG);
    if(h_cfg.has_env) begin
      h_env.report();
    end
  endfunction: report

  function new(xgemac_tb_config h_cfg);
    this.h_cfg=h_cfg;
  endfunction: new

  virtual function void set_test_specific_configuration();
    $display("%0s: Set config method", TAG);
  endfunction: set_test_specific_configuration

  virtual task give_stimulus();
    $display("%0s: Give stimulus method", TAG);
  endtask: give_stimulus

  task wait_for_finish();
    process p[2];
    fork
      begin
        p[0]=process::self();
        wait(h_cfg.trans_count == h_cfg.act_count);
      end
      begin
        p[1]=process::self();
        #(`TIMEOUT*1ns);
        $error("TEST TIMEOUT -- act = %0d", h_cfg.act_count);
        h_cfg.test_status=1;
        h_cfg.print_string = {h_cfg.print_string, $sformatf("TEST TIMEOUT AT %0tns", $time/1000)};
      end
    join_any
    if(h_cfg.trans_count!=0) begin
      foreach(p[i]) begin
        p[i].kill();
      end
    end
  endtask: wait_for_finish

endclass: xgemac_base_test

class xgemac_direct_test extends xgemac_base_test;


  function new(xgemac_tb_config h_cfg);
    super.new(h_cfg);
    TAG = "XGEMAC_DIRECT_TEST";
  endfunction: new

  function void set_test_specific_configuration();
    $display("%0s: Set config method", TAG);
    h_cfg.trans_count = 10;
  endfunction: set_test_specific_configuration

  task give_stimulus();
    $display("%0s: Give stimulus", TAG);
    h_env.h_tx_gen.gen_direct_stimulus_and_put_in_mbx();
  endtask: give_stimulus

endclass: xgemac_direct_test

class xgemac_incremental_test extends xgemac_base_test;

  function new(xgemac_tb_config h_cfg);
    super.new(h_cfg);
    TAG = "XGEMAC_INCREMENTAL_TEST";
  endfunction: new

  function void set_test_specific_configuration();
    $display("%0s: Set config method", TAG);
    h_cfg.trans_count=100;
  endfunction: set_test_specific_configuration

  task give_stimulus();
    $display("%0s: Set config method", TAG);
    h_env.h_tx_gen.gen_incremental_stimulus_and_put_in_mbx();
  endtask: give_stimulus

endclass: xgemac_incremental_test

class xgemac_random_test extends xgemac_base_test;

  function new(xgemac_tb_config h_cfg);
    super.new(h_cfg);
    TAG = "XGEMAC_RANDOM_TEST";
  endfunction: new

  function void set_test_specific_configuration();
    $display("%0s: Set config method", TAG);
    h_cfg.trans_count=$urandom_range(100, 500);
  endfunction: set_test_specific_configuration

  task give_stimulus();
    $display("%0s: Give stimulus method", TAG);
    h_env.h_tx_gen.gen_random_stimulus_and_put_in_mbx();
  endtask: give_stimulus

endclass: xgemac_random_test

class xgemac_wb_test extends xgemac_base_test;

  function new(xgemac_tb_config h_cfg);
    super.new(h_cfg);
    TAG = "XGEMAC_WB_TEST";
  endfunction: new

  function void set_test_specific_configuration();
    $display("%0s: Set config method", TAG);
    h_cfg.trans_count=50;
  endfunction: set_test_specific_configuration

  task give_stimulus();
    $display("%0s: Give stimulus", TAG);
    h_env.h_tx_gen.gen_direct_stimulus_and_put_in_mbx();
    h_env.h_wb_gen.tx_octets_count();
    h_env.h_wb_gen.tx_packet_count();
    h_env.h_wb_gen.rx_octets_count();
    h_env.h_wb_gen.rx_packet_count();
    #100ns;
  endtask: give_stimulus

endclass: xgemac_wb_test

class xgemac_padding_test extends xgemac_base_test;

  function new(xgemac_tb_config h_cfg);
    super.new(h_cfg);
    TAG = "XGEMAC_PADDING_TEST";
  endfunction: new

  function void set_test_specific_configuration();
    $display("%0s: Set config method", TAG);
    h_cfg.trans_count=4;
  endfunction: set_test_specific_configuration

  task give_stimulus();
    $display("%0s: Give stimulus", TAG);
    h_env.h_tx_gen.gen_direct_stimulus_and_put_in_mbx();
  endtask: give_stimulus

endclass: xgemac_padding_test

class xgemac_tx_full_test extends xgemac_base_test;

  function new(xgemac_tb_config h_cfg);
    super.new(h_cfg);
    TAG = "XGEMAC_TX_FULL_TEST";
  endfunction: new

  function void set_test_specific_configuration();
    $display("%0s: Set config method", TAG);
    h_cfg.trans_count=800;
    h_cfg.has_rx_drv=0;
  endfunction: set_test_specific_configuration

  task give_stimulus();
    $display("%0s: Give stimulus", TAG);
    h_env.h_tx_gen.gen_direct_stimulus_and_put_in_mbx();
  endtask: give_stimulus

endclass: xgemac_tx_full_test

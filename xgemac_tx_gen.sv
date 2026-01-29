class xgemac_tx_gen;

  string TAG = "XGEMAC_TX_GEN";

  mailbox#(xgemac_tx_pkt) tx_mbx;
  xgemac_tb_config h_cfg;

  function new(xgemac_tb_config h_cfg);
    this.h_cfg=h_cfg;
  endfunction: new

  function void build();
    $display("%0s: Build method", TAG);
    tx_mbx=new(1);
  endfunction: build

  function void connect();
    $display("%0s: Connect method", TAG);
  endfunction: connect

  task gen_direct_stimulus_and_put_in_mbx();
    xgemac_tx_pkt h_pkt, h_cl_pkt;
    int unsigned count;
    repeat(h_cfg.trans_count) begin
      h_pkt=new();
      h_pkt.pkt_tx_data = `DATA_WIDTH'hFFFF_FFFF_FFFF_FFFF;
      h_pkt.pkt_tx_sop  = (count==0) ? 'h1 : 'h0;
      count++;
      h_pkt.pkt_tx_eop  = (count==h_cfg.trans_count) ? 'h1 : 'h0;
      h_pkt.pkt_tx_mod  = (count==h_cfg.trans_count) ? 'h1 : 'h0;
      $cast(h_cl_pkt, h_pkt.clone());
      tx_mbx.put(h_cl_pkt);
    end
  endtask: gen_direct_stimulus_and_put_in_mbx

  task gen_incremental_stimulus_and_put_in_mbx();
    xgemac_tx_pkt h_pkt, h_cl_pkt;
    int unsigned count, temp_count, tot_count;
    count=10;
    repeat(h_cfg.trans_count) begin
      h_pkt=new();
      h_pkt.pkt_tx_data   =   h_cfg.incr_start_data;
      h_cfg.incr_start_data++;
      temp_count++;
      tot_count++;
      if(temp_count==1) begin
        h_pkt.pkt_tx_sop    =   'h1;
      end
      else begin
        h_pkt.pkt_tx_sop    =   'h0;
      end
      if(temp_count==count || tot_count==h_cfg.trans_count) begin
        h_pkt.pkt_tx_eop    =   'h1;
        h_pkt.pkt_tx_mod    =   'h0;
        temp_count=0;
      end
      else begin
        h_pkt.pkt_tx_eop    =   'h0;
        h_pkt.pkt_tx_mod    =   'h0;
      end
      $cast(h_cl_pkt, h_pkt.clone());
      tx_mbx.put(h_cl_pkt);
    end
  endtask: gen_incremental_stimulus_and_put_in_mbx

  task gen_random_stimulus_and_put_in_mbx();
    xgemac_tx_pkt h_pkt, h_cl_pkt;
    int unsigned count, index;
    int unsigned arr[];
    if(!std::randomize(arr) with {arr.size()==(h_cfg.trans_count/10);arr.sum()==h_cfg.trans_count; foreach(arr[i]) {arr[i]<=20;arr[i]>=10;}}) begin
      $display("Array randomization fail in tx generator");
    end
    repeat(h_cfg.trans_count) begin
      h_pkt=new();
      count++;
      if(!h_pkt.randomize()) begin
        $error("RANDOMIZATION FAIL");
      end
      if(count == 1) begin
        h_pkt.pkt_tx_sop  = 'h1;
      end
      else begin
        h_pkt.pkt_tx_sop  = 'h0;
      end
      if(count == arr[index]) begin
        h_pkt.pkt_tx_eop  = 'h1;
        h_pkt.pkt_tx_sop  = 'h0;
        count = 0;
        index++;
      end
      else begin
        h_pkt.pkt_tx_eop  = 'h0;
      end
      $cast(h_cl_pkt, h_pkt.clone());
      tx_mbx.put(h_cl_pkt);
    end
  endtask: gen_random_stimulus_and_put_in_mbx

  task get_plusargs_or_rand_and_put_in_mbx();
    xgemac_tx_pkt h_pkt, h_cl_pkt;
    int unsigned count;
    bit [`DATA_WIDTH - 1: 0] tx_data;
    repeat(h_cfg.trans_count) begin
      h_pkt=new();
      if($value$plusargs({$sformatf("%0d: TX_DATA=", count), "%0d"}, tx_data)) begin
        h_pkt.pkt_tx_data = tx_data;
      end
      else begin
        h_pkt.pkt_tx_data = $urandom;
      end
      $cast(h_cl_pkt, h_pkt.clone());
      tx_mbx.put(h_cl_pkt);
    end
  endtask: get_plusargs_or_rand_and_put_in_mbx

endclass: xgemac_tx_gen

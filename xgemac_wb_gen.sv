class xgemac_wb_gen;

  string TAG = "XGEMAC_WB_GEN";

  mailbox#(xgemac_wb_pkt) wb_mbx;
  xgemac_tb_config h_cfg;

  function new(xgemac_tb_config h_cfg);
    this.h_cfg = h_cfg;
  endfunction: new

  function void build();
    $display("%0s: Build method", TAG);
    wb_mbx=new(1);
  endfunction: build

  function void connect();
    $display("%0s: Connect method", TAG);
  endfunction: connect

  task read_tx_enable();
    xgemac_wb_pkt h_pkt, h_cl_pkt;
    h_pkt = new();
    h_pkt.wb_adr_i  = 'h0;
    h_pkt.wb_we_i   = 'h0;
    $cast(h_cl_pkt, h_pkt.clone());
    wb_mbx.put(h_cl_pkt);
  endtask: read_tx_enable
  
  task dis_tx_enable();
    xgemac_wb_pkt h_pkt, h_cl_pkt;
    h_pkt = new();
    h_pkt.wb_adr_i  = 'h0;
    h_pkt.wb_we_i   = 'h1;
    h_pkt.wb_dat_i  = 'h0;
    $cast(h_cl_pkt, h_pkt.clone());
    wb_mbx.put(h_cl_pkt);
  endtask: dis_tx_enable

  task tx_octets_count();
    xgemac_wb_pkt h_pkt, h_cl_pkt;
    h_pkt = new();
    h_pkt.wb_adr_i  = 'h80;
    h_pkt.wb_we_i   = 'h0;
    $cast(h_cl_pkt, h_pkt.clone());
    wb_mbx.put(h_cl_pkt);
  endtask: tx_octets_count

  task tx_packet_count();
    xgemac_wb_pkt h_pkt, h_cl_pkt;
    h_pkt = new();
    h_pkt.wb_adr_i  = 'h84;
    h_pkt.wb_we_i   = 'h0;
    $cast(h_cl_pkt, h_pkt.clone());
    wb_mbx.put(h_cl_pkt);
  endtask: tx_packet_count

  task rx_octets_count();
    xgemac_wb_pkt h_pkt, h_cl_pkt;
    h_pkt = new();
    h_pkt.wb_adr_i  = 'h90;
    h_pkt.wb_we_i   = 'h0;
    $cast(h_cl_pkt, h_pkt.clone());
    wb_mbx.put(h_cl_pkt);
  endtask: rx_octets_count

  task rx_packet_count();
    xgemac_wb_pkt h_pkt, h_cl_pkt;
    h_pkt = new();
    h_pkt.wb_adr_i  = 'h94;
    h_pkt.wb_we_i   = 'h0;
    $cast(h_cl_pkt, h_pkt.clone());
    wb_mbx.put(h_cl_pkt);
  endtask: rx_packet_count

endclass: xgemac_wb_gen

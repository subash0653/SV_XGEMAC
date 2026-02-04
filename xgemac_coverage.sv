class xgemac_coverage;

  xgemac_tx_pkt h_tx_pkt;
  xgemac_rx_pkt h_rx_pkt;

  xgemac_tb_config h_cfg;

  covergroup tx_pkt();

    option.auto_bin_max = 128;

    pkt_tx_sop:    coverpoint h_tx_pkt.pkt_tx_sop;
    pkt_tx_eop:    coverpoint h_tx_pkt.pkt_tx_eop;
    pkt_tx_mod:    coverpoint h_tx_pkt.pkt_tx_mod;
    pkt_tx_data:   coverpoint h_tx_pkt.pkt_tx_data;

  endgroup: tx_pkt

  covergroup rx_pkt();

    option.auto_bin_max = 128;

    pkt_rx_sop:    coverpoint h_rx_pkt.pkt_rx_sop;
    pkt_rx_eop:    coverpoint h_rx_pkt.pkt_rx_eop;
    pkt_rx_mod:    coverpoint h_rx_pkt.pkt_rx_mod;
    pkt_rx_data:   coverpoint h_rx_pkt.pkt_rx_data;

  endgroup: rx_pkt

  covergroup features();

    padding:  coverpoint h_cfg.padding_feature{
      bins bin_0 = {1};
    }

  endgroup: features

  function new(xgemac_tb_config h_cfg);
    this.h_cfg = h_cfg;
    tx_pkt=new();
    rx_pkt=new();
    features=new();
  endfunction: new

  function void tx_sample(xgemac_tx_pkt h_tx_pkt);
    this.h_tx_pkt = h_tx_pkt;
    tx_pkt.sample();
    features.sample();
  endfunction: tx_sample

  function void rx_sample(xgemac_rx_pkt h_rx_pkt);
    this.h_rx_pkt = h_rx_pkt;
    rx_pkt.sample();
    features.sample();
  endfunction: rx_sample

  function void display_coverage();
    $display("COVERAGE PERCENTAGE -> %.2f", tx_pkt.get_coverage());
  endfunction: display_coverage

endclass: xgemac_coverage

class xgemac_rx_pkt;

  bit [`DATA_WIDTH-1:0]  pkt_rx_data;
  bit                    pkt_rx_sop;
  bit                    pkt_rx_eop;
  bit [`MOD_WIDTH-1:0]   pkt_rx_mod;
  bit                    pkt_rx_err;

  function void display();
    $display("rx_data = %0h, rx_sop = %0b, rx_eop = %0b, rx_mod = %0h, rx_err = %0d", 
              pkt_rx_data, pkt_rx_sop, pkt_rx_eop, pkt_rx_mod, pkt_rx_err);
  endfunction: display

  function xgemac_rx_pkt clone();
    xgemac_rx_pkt h_pkt;
    h_pkt=new();
    h_pkt.copy(this);
    return h_pkt;
  endfunction: clone

  function void copy(xgemac_rx_pkt h_rx_pkt);
    this.pkt_rx_data  =   h_rx_pkt.pkt_rx_data;
    this.pkt_rx_sop   =   h_rx_pkt.pkt_rx_sop;
    this.pkt_rx_eop   =   h_rx_pkt.pkt_rx_eop;
    this.pkt_rx_mod   =   h_rx_pkt.pkt_rx_mod;
    this.pkt_rx_err   =   h_rx_pkt.pkt_rx_err;
  endfunction: copy

endclass: xgemac_rx_pkt

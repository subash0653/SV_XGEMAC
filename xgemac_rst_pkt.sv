class xgemac_rst_pkt;

  int unsigned rst_period;

  function void copy(xgemac_rst_pkt h_pkt);
    this.rst_period = h_pkt.rst_period;
  endfunction: copy

  function xgemac_rst_pkt clone();
    xgemac_rst_pkt h_pkt;
    h_pkt = new();
    h_pkt.copy(this);
    return h_pkt;
  endfunction: clone

endclass: xgemac_rst_pkt

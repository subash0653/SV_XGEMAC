class xgemac_wb_pkt;

  rand bit [`WB_ADDR_WIDTH-1:0] wb_adr_i;
  rand bit [`WB_DATA_WIDTH-1:0] wb_dat_i;
  rand bit                      wb_we_i;

       bit [`WB_DATA_WIDTH-1:0] wb_dat_o;
       bit                      wb_int_o;

  function void display();
    $display("wb_adr_i = %0h, wb_dat_i = %0h, wb_we_i = %0h, wb_dat_o = %0h, wb_int_o = %0h", wb_adr_i, wb_dat_i, wb_we_i, wb_dat_o, wb_int_o);
  endfunction: display

  function xgemac_wb_pkt clone();
    xgemac_wb_pkt h_wb_pkt;
    h_wb_pkt=new();
    h_wb_pkt.copy(this);
    return h_wb_pkt;
  endfunction: clone

  function void copy(xgemac_wb_pkt h_pkt);
    this.wb_adr_i = h_pkt.wb_adr_i;
    this.wb_dat_i = h_pkt.wb_dat_i;
    this.wb_we_i  = h_pkt.wb_we_i;
    this.wb_dat_o = h_pkt.wb_dat_o;
    this.wb_int_o = h_pkt.wb_int_o;
  endfunction: copy

endclass: xgemac_wb_pkt

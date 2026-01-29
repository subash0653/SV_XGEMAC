class xgemac_tx_pkt;

  rand bit [`DATA_WIDTH-1:0]  pkt_tx_data;
  rand bit                    pkt_tx_sop;
  rand bit                    pkt_tx_eop;
  rand bit [`MOD_WIDTH-1:0]   pkt_tx_mod;

  function void display();
    $display("tx_data = %0h, tx_sop = %0b, tx_eop = %0b, tx_mod = %0h", pkt_tx_data, pkt_tx_sop, pkt_tx_eop, pkt_tx_mod);
  endfunction: display

  function xgemac_tx_pkt clone();
    xgemac_tx_pkt tx_pkt;
    tx_pkt=new();
    tx_pkt.copy(this);
    return tx_pkt;
  endfunction: clone

  function void copy(xgemac_tx_pkt h_tx_pkt);
    this.pkt_tx_data  = h_tx_pkt.pkt_tx_data;
    this.pkt_tx_sop   = h_tx_pkt.pkt_tx_sop;
    this.pkt_tx_eop   = h_tx_pkt.pkt_tx_eop;
    this.pkt_tx_mod   = h_tx_pkt.pkt_tx_mod;
  endfunction: copy

 // bit sop_flag, eop_flag=1;
 // bit initial_flag=1;

 // constraint c{
 //  (pkt_tx_sop & pkt_tx_eop) !=1; 
 //  if(sop_flag) pkt_tx_sop == 0;
 //  if(eop_flag) {pkt_tx_eop == 0; pkt_tx_sop == 1;}
 //  pkt_tx_sop dist{0:=4, 1:=1};
 //  pkt_tx_eop dist{0:=4, 1:=1};
 //  pkt_tx_eop==0 -> {pkt_tx_mod==0};
 //  if(initial_flag) pkt_tx_sop==1;
 //  !pkt_tx_mod inside {1, 2, 3, 4};
 //}

 // function void post_randomize();
 //   if(pkt_tx_sop) begin
 //     eop_flag=0;
 //     sop_flag=1;
 //   end
 //   if(pkt_tx_eop) begin
 //     eop_flag=1;
 //     sop_flag=0;
 //   end
 //   initial_flag=0;
 // endfunction: post_randomize

endclass: xgemac_tx_pkt

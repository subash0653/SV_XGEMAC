interface xgemac_tx_interface(input clk, rst_n);

  logic [`DATA_WIDTH - 1:0]   pkt_tx_data;
  logic                       pkt_tx_val;
  logic                       pkt_tx_sop;
  logic                       pkt_tx_eop;
  logic [`MOD_WIDTH - 1:0]    pkt_tx_mod;
  logic                       pkt_tx_full;

  clocking drcb@(posedge clk);

    output pkt_tx_data;
    output pkt_tx_val;
    output pkt_tx_sop;
    output pkt_tx_eop;
    output pkt_tx_mod;
        
  endclocking: drcb

  clocking mrcb@(posedge clk);

    input pkt_tx_data;
    input pkt_tx_val;
    input pkt_tx_sop;
    input pkt_tx_eop;
    input pkt_tx_mod;
    input pkt_tx_full;
        
  endclocking: mrcb

  initial begin
    $display("XGEMAC_TX_INTERFACE");
  end

endinterface: xgemac_tx_interface

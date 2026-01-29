interface xgemac_rx_interface(input clk, rst_n);

  logic                       pkt_rx_ren;
  logic                       pkt_rx_val;
  logic                       pkt_rx_avail;
  logic [`DATA_WIDTH - 1:0]   pkt_rx_data;
  logic                       pkt_rx_sop;
  logic                       pkt_rx_eop;
  logic [`MOD_WIDTH - 1:0]    pkt_rx_mod;
  logic                       pkt_rx_err;

  clocking drcb@(posedge clk);

    output pkt_rx_ren;
        
  endclocking: drcb

  clocking mrcb@(posedge clk);

    input pkt_rx_ren;
    input pkt_rx_val;
    input pkt_rx_avail;
    input pkt_rx_data;
    input pkt_rx_sop;
    input pkt_rx_eop;
    input pkt_rx_mod;
    input pkt_rx_err;

  endclocking: mrcb

  initial begin
    $display("XGEMAC_RX_INTERFACE");
  end

endinterface: xgemac_rx_interface

interface xgemac_xgmii_txrx_interface(input clk, rst_n);

  logic [`XGMII_CONTROL_WIDTH - 1:0] xgmii_txrxc;
  logic [`XGMII_DATA_WIDTH - 1:0]    xgmii_txrxd;

  initial begin
    $display("XGEMAC_XGMII_TXRX_INTERFACE");
  end

endinterface: xgemac_xgmii_txrx_interface

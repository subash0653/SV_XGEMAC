//xgemac_txrx_interface defines

`define DATA_WIDTH  64
`define MOD_WIDTH   3

//xgemac_xgmii_interface defines

`define XGMII_CONTROL_WIDTH   8
`define XGMII_DATA_WIDTH      64

//xgemac_wb_interface defines

`define WB_ADDR_WIDTH   8
`define WB_DATA_WIDTH   32

//xgemac_global_signals

`define WB_CLOCK_PERIOD     10000
`define TXRX_CLOCK_PERIOD   6400
`define XGMII_CLOCK_PERIOD  6400

`define RESET_PERIOD        2

//Simulation time

`define TIMEOUT 5000

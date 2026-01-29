interface xgemac_wb_interface(input wb_clk_i, wb_rst_i);

  logic [`WB_ADDR_WIDTH - 1:0]    wb_adr_i;
  logic                           wb_cyc_i;
  logic [`WB_DATA_WIDTH - 1:0]    wb_dat_i;
  logic                           wb_stb_i;
  logic                           wb_we_i;
  logic                           wb_ack_o;
  logic [`WB_DATA_WIDTH - 1:0]    wb_dat_o;
  logic                           wb_int_o;

  clocking drcb@(posedge wb_clk_i);
        
    output wb_adr_i;
    output wb_cyc_i;
    output wb_dat_i;
    output wb_stb_i;
    output wb_we_i;

  endclocking: drcb

  clocking mrcb@(posedge wb_clk_i);

    input wb_adr_i;
    input wb_cyc_i;
    input wb_dat_i;
    input wb_stb_i;
    input wb_we_i;
    input wb_ack_o;
    input wb_dat_o;
    input wb_int_o;

  endclocking: mrcb

  initial begin
    $display("XGEMAC_WB_INTERFACE");
  end
    
endinterface: xgemac_wb_interface

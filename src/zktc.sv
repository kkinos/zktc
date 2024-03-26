module zktc (
    input logic clk,
    input logic rst,

    input logic trap
);

  logic [15:0] pc;

  // CPU State
  logic [ 7:0] cpu_state;

  localparam S_FETCH = 8'b0000_0001;
  localparam S_DECODE = 8'b0000_0010;
  localparam S_EXECUTE = 8'b0000_0100;
  localparam S_MEMORY = 8'b0000_1000;
  localparam S_WRITEBACK = 8'b0001_0000;
  localparam S_TRAP = 8'b0010_0000;

endmodule

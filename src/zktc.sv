`default_nettype none

module zktc (
    input logic clk,
    input logic rst,

    input logic trap,

    input logic mem_ready,
    input logic [15:0] mem_rdata,

    output logic mem_valid,
    output logic [15:0] mem_addr
);

  logic [15:0] pc;
  logic [15:0] next_pc;

  assign mem_addr = pc;
  logic [15:0] instr;

  localparam PC_INIT = 16'h0000;

  // CPU State
  logic [7:0] cpu_state;

  localparam S_FETCH = 8'b0000_0001;
  localparam S_DECODE = 8'b0000_0010;
  localparam S_EXECUTE = 8'b0000_0100;
  localparam S_MEMORY = 8'b0000_1000;
  localparam S_WRITEBACK = 8'b0001_0000;
  localparam S_TRAP = 8'b0010_0000;

  always_ff @(posedge clk) begin
    if (rst) begin
      pc <= PC_INIT;
      next_pc <= PC_INIT;
      cpu_state <= S_FETCH;
      mem_valid <= 0;
    end else begin
      case (cpu_state)
        S_FETCH: begin
          next_pc   <= pc + 4;
          mem_valid <= 1;
          if (mem_ready) begin
            mem_valid <= 0;
            instr <= mem_rdata;
            cpu_state <= S_DECODE;
          end
        end
        S_DECODE: begin
          cpu_state <= S_EXECUTE;
        end
        S_EXECUTE: begin
          cpu_state <= S_MEMORY;
        end
        S_MEMORY: begin
          cpu_state <= S_WRITEBACK;
        end
        S_WRITEBACK: begin
          cpu_state <= S_FETCH;
          pc <= next_pc;
        end
        S_TRAP: begin
          cpu_state <= S_FETCH;
        end
      endcase
    end
  end



endmodule

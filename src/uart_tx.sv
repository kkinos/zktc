module uart_tx #(
    parameter WAIT_CYCLES = 868  // 100M 115200 baud rate
) (
    input logic clk,
    input logic rst,
    input logic en,
    input logic [7:0] tx_data,

    output logic busy,
    output logic tx
);

  logic [$clog2(WAIT_CYCLES)-1:0] waitcnt;
  logic tx_clk;
  always_ff @(posedge clk) begin
    if (rst) begin
      waitcnt <= 0;
      tx_clk  <= 0;
    end else begin
      if (waitcnt == WAIT_CYCLES - 1) begin
        tx_clk  <= 1;
        waitcnt <= 0;
      end else begin
        tx_clk  <= 0;
        waitcnt <= waitcnt + 1;
      end
    end
  end

  typedef enum {
    START,
    SEND,
    STOP,
    FINISH
  } state_t;
  state_t state;


endmodule

module uart_tx #(
    parameter WAIT_COUNT = 868  // 100M 115200 baud rate
) (
    input logic clk,
    input logic rst,
    input logic en,
    input logic [7:0] tx_data,

    output logic busy,
    output logic tx
);

  typedef enum {
    IDLE,
    SEND
  } state_t;
  state_t state;

  logic [$clog2(WAIT_COUNT)-1:0] waitcnt;
  logic [3:0] bitcnt;
  logic [9:0] tx_buf;
  assign tx   = tx_buf[0];
  assign busy = state != IDLE;

  always_ff @(posedge clk) begin
    if (rst) begin
      state   <= IDLE;
      waitcnt <= 0;
      bitcnt  <= 0;
      tx_buf  <= 10'h3ff;
    end else begin
      case (state)
        IDLE: begin
          if (en) begin
            state  <= SEND;
            tx_buf <= {1'b1, tx_data, 1'b0};
          end
        end
        SEND: begin
          if (waitcnt != WAIT_COUNT) begin
            waitcnt <= waitcnt + 1;
          end else begin
            waitcnt <= 0;
            bitcnt  <= bitcnt + 1;
            tx_buf  <= {1'b1, tx_buf[9:1]};
            if (bitcnt == 9) begin
              bitcnt <= 0;
              state  <= IDLE;
            end
          end
        end
      endcase
    end
  end



endmodule

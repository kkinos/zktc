module uart_rx #(
    parameter WAIT_COUNT = 868  // 100M 115200 baud rate
) (
    input logic clk,
    input logic rst,
    input logic rx,
    input logic ien,
    input logic ack,

    output logic [7:0] rx_data,
    output logic busy,
    output logic valid,
    output logic irq
);

  typedef enum {
    IDLE,
    WAIT,
    READ
  } state_t;
  state_t state;

  parameter HALF_WAIT_COUNT = WAIT_COUNT / 2;

  logic [$clog2(WAIT_COUNT)-1:0] waitcnt;
  logic [3:0] bitcnt;
  logic [8:0] rx_buf;
  logic [3:0] start_edge;
  assign busy = state != IDLE;

  always_ff @(posedge clk) begin
    if (rst) begin
      state <= IDLE;
      waitcnt <= 0;
      bitcnt <= 0;
      rx_buf <= 0;
      start_edge <= 4'b1111;
      valid <= 0;
      irq <= 0;
    end else if (ack) begin
      irq <= 0;
    end else begin
      case (state)
        IDLE: begin
          start_edge <= {start_edge[2:0], rx};
          if (start_edge == 4'b1000) begin
            state   <= WAIT;
            waitcnt <= 0;
            valid   <= 0;
          end
        end
        WAIT: begin
          if (waitcnt != HALF_WAIT_COUNT) begin
            waitcnt <= waitcnt + 1;
          end else begin
            waitcnt <= 0;
            state   <= READ;
            bitcnt  <= 0;
            rx_buf  <= 0;
          end
        end
        READ: begin
          if (waitcnt != WAIT_COUNT) begin
            waitcnt <= waitcnt + 1;
          end else begin
            waitcnt <= 0;
            bitcnt  <= bitcnt + 1;
            rx_buf  <= {rx, rx_buf[8:1]};
          end
          if (bitcnt == 9) begin
            if (rx_buf[8]) begin
              rx_data <= rx_buf[7:0];
              valid   <= 1;
              if (ien) begin
                irq <= 1;
              end
            end
            bitcnt <= 0;
            start_edge <= 4'b1111;
            state <= IDLE;
          end
        end
      endcase
    end
  end


endmodule

module uart #(
    parameter WAIT_COUNT = 868  // 100M 115200 baud rate
) (
    input logic clk,
    input logic rst,

    input logic uart_valid,
    input logic uart_wstrb,
    input logic [7:0] uart_addr,
    input logic [15:0] uart_wdata,

    input logic rxd,
    input logic uart_rx_ack,

    output logic uart_ready,
    output logic [15:0] uart_rdata,

    output logic txd,
    output logic uart_rx_irq
);

  logic uart_tx_en;
  logic [7:0] uart_tx_data;
  logic uart_tx_busy;

  logic uart_rx_ien;
  logic uart_rx_valid;
  logic [7:0] uart_rx_data;
  logic uart_rx_busy;

  uart_tx #(
      .WAIT_COUNT(WAIT_COUNT)
  ) uart_tx (
      .clk(clk),
      .rst(rst),
      .en(uart_tx_en),
      .tx_data(uart_tx_data),

      .busy(uart_tx_busy),
      .tx  (txd)
  );

  uart_rx #(
      .WAIT_COUNT(WAIT_COUNT)
  ) uart_rx (
      .clk(clk),
      .rst(rst),
      .rx (rxd),
      .ien(uart_rx_ien),
      .ack(uart_rx_ack),

      .rx_data(uart_rx_data),
      .busy(uart_rx_busy),
      .valid(uart_rx_valid),
      .irq(uart_rx_irq)
  );

endmodule

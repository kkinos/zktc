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
  logic uart_tx_busy;

  logic uart_rx_ien;
  logic uart_rx_valid;
  logic uart_rx_busy;

  logic [7:0] uart_tx_status;
  logic [7:0] uart_tx_enable;
  logic [7:0] uart_tx_data;

  logic [7:0] uart_rx_status;
  logic [7:0] uart_rx_ir_enable;
  logic [7:0] uart_rx_data_valid;
  logic [7:0] uart_rx_data;

  always_ff @(posedge clk) begin
    if (rst || uart_ready) begin
      uart_ready <= 0;
    end else if (uart_valid) begin
      uart_ready <= 1;
    end
  end

  always_ff @(posedge clk) begin
    if (rst) begin
      uart_tx_status <= 8'b0;
      uart_rx_status <= 8'b0;
      uart_rx_data_valid <= 8'b0;
    end else begin
      uart_tx_status <= {7'b0, uart_tx_busy};
      uart_rx_status <= {7'b0, uart_rx_busy};
      uart_rx_data_valid <= {7'b0, uart_rx_valid};
    end
  end


  always_comb begin
    case (uart_addr)
      8'h00:   uart_rdata = uart_tx_status;
      8'h10:   uart_rdata = uart_rx_status;
      8'h14:   uart_rdata = uart_rx_data_valid;
      8'h16:   uart_rdata = uart_rx_data;
      default: uart_rdata = 16'h0;
    endcase
  end

  always_ff @(posedge clk) begin
    if (rst) begin
      uart_tx_enable <= 8'b0;
      uart_tx_data <= 8'b0;
      uart_rx_ir_enable <= 8'b0;
    end else if (uart_wstrb) begin
      case (uart_addr)
        8'h02:   uart_tx_enable <= uart_wdata[7:0];
        8'h04:   uart_tx_data <= uart_wdata[7:0];
        8'h14:   uart_rx_ir_enable <= uart_wdata[7:0];
        default: ;
      endcase
    end
  end

  assign uart_tx_en  = uart_tx_enable[0];
  assign uart_rx_ien = uart_rx_ir_enable[0];

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

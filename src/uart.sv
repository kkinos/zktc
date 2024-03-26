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

  logic tx_en;
  logic tx_busy;

  logic rx_ien;
  logic rx_valid;
  logic rx_busy;

  logic rx_data_valid;
  logic prev_rx_valid;

  logic [7:0] tx_status_reg;
  logic [7:0] tx_en_reg;
  logic [7:0] tx_data;

  logic [7:0] rx_status_reg;
  logic [7:0] rx_ir_en_reg;
  logic [7:0] rx_valid_reg;
  logic [7:0] rx_data;

  always_ff @(posedge clk) begin
    if (rst || uart_ready) begin
      uart_ready <= 0;
    end else if (uart_valid) begin
      uart_ready <= 1;
    end
  end

  always_ff @(posedge clk) begin
    if (rst) begin
      tx_status_reg <= 8'b0;
      rx_status_reg <= 8'b0;
      rx_valid_reg  <= 8'b0;
    end else begin
      tx_status_reg <= {7'b0, tx_busy};
      rx_status_reg <= {7'b0, rx_busy};
      rx_valid_reg  <= {7'b0, rx_data_valid};
    end
  end

  always_comb begin
    case (uart_addr)
      8'h00:   uart_rdata = {8'b0, tx_status_reg};
      8'h10:   uart_rdata = {8'b0, rx_status_reg};
      8'h14:   uart_rdata = {8'b0, rx_valid_reg};
      8'h16:   uart_rdata = {8'b0, rx_data};
      default: uart_rdata = 16'h0;
    endcase
  end

  always_ff @(posedge clk) begin
    if (rst) begin
      rx_data_valid <= 0;
      prev_rx_valid <= 0;
    end else if (rx_valid && !prev_rx_valid) begin
      rx_data_valid <= 1;
    end else if (uart_valid && (uart_addr == 8'h16)) begin
      rx_data_valid <= 0;
    end
    prev_rx_valid <= rx_valid;
  end

  always_ff @(posedge clk) begin
    if (rst) begin
      tx_en_reg <= 8'b0;
      tx_data <= 8'b0;
      rx_ir_en_reg <= 8'b0;
    end else if (uart_wstrb) begin
      case (uart_addr)
        8'h02:   tx_en_reg <= uart_wdata[7:0];
        8'h04:   tx_data <= uart_wdata[7:0];
        8'h12:   rx_ir_en_reg <= uart_wdata[7:0];
        default: ;
      endcase
    end
  end

  assign tx_en  = tx_en_reg[0];
  assign rx_ien = rx_ir_en_reg[0];

  uart_tx #(
      .WAIT_COUNT(WAIT_COUNT)
  ) uart_tx (
      .clk(clk),
      .rst(rst),
      .en(tx_en),
      .tx_data(tx_data),

      .busy(tx_busy),
      .tx  (txd)
  );

  uart_rx #(
      .WAIT_COUNT(WAIT_COUNT)
  ) uart_rx (
      .clk(clk),
      .rst(rst),
      .rx (rxd),
      .ien(rx_ien),
      .ack(uart_rx_ack),

      .rx_data(rx_data),
      .busy(rx_busy),
      .valid(rx_valid),
      .irq(uart_rx_irq)
  );
endmodule

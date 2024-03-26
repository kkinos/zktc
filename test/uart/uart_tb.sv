module uart_tb ();
  logic clk;
  logic rst;
  logic [7:0] tx_data;
  logic en;
  logic busy_tx;
  logic tx;
  logic [7:0] rx_data;
  logic busy_rx;
  logic rx;
  logic ien;
  logic ack;
  logic valid;
  logic irq;

  assign rx = tx;

  initial begin
    tx_data = 8'b10010110;
  end

  uart_tx #(
      .WAIT_COUNT(868)
  ) uart_tx (
      .clk(clk),
      .rst(rst),
      .en(en),
      .tx_data(tx_data),
      .busy(busy_tx),
      .tx(tx)
  );

  uart_rx #(
      .WAIT_COUNT(868)
  ) uart_rx (
      .clk(clk),
      .rst(rst),
      .rx(rx),
      .ien(ien),
      .ack(ack),
      .rx_data(rx_data),
      .busy(busy_rx),
      .valid(valid),
      .irq(irq)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    #10;
    rst = 1;
    #10;
    rst = 0;
  end

  initial begin
    ien = 1;
  end

  initial begin
    #100;
    #10;
    en = 1;
    #10;
    en = 0;

    #100000;
    if (tx_data == rx_data) begin
      $display("\x1b[32m");
      $display("=== UART module test passed ===");
      $display("\x1b[0m");
    end else begin
      $display("\x1b[31m");
      $display("=== UART module test failed ===");
      $display("\x1b[0m");
    end
    $finish;
  end

  initial begin
    $dumpfile("uart_tb.vcd");
    $dumpvars(0, uart_tb);
  end

endmodule

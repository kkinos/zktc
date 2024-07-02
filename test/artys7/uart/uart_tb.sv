module uart_tb;
  logic clk;
  logic rstn;
  logic txd;
  logic [3:0] led;
  logic rxd;

  assign rxd = txd;

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    #10;
    rstn = 0;
    #10;
    rstn = 1;
  end

  zktc_artys7 zktc_artys7 (
      .clk (clk),
      .rstn(rstn),
      .rxd (rxd),
      .led (led),
      .txd (txd)
  );

  always @(negedge clk) begin
    if (led == 4'b1010) begin
      $display("\x1b[32m");
      $display("=== UART test passed ===");
      $display("\x1b[0m");
      $finish;
    end
  end

  initial begin
    #600000;
    $display("\x1b[31m");
    $display("=== UART test failed ===");
    $display("\x1b[0m");
    $finish;
  end

  initial begin
    $dumpfile("uart_tb.vcd");
    $dumpvars(0, uart_tb);
  end

endmodule



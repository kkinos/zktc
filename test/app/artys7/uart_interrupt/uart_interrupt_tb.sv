module uart_interrupt_tb;
  logic clk;
  logic rstn;
  logic txd;
  logic [3:0] led;
  logic rxd;
  logic io0;
  logic io1;
  logic io2;
  logic io3;
  logic io4;
  logic io5;
  logic io6;
  logic io7;

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
      .txd (txd),
      .io0 (io0),
      .io1 (io1),
      .io2 (io2),
      .io3 (io3),
      .io4 (io4),
      .io5 (io5),
      .io6 (io6),
      .io7 (io7)
  );

  always @(negedge clk) begin
    if (led == 4'b1010) begin
      $display("\x1b[32m");
      $display("=== Arty S7 UART INTERRUPT app test passed ===");
      $display("\x1b[0m");
      $finish;
    end
  end

  initial begin
    #1000000;
    $display("\x1b[31m");
    $display("=== Arty S7 UART INTERRUPT app test failed ===");
    $display("\x1b[0m");
    $finish;
  end

  initial begin
    $dumpfile("uart_interrupt_tb.vcd");
    $dumpvars(0, uart_interrupt_tb);
  end

endmodule



module led_tb;
  logic clk;
  logic rstn;
  logic txd;
  logic [3:0] led;
  logic rxd;

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

  initial begin
    rxd = 0;
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
      $display("=== Arty S7 LED app test passed ===");
      $display("\x1b[0m");
      $finish;
    end
  end

  initial begin
    #1000000;
    $display("\x1b[31m");
    $display("=== Arty S7 LED app test failed ===");
    $display("\x1b[0m");
    $finish;
  end

  initial begin
    $dumpfile("led_tb.vcd");
    $dumpvars(0, led_tb);
  end

endmodule



module app_tb;
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
    txd = 0;
  end

  zktc_artys7 zktc_artys7 (
      .clk (clk),
      .rstn(rstn),
      .txd (txd),
      .led (led),
      .rxd (rxd)
  );

  always @(negedge clk) begin
    if (led == 4'b1010) begin
      $display("\x1b[32m");
      $display("=== APP test passed ===");
      $display("\x1b[0m");
      $finish;
    end
  end

  initial begin
    #600000;
    $display("\x1b[31m");
    $display("=== APP test failed ===");
    $display("\x1b[0m");
    $finish;
  end

  initial begin
    $dumpfile("app_tb.vcd");
    $dumpvars(0, app_tb);
  end

endmodule



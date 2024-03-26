module soft_trap_tb;
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
    if (led == 4'b0111) begin
      $display("\x1b[32m");
      $display("=== TRAP test passed ===");
      $display("\x1b[0m");
      $finish;
    end
  end

  initial begin
    #1000;
    $display("\x1b[31m");
    $display("=== TRAP test failed ===");
    $display("\x1b[0m");
    $finish;
  end

  initial begin
    $dumpfile("soft_trap_tb.vcd");
    $dumpvars(0, soft_trap_tb);
  end

endmodule



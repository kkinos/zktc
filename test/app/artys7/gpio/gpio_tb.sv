module gpio_tb;
  logic clk;
  logic rstn;
  logic txd;
  logic [3:0] led;
  logic rxd;

  logic io1;
  logic io2;
  logic io3;
  logic io4;
  logic io5;
  logic io6;
  logic io7;

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

  wire io0;
  reg  io0_reg;
  assign io0 = io0_reg;

  initial begin
    io0_reg = 1'b1;
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
    if (io1 == 1) begin
      $display("\x1b[32m");
      $display("=== Arty S7 GPIO app test passed ===");
      $display("\x1b[0m");
      $finish;
    end
  end

  initial begin
    #600000;
    $display("\x1b[31m");
    $display("=== Arty S7 GPIO app test failed ===");
    $display("\x1b[0m");
    $finish;
  end

  initial begin
    $dumpfile("gpio_tb.vcd");
    $dumpvars(0, gpio_tb);
  end

endmodule



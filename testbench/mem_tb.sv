module tb_mem;
  parameter TB_MEM_SIZE = 16'h5000;
  reg clk;
  reg we;
  reg [15:0] addr;
  reg [15:0] din;
  wire [15:0] dout;
  mem #(
      .MEM_SIZE(TB_MEM_SIZE)
  ) mem (
      .clk (clk),
      .we  (we),
      .addr(addr),
      .din (din),
      .dout(dout)
  );

  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end

  initial begin
    we   = 1;
    addr = 16'h0000;
    din  = 16'hdead;
    #20;
    we = 0;
    #20;
    if (dout == din) begin
      $display("Test passed");
      $display("Read data from address %h: %h", addr, dout);
    end else begin
      $display("Test failed: expected %h, got %h", din, dout);
    end
    $finish;
  end

  initial begin
    $dumpfile("tb_mem.vcd");
    $dumpvars(0, tb_mem);
  end

endmodule

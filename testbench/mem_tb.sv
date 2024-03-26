module tb_mem;
  parameter TB_MEM_SIZE = 16'h5000;
  logic clk;
  logic [1:0] we;
  logic re;
  logic [15:0] addr;
  logic [15:0] din;
  logic [15:0] dout;
  integer i;
  mem #(
      .MEM_SIZE(TB_MEM_SIZE)
  ) mem (
      .clk (clk),
      .we  (we),
      .re  (re),
      .addr(addr),
      .din (din),
      .dout(dout)
  );

  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end

  initial begin
    we   = 2'b10;
    re   = 1;
    addr = 16'h0000;
    din  = 16'hdead;
    #20;
    we = 0;
    #20;
    we   = 2'b10;
    addr = 16'h0002;
    din  = 16'hbeef;
    #20;
    we = 0;
    #20;
    we   = 2'b10;
    addr = 16'h0004;
    din  = 16'hcafe;
    #20;
    we = 0;
    #20;
    we   = 2'b10;
    addr = 16'h0006;
    din  = 16'hbabe;
    #20;
    we = 0;
    #20;

    for (i = 0; i < 8; i = i + 1) begin
      addr = i;
      #20;
      $display("Read data from address %h: %h", addr, dout);
    end

    // if (dout == din) begin
    //   $display("Test passed");
    //   $display("Read data from address %h: %h", addr, dout);
    // end else begin
    //   $display("Test failed: expected %h, got %h", din, dout);
    // end
    $finish;
  end



  initial begin
    $dumpfile("tb_mem.vcd");
    $dumpvars(0, tb_mem);
  end


endmodule

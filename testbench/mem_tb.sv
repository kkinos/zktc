`default_nettype none

module tb_mem;
  parameter TB_MEM_SIZE = 16'h5000;
  logic clk;
  logic [1:0] mem_wstrb;
  logic mem_vaild;
  logic [15:0] addr;
  logic [15:0] din;
  logic [15:0] dout;
  logic mem_ready;
  integer i;
  mem #(
      .MEM_SIZE(TB_MEM_SIZE)
  ) mem (
      .clk  (clk),
      .wstrb(mem_wstrb),
      .vaild(mem_vaild),
      .addr (addr),
      .din  (din),

      .dout (dout),
      .ready(mem_ready)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    #5;
    mem_wstrb = 2'b10;
    mem_vaild = 1;
    addr = 16'h0000;
    din = 16'hdead;
    #20;
    mem_vaild = 0;
    mem_wstrb = 2'b00;
    #10;
    mem_wstrb = 2'b10;
    mem_vaild = 1;
    addr = 16'h0002;
    din = 16'hbeef;
    #20;
    mem_vaild = 0;
    mem_wstrb = 2'b00;
    #10;
    mem_vaild = 1;
    addr = 16'h0000;
    #20;
    mem_vaild = 0;
    if (mem_ready == 1) $display("Read data from address %h: %h", addr, dout);
    #10;
    mem_vaild = 1;
    addr = 16'h0002;
    #20;
    mem_vaild = 0;
    if (mem_ready == 1) $display("Read data from address %h: %h", addr, dout);
    // mem_wstrb = 2'b10;
    // mem_vaild = 1;
    // addr = 16'h0002;
    // din = 16'hbeef;
    // #25;
    // mem_vaild = 0;
    // mem_wstrb = 2'b00;
    // #25;
    // mem_vaild = 1;
    // addr = 16'h0000;
    // #10;
    // $display("Read data from address %h: %h", addr, dout);
    // #20;
    // mem_wstrb = 2'b10;
    // addr = 16'h0002;
    // din = 16'hbeef;
    // #20;
    // mem_wstrb = 0;
    // #20;
    // mem_wstrb = 2'b10;
    // addr = 16'h0004;
    // din = 16'hcafe;
    // #20;
    // mem_wstrb = 0;
    // #20;
    // mem_wstrb = 2'b10;
    // addr = 16'h0006;
    // din = 16'hbabe;
    // #20;
    // mem_wstrb = 0;
    // #20;

    // for (i = 0; i < 8; i = i + 1) begin
    //   addr = i;
    //   #20;
    //   $display("Read data from address %h: %h", addr, dout);
    // end

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

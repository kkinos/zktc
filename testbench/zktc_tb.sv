`default_nettype none

module tb_zktc;
  parameter TB_MEM_SIZE = 16'h5000;
  logic clk;
  logic rst;
  logic trap;
  logic [1:0] mem_wstrb;
  logic [15:0] mem_addr;
  logic [15:0] mem_rdata;
  logic [15:0] mem_wdata;
  logic mem_ready;
  logic mem_vaild;

  initial begin
    trap = 0;
    mem_wstrb = 2'b00;
  end


  zktc zktc (
      .clk(clk),
      .rst(rst),
      .trap(),
      .mem_ready(mem_ready),
      .mem_rdata(mem_rdata),
      .mem_valid(mem_vaild),
      .mem_addr(mem_addr)
  );

  mem #(
      .MEM_SIZE(TB_MEM_SIZE)
  ) mem (
      .clk  (clk),
      .rst  (rst),
      .wstrb(mem_wstrb),
      .vaild(mem_vaild),
      .addr (mem_addr),
      .din  (mem_wdata),

      .dout (mem_rdata),
      .ready(mem_ready)
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
    #100;

    $finish;
  end



  initial begin
    $dumpfile("tb_zktc.vcd");
    $dumpvars(0, tb_zktc);
  end


endmodule

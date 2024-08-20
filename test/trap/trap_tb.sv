module trap_tb;
  logic clk;
  logic rst;
  logic trap;
  logic [1:0] mem_wstrb;
  logic [15:0] mem_addr;
  logic [15:0] mem_rdata;
  logic [15:0] mem_wdata;
  logic mem_ready;
  logic mem_valid;

  initial begin
    trap = 0;
  end


  core core (
      .clk(clk),
      .rst(rst),
      .trap(trap),
      .mem_ready(mem_ready),
      .mem_rdata(mem_rdata),
      .mem_valid(mem_valid),
      .mem_wstrb(mem_wstrb),
      .mem_wdata(mem_wdata),
      .mem_addr(mem_addr)
  );

  // trap inst
  assign mem_rdata = 16'hFFFF;


  always_ff @(posedge clk) begin
    if (rst || mem_ready) begin
      mem_ready <= 0;
    end else if (mem_valid) begin
      mem_ready <= 1;
    end
  end

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    #10;
    rst = 1;
    #10;
    rst = 0;
  end

  always @(negedge clk) begin
    if (mem_addr == 16'h0000 && core.c_registers.psr == 16'b0000000000000101 && core.c_registers.ppc == 16'hB002 && core.c_registers. ppsr == 16'h0000) begin
      $display("\x1b[32m");
      $display("=== trap test passed ===");
      $display("\x1b[0m");
      $finish;
    end
  end

  initial begin
    #1000;
    $display("\x1b[31m");
    $display("=== trap test failed ===");
    $display("\x1b[0m");
    $finish;
  end


  initial begin
    $dumpfile("trap_tb.vcd");
    $dumpvars(0, trap_tb);
  end



endmodule

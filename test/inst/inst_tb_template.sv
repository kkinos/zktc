module inst_tb;
  parameter TB_MEM_SIZE = 16'h5000;
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

  // ram
  logic [15:0] ram_addr;
  logic [7:0] ram1[(16'h5000/2)-1:0];
  logic [7:0] ram2[(16'h5000/2)-1:0];

  logic [15:0] raddr1;
  logic [15:0] raddr2;
  logic [7:0] wdata1;
  logic [7:0] wdata2;
  logic [7:0] rdata1;
  logic [7:0] rdata2;
  logic we1;
  logic we2;
  logic is_even;


  assign ram_addr = mem_addr - 16'hB000;
  assign is_even = ~ram_addr[0];
  assign wdata1 = is_even ? mem_wdata[7:0] : mem_wdata[15:8];
  assign wdata2 = is_even ? mem_wdata[15:8] : mem_wdata[7:0];
  assign raddr1 = is_even ? (ram_addr >> 1) : ((ram_addr + 1) >> 1);
  assign raddr2 = is_even ? (ram_addr + 1) >> 1 : ram_addr >> 1;
  assign we1 = mem_ready && ((mem_wstrb[1] == 1) || ((mem_wstrb[0] == 1) && (is_even == 1)));
  assign we2 = mem_ready && ((mem_wstrb[1] == 1) || ((mem_wstrb[0] == 1) && (is_even != 1)));
  assign mem_rdata = is_even ? {rdata2, rdata1} : {rdata1, rdata2};


  always_ff @(posedge clk) begin
    if (rst || mem_ready) begin
      mem_ready <= 0;
    end else if (mem_valid) begin
      mem_ready <= 1;
    end
  end

  always_ff @(posedge clk) begin
    if (we1) begin
      ram1[raddr1] <= wdata1;
    end
    rdata1 <= ram1[raddr1];
  end

  always_ff @(posedge clk) begin
    if (we2) begin
      ram2[raddr2] <= wdata2;
    end
    rdata2 <= ram2[raddr2];
  end

  initial begin
    $readmemh("inst_ram1.mem", ram1);
    $readmemh("inst_ram2.mem", ram2);
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
    if (mem_wstrb) begin
      if (mem_addr == 16'hfffe && mem_wdata == 16'h0001) begin
        $display("\x1b[32m");
        $display("=== inst test passed ===");
        $display("\x1b[0m");
        $finish;
      end else if (mem_addr == 16'hfffe && mem_wdata != 16'h0001) begin
        $display("\x1b[31m");
        $display("=== inst test failed ===");
        $display("\x1b[0m");
        $finish;
      end
    end
  end

  initial begin
    $dumpfile("inst_tb.vcd");
    $dumpvars(0, inst_tb);
  end



endmodule

module boot #(
    parameter MEM_SIZE = 16'h5000
) (
    input logic clk,
    input logic rst,

    input logic [1:0] wstrb,
    input logic valid,
    input logic [15:0] addr,
    input logic [15:0] wdata,

    output logic [15:0] rdata,
    output logic ready

);
  logic [7:0] ram1[(MEM_SIZE/2)-1:0];
  logic [7:0] ram2[(MEM_SIZE/2)-1:0];

  logic [15:0] raddr1;
  logic [15:0] raddr2;
  logic [7:0] wdata1;
  logic [7:0] wdata2;
  logic [7:0] rdata1;
  logic [7:0] rdata2;
  logic we1;
  logic we2;
  logic is_even;

  assign is_even = ~addr[0];
  assign wdata1 = is_even ? wdata[7:0] : wdata[15:8];
  assign wdata2 = is_even ? wdata[15:8] : wdata[7:0];
  assign raddr1 = is_even ? (addr >> 1) : ((addr + 1) >> 1);
  assign raddr2 = is_even ? (addr + 1) >> 1 : addr >> 1;
  assign we1 = ready && ((wstrb[1] == 1) || ((wstrb[0] == 1) && (is_even == 1)));
  assign we2 = ready && ((wstrb[1] == 1) || ((wstrb[0] == 1) && (is_even != 1)));
  assign rdata = is_even ? {rdata2, rdata1} : {rdata1, rdata2};


  always_ff @(posedge clk) begin
    if (rst || ready) begin
      ready <= 0;
    end else if (valid) begin
      ready <= 1;
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
    $readmemh("boot1.mem", ram1);
    $readmemh("boot2.mem", ram2);
  end


endmodule

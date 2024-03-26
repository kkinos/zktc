module mem #(
    parameter MEM_SIZE = 16'h5000
) (
    input clk,
    we,
    input [15:0] addr,
    input [15:0] din,
    output logic [15:0] dout
);
  logic [7:0] ram1[(MEM_SIZE/2)-1:0];
  logic [7:0] ram2[(MEM_SIZE/2)-1:0];

  logic [15:0] raddr1;
  logic [15:0] raddr2;
  logic [7:0] din1;
  logic [7:0] din2;
  logic [7:0] dout1;
  logic [7:0] dout2;
  logic is_even;

  assign is_even = ~addr[0];
  assign din1 = is_even ? din[7:0] : din[15:8];
  assign din2 = is_even ? din[15:8] : din[7:0];
  assign dout = is_even ? {dout2, dout1} : {dout1, dout2};
  assign raddr1 = is_even ? (addr >> 1) : ((addr + 1) >> 1);
  assign raddr2 = is_even ? (addr + 1) >> 1 : addr >> 1;

  always_ff @(posedge clk) begin
    if (we) begin
      ram1[raddr1] <= din1;
    end
    dout1 <= ram1[raddr1];
  end


  always_ff @(posedge clk) begin
    if (we) begin
      ram2[raddr2] <= din2;
    end
    dout2 <= ram2[raddr2];
  end

endmodule

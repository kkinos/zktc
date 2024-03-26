module registers (
    input logic clk,
    input logic rst,

    input  logic [ 2:0] raddr1,
    input  logic [ 2:0] raddr2,
    output logic [15:0] rdata1,
    output logic [15:0] rdata2,

    input logic wen,
    input logic [2:0] waddr,
    input logic [15:0] wdata
);

  logic [15:0] reg1, reg2, reg3, reg4, reg5, reg6, reg7;

  always_ff @(posedge clk) begin
    if (rst) begin
      reg1 <= 16'h0000;
      reg2 <= 16'h0000;
      reg3 <= 16'h0000;
      reg4 <= 16'h0000;
      reg5 <= 16'h0000;
      reg6 <= 16'h0000;
      reg7 <= 16'h0000;
    end else begin
      if (wen) begin
        if (waddr == 3'b001) reg1 <= wdata;
        if (waddr == 3'b010) reg2 <= wdata;
        if (waddr == 3'b011) reg3 <= wdata;
        if (waddr == 3'b100) reg4 <= wdata;
        if (waddr == 3'b101) reg5 <= wdata;
        if (waddr == 3'b110) reg6 <= wdata;
        if (waddr == 3'b111) reg7 <= wdata;
      end
    end
  end

  assign rdata1 = (raddr1 == 3'b000) ? 16'h0000 :
				  (raddr1 == 3'b001) ? reg1 :
				  (raddr1 == 3'b010) ? reg2 :
				  (raddr1 == 3'b011) ? reg3 :
				  (raddr1 == 3'b100) ? reg4 :
				  (raddr1 == 3'b101) ? reg5 :
				  (raddr1 == 3'b110) ? reg6 :
				  (raddr1 == 3'b111) ? reg7 : 16'h0000;

  assign rdata2 = (raddr2 == 3'b000) ? 16'h0000 :
				  (raddr2 == 3'b001) ? reg1 :
				  (raddr2 == 3'b010) ? reg2 :
				  (raddr2 == 3'b011) ? reg3 :
				  (raddr2 == 3'b100) ? reg4 :
				  (raddr2 == 3'b101) ? reg5 :
				  (raddr2 == 3'b110) ? reg6 :
				  (raddr2 == 3'b111) ? reg7 : 16'h0000;

endmodule

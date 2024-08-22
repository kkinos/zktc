module c_registers (
    input logic clk,
    input logic rst,
    input logic ill_inst,
    input logic trap,
    input logic ir,
    input logic rfi,

    input  logic [ 2:0] raddr,
    output logic [15:0] rdata,
    output logic [15:0] pc_out,
    output logic [15:0] psr_out,

    input logic wen,
    input logic [2:0] waddr,
    input logic [15:0] wdata,

    input logic pc_wen,
    input logic [15:0] next_pc,

    input logic tr_wen,
    input logic tr_ren
);

  logic [15:0] pc, sp, psr, tlr, thr, ppc, ppsr;
  logic [31:0] tr;

  localparam PC_INIT = 16'hB000;
  localparam PC_EXC = 16'h0000;

  assign rdata = (raddr == 3'b000 || raddr == 3'b111) ? 16'h0000 :
                 (raddr == 3'b001) ? sp :
                 (raddr == 3'b010) ? psr :
                 (raddr == 3'b011) ? tlr :
                 (raddr == 3'b100) ? thr :
                 (raddr == 3'b101) ? ppc :
                 (raddr == 3'b110) ? ppsr : 16'h0000;

  assign pc_out = pc;
  assign psr_out = psr;

  // PC
  always_ff @(posedge clk) begin
    if (rst) begin
      pc <= PC_INIT;
    end else if (ill_inst || trap || ir) begin
      pc <= PC_EXC;
    end else if (rfi) begin
      pc <= ppc;
    end else if (pc_wen) begin
      pc <= next_pc;
    end
  end

  // SP
  always_ff @(posedge clk) begin
    if (rst) begin
      sp <= 16'h0000;
    end else if (wen && waddr == 3'b001) begin
      sp <= wdata;
    end
  end

  // PSR
  always_ff @(posedge clk) begin
    if (rst) begin
      psr <= 16'h0000;
    end else if (ill_inst) begin
      psr[3:0]  <= 4'b0011;
      psr[15:4] <= 12'b000000000000;
    end else if (trap) begin
      psr[3:0]  <= 4'b0101;
      psr[15:4] <= 12'b000000000000;
    end else if (ir) begin
      psr[3:0]  <= 4'b1001;
      psr[15:4] <= 12'b000000000000;
    end else if (rfi) begin
      psr <= ppsr;
    end else if (wen && waddr == 3'b010) begin
      psr <= wdata;
    end
  end

  // TR
  always_ff @(posedge clk) begin
    if (rst) begin
      tr <= 32'h00000000;
    end else if (tr_wen) begin
      tr <= {thr, tlr};
    end else begin
      tr <= tr + 1;
    end
  end

  // TLR
  always_ff @(posedge clk) begin
    if (rst) begin
      tlr <= 16'h0000;
    end else if (wen && waddr == 3'b011) begin
      tlr <= wdata;
    end else if (tr_ren) begin
      tlr <= tr[15:0];
    end
  end

  // THR
  always_ff @(posedge clk) begin
    if (rst) begin
      thr <= 16'h0000;
    end else if (wen && waddr == 3'b100) begin
      thr <= wdata;
    end else if (tr_ren) begin
      thr <= tr[31:16];
    end
  end

  // PPC
  always_ff @(posedge clk) begin
    if (rst) begin
      ppc <= 16'h0000;
    end else if (ill_inst || trap) begin
      ppc <= pc + 2;
    end else if (ir) begin
      ppc <= pc;
    end else if (wen && waddr == 3'b101) begin
      ppc <= wdata;
    end
  end

  // PPSR
  always_ff @(posedge clk) begin
    if (rst) begin
      ppsr <= 16'h0000;
    end else if (ill_inst || trap || ir) begin
      ppsr <= psr;
    end else if (wen && waddr == 3'b110) begin
      ppsr <= wdata;
    end
  end


endmodule

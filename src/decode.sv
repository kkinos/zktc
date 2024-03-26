`include "include/def.sv"

module decode (
    input logic en,

    input logic [15:0] inst,

    output logic [ 5:0] d_inst,
    output logic [ 2:0] rs_addr,
    output logic [ 2:0] rd_addr,
    output logic [15:0] imm,
    output logic [ 2:0] cr_addr,
    output logic [ 2:0] cr_waddr,

    output logic trap,
    output logic ill_inst
);

  logic [4:0] opcode;
  logic [4:0] func;
  logic i5_addi_subi_type;
  logic i5_type;
  logic i8_type;
  logic i8_lil_type;
  logic i8_lih_type;
  logic [4:0] imm5;
  logic [7:0] imm8;
  logic [15:0] sext_imm5;
  logic [15:0] zext_imm5;
  logic [15:0] sext_imm8;
  logic [15:0] lil_imm;
  logic [15:0] lih_imm;

  assign opcode = inst[4:0];
  assign func = inst[15:11];
  assign i5_addi_subi_type = (opcode == `OP_ADDI) || (opcode == `OP_SUBI);
  assign i5_type = (opcode == `OP_BEQ) || (opcode == `OP_BNQ)|| (opcode == `OP_BLT) || (opcode == `OP_BGE) || (opcode == `OP_BLTU) ||  (opcode == `OP_BGEU)|| (opcode == `OP_JALR) || (opcode == `OP_LH) || (opcode == `OP_LHU) || (opcode == `OP_LW) || (opcode == `OP_SH)|| (opcode == `OP_SW);
  assign i8_type = (opcode == `OP_JAL);
  assign i8_lil_type = (opcode == `OP_LIL);
  assign i8_lih_type = (opcode == `OP_LIH);
  assign rs_addr = inst[10:8];
  assign rd_addr = inst[7:5];
  assign imm5 = inst[15:11];
  assign imm8 = inst[15:8];
  assign sext_imm5 = {{11{imm5[4]}}, imm5};
  assign zext_imm5 = {{11'b0}, imm5};
  assign sext_imm8 = {{8{imm8[7]}}, imm8};
  assign lil_imm = {8'b0, imm8};
  assign lih_imm = {imm8, 8'b0};

  assign imm = (en && i5_addi_subi_type) ? zext_imm5 : (en && i5_type) ? sext_imm5 : (en && i8_type) ? sext_imm8 : (en && i8_lil_type) ? lil_imm : (en && i8_lih_type) ? lih_imm: 16'h0000;

  always_comb begin
    if (en) begin
      if ((opcode == `OP_R) && (func == `FUNC_MOV)) d_inst = `INST_MOV;
      else if ((opcode == `OP_R) && (func == `FUNC_ADD)) d_inst = `INST_ADD;
      else if ((opcode == `OP_R) && (func == `FUNC_SUB)) d_inst = `INST_SUB;
      else if ((opcode == `OP_R) && (func == `FUNC_AND)) d_inst = `INST_AND;
      else if ((opcode == `OP_R) && (func == `FUNC_OR)) d_inst = `INST_OR;
      else if ((opcode == `OP_R) && (func == `FUNC_XOR)) d_inst = `INST_XOR;
      else if ((opcode == `OP_R) && (func == `FUNC_SLL)) d_inst = `INST_SLL;
      else if ((opcode == `OP_R) && (func == `FUNC_SRL)) d_inst = `INST_SRL;
      else if ((opcode == `OP_R) && (func == `FUNC_SRA)) d_inst = `INST_SRA;
      else if ((opcode == `OP_ADDI)) d_inst = `INST_ADDI;
      else if ((opcode == `OP_SUBI)) d_inst = `INST_SUBI;
      else if ((opcode == `OP_BEQ)) d_inst = `INST_BEQ;
      else if ((opcode == `OP_BNQ)) d_inst = `INST_BNQ;
      else if ((opcode == `OP_BLT)) d_inst = `INST_BLT;
      else if ((opcode == `OP_BGE)) d_inst = `INST_BGE;
      else if ((opcode == `OP_BLTU)) d_inst = `INST_BLTU;
      else if ((opcode == `OP_BGEU)) d_inst = `INST_BGEU;
      else if ((opcode == `OP_JALR)) d_inst = `INST_JALR;
      else if ((opcode == `OP_LH)) d_inst = `INST_LH;
      else if ((opcode == `OP_LHU)) d_inst = `INST_LHU;
      else if ((opcode == `OP_LW)) d_inst = `INST_LW;
      else if ((opcode == `OP_SH)) d_inst = `INST_SH;
      else if ((opcode == `OP_SW)) d_inst = `INST_SW;
      else if ((opcode == `OP_JAL)) d_inst = `INST_JAL;
      else if ((opcode == `OP_LIL)) d_inst = `INST_LIL;
      else if ((opcode == `OP_LIH)) d_inst = `INST_LIH;
      else if ((opcode == `OP_C1) && (func == `FUNC_PUSH)) d_inst = `INST_PUSH;
      else if ((opcode == `OP_C1) && (func == `FUNC_POP)) d_inst = `INST_POP;
      else if ((opcode == `OP_C1) && (func == `FUNC_RPC)) d_inst = `INST_RPC;
      else if ((opcode == `OP_C1) && (func == `FUNC_RSP)) d_inst = `INST_RSP;
      else if ((opcode == `OP_C1) && (func == `FUNC_RPSR)) d_inst = `INST_RPSR;
      else if ((opcode == `OP_C1) && (func == `FUNC_RTLR)) d_inst = `INST_RTLR;
      else if ((opcode == `OP_C1) && (func == `FUNC_RTHR)) d_inst = `INST_RTHR;
      else if ((opcode == `OP_C1) && (func == `FUNC_RPPC)) d_inst = `INST_RPPC;
      else if ((opcode == `OP_C1) && (func == `FUNC_RPPSR)) d_inst = `INST_RPPSR;
      else if ((opcode == `OP_C1) && (func == `FUNC_WSP)) d_inst = `INST_WSP;
      else if ((opcode == `OP_C1) && (func == `FUNC_WPSR)) d_inst = `INST_WPSR;
      else if ((opcode == `OP_C1) && (func == `FUNC_WTLR)) d_inst = `INST_WTLR;
      else if ((opcode == `OP_C1) && (func == `FUNC_WTHR)) d_inst = `INST_WTHR;
      else if ((opcode == `OP_C1) && (func == `FUNC_WPPC)) d_inst = `INST_WPPC;
      else if ((opcode == `OP_C1) && (func == `FUNC_WPPSR)) d_inst = `INST_WPPSR;
      else if ((opcode == `OP_C2) && (func == `FUNC_RFI)) d_inst = `INST_RFI;
      else if ((opcode == `OP_C2) && (func == `FUNC_RTR)) d_inst = `INST_RTR;
      else if ((opcode == `OP_C2) && (func == `FUNC_WTR)) d_inst = `INST_WTR;
      else d_inst = `INST_NOP;
    end else begin
      d_inst = `INST_NOP;
    end
  end

  always_comb begin
    if (en) begin
      if (inst == 16'hFFFF) begin
        trap = 1'b1;
      end else begin
        trap = 1'b0;
      end
    end else begin
      trap = 1'b0;
    end
  end

  always_comb begin
    if (en) begin
      if ((d_inst == `INST_NOP) && (inst != 16'hFFFF)) begin
        ill_inst = 1'b1;
      end else begin
        ill_inst = 1'b0;
      end
    end else begin
      ill_inst = 1'b0;
    end
  end

  always_comb begin
    if (en) begin
      if (d_inst == `INST_POP || d_inst == `INST_PUSH || d_inst == `INST_RSP) begin
        cr_addr = 3'b001;
      end else if (d_inst == `INST_RPSR) begin
        cr_addr = 3'b010;
      end else if (d_inst == `INST_RTLR) begin
        cr_addr = 3'b011;
      end else if (d_inst == `INST_RTHR) begin
        cr_addr = 3'b100;
      end else if (d_inst == `INST_RPPC) begin
        cr_addr = 3'b101;
      end else if (d_inst == `INST_RPPSR) begin
        cr_addr = 3'b110;
      end else begin
        cr_addr = 3'b000;
      end
    end else begin
      cr_addr = 3'b000;
    end
  end

  always_comb begin
    if (en) begin
      if (d_inst == `INST_POP || d_inst == `INST_PUSH || d_inst == `INST_WSP) begin
        cr_waddr = 3'b001;
      end else if (d_inst == `INST_WPSR) begin
        cr_waddr = 3'b010;
      end else if (d_inst == `INST_WTLR) begin
        cr_waddr = 3'b011;
      end else if (d_inst == `INST_WTHR) begin
        cr_waddr = 3'b100;
      end else if (d_inst == `INST_WPPC) begin
        cr_waddr = 3'b101;
      end else if (d_inst == `INST_WPPSR) begin
        cr_waddr = 3'b110;
      end else begin
        cr_waddr = 3'b000;
      end
    end else begin
      cr_waddr = 3'b000;
    end
  end

endmodule

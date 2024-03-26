`include "include/def.sv"

module execute (
    input logic en,

    input logic [15:0] pc,
    input logic [ 5:0] d_inst,
    input logic [15:0] rs_data,
    input logic [15:0] rd_data,
    input logic [15:0] imm,
    input logic [15:0] cr_data,

    output logic [15:0] res,
    output logic [15:0] crd_data,
    output logic [15:0] next_pc
);

  always_comb begin
    if (en) begin
      case (d_inst)
        `INST_MOV:  res = rs_data;
        `INST_ADD:  res = rd_data + rs_data;
        `INST_SUB:  res = rd_data - rs_data;
        `INST_AND:  res = rd_data & rs_data;
        `INST_OR:   res = rd_data | rs_data;
        `INST_XOR:  res = rd_data ^ rs_data;
        `INST_SLL:  res = rd_data << rs_data;
        `INST_SRL:  res = rd_data >> rs_data;
        `INST_SRA:  res = $signed(rd_data) >>> rs_data;
        `INST_ADDI: res = rs_data + imm;
        `INST_SUBI: res = rs_data - imm;
        `INST_BEQ:  res = rd_data == rs_data ? 1 : 0;
        `INST_BNQ:  res = rd_data != rs_data ? 1 : 0;
        `INST_BLT:  res = $signed(rd_data) < $signed(rs_data) ? 1 : 0;
        `INST_BGE:  res = $signed(rd_data) >= $signed(rs_data) ? 1 : 0;
        `INST_BLTU: res = rd_data < rs_data ? 1 : 0;
        `INST_BGEU: res = rd_data >= rs_data ? 1 : 0;
        `INST_JALR: res = pc + 2;
        `INST_LH:   res = rs_data + imm;
        `INST_LHU:  res = rs_data + imm;
        `INST_LW:   res = rs_data + imm;
        `INST_SH:   res = rs_data + imm;
        `INST_SW:   res = rs_data + imm;
        `INST_JAL:  res = pc + 2;
        `INST_LIL:  res = imm;
        `INST_LIH:  res = imm;

        `INST_RPC:   res = pc + 2;
        `INST_RSP:   res = cr_data;
        `INST_RPSR:  res = cr_data;
        `INST_RTLR:  res = cr_data;
        `INST_RTHR:  res = cr_data;
        `INST_RPPC:  res = cr_data;
        `INST_RPPSR: res = cr_data;
        default: begin
          res = 0;
        end
      endcase
    end else begin
      res = 0;
    end
  end

  always_comb begin
    if (en) begin
      case (d_inst)
        `INST_PUSH:  crd_data = cr_data - 2;
        `INST_POP:   crd_data = cr_data + 2;
        `INST_WSP:   crd_data = rd_data;
        `INST_WPSR:  crd_data = rd_data;
        `INST_WTLR:  crd_data = rd_data;
        `INST_WTHR:  crd_data = rd_data;
        `INST_WPPC:  crd_data = rd_data;
        `INST_WPPSR: crd_data = rd_data;
        default: begin
          crd_data = 0;
        end
      endcase
    end else begin
      crd_data = 0;
    end
  end


  // next pc
  logic [15:0] pc_add_2, pc_add_imm, pc_jalr;
  always_comb begin
    pc_add_2 = pc + 2;
    pc_add_imm = pc + imm;
    pc_jalr = rs_data + imm;
  end

  always_comb begin
    if (en) begin
      if (d_inst == `INST_BEQ && res) begin
        next_pc = pc_add_imm;
      end else if (d_inst == `INST_BNQ && res) begin
        next_pc = pc_add_imm;
      end else if (d_inst == `INST_BLT && res) begin
        next_pc = pc_add_imm;
      end else if (d_inst == `INST_BGE && res) begin
        next_pc = pc_add_imm;
      end else if (d_inst == `INST_BLTU && res) begin
        next_pc = pc_add_imm;
      end else if (d_inst == `INST_BGEU && res) begin
        next_pc = pc_add_imm;
      end else if (d_inst == `INST_JAL) begin
        next_pc = pc_add_imm;
      end else if (d_inst == `INST_JALR) begin
        next_pc = pc_jalr;
      end else begin
        next_pc = pc_add_2;
      end
    end else begin
      next_pc = 0;
    end
  end



endmodule

`include "include/def.sv"

module core (
    input logic clk,
    input logic rst,

    input logic irq,

    input logic mem_ready,
    input logic [15:0] mem_rdata,

    output logic [15:0] mem_addr,
    output logic mem_valid,

    output logic [ 1:0] mem_wstrb,
    output logic [15:0] mem_wdata,

    output logic ack
);

  logic [15:0] pc;
  logic [15:0] next_pc;
  logic [15:0] psr;

  logic [15:0] inst;

  // CPU State
  typedef enum {
    FETCH,
    DECODE,
    EXECUTE,
    MEMORY,
    WRITEBACK,
    EXCEPTION
  } cpu_state_t;
  cpu_state_t cpu_state;

  logic fetch_enable;
  logic decode_enable;
  logic execute_enable;
  logic memory_enable;
  logic writeback_enable;
  logic ill_inst_enable;
  logic trap_enable;
  logic ir_enable;

  always_ff @(posedge clk) begin
    if (rst) begin
      cpu_state <= FETCH;

      fetch_enable <= 1;
      decode_enable <= 0;
      execute_enable <= 0;
      memory_enable <= 0;
      writeback_enable <= 0;
      ill_inst_enable <= 0;
      trap_enable <= 0;
      ir_enable <= 0;

      mem_valid <= 0;
      mem_wstrb <= 0;
      mem_wdata <= 0;
    end else begin
      case (cpu_state)
        FETCH: begin
          if (!psr[0] && irq) begin
            ir_enable <= 1;
            cpu_state <= EXCEPTION;
            ack <= 1;
          end else if (!mem_ready) begin
            pc_de_in  <= pc;
            mem_valid <= 1;
          end else begin
            mem_valid <= 0;
            inst_de_in <= mem_rdata;
            fetch_enable <= 0;
            decode_enable <= 1;
            cpu_state <= DECODE;
          end
        end
        DECODE: begin
          decode_enable <= 0;
          if (!psr[0] && ill_inst_de_out) begin
            ill_inst_enable <= 1;
            cpu_state <= EXCEPTION;
          end else if (!psr[0] && trap_de_out) begin
            trap_enable <= 1;
            cpu_state   <= EXCEPTION;
          end else begin
            execute_enable <= 1;
            cpu_state <= EXECUTE;
          end
        end
        EXECUTE: begin
          execute_enable <= 0;
          memory_enable <= 1;
          cpu_state <= MEMORY;
        end
        MEMORY: begin
          if (memory_enable) begin
            if (d_inst_mem_in == `INST_LW || d_inst_mem_in == `INST_LH || d_inst_mem_in ==
                `INST_LHU
                || d_inst_mem_in == `INST_POP) begin
              if (!mem_ready) begin
                mem_valid <= 1;
              end else begin
                mem_valid <= 0;
                memory_enable <= 0;
                writeback_enable <= 1;
                cpu_state <= WRITEBACK;
                if (d_inst_mem_in == `INST_LW || d_inst_mem_in == `INST_POP) begin
                  mem_rdata_wb_in <= mem_rdata;
                end else if (d_inst_mem_in == `INST_LH) begin
                  mem_rdata_wb_in <= {{8{mem_rdata[7]}}, mem_rdata[7:0]};
                end else if (d_inst_mem_in == `INST_LHU) begin
                  mem_rdata_wb_in <= {8'b0, mem_rdata[7:0]};
                end
              end
            end else if (d_inst_mem_in == `INST_SW || d_inst_mem_in ==
                `INST_SH
                || d_inst_mem_in == `INST_PUSH) begin
              if (!mem_ready) begin
                mem_valid <= 1;
                if (d_inst_mem_in == `INST_SW || d_inst_mem_in == `INST_PUSH) begin
                  mem_wstrb <= 2'b11;
                  mem_wdata <= rd_data_mem_in;
                end else if (d_inst_mem_in == `INST_SH) begin
                  mem_wstrb <= 2'b01;
                  mem_wdata <= {8'b0, rd_data_mem_in[7:0]};
                end
              end else begin
                mem_valid <= 0;
                mem_wstrb <= 0;
                mem_wdata <= 0;
                memory_enable <= 0;
                writeback_enable <= 1;
                cpu_state <= WRITEBACK;
              end
            end else begin
              memory_enable <= 0;
              writeback_enable <= 1;
              cpu_state <= WRITEBACK;
            end
          end
        end
        WRITEBACK: begin
          cpu_state <= FETCH;
          writeback_enable <= 0;
          fetch_enable <= 1;
        end
        EXCEPTION: begin
          ill_inst_enable <= 0;
          trap_enable <= 0;
          ir_enable <= 0;
          ack <= 0;
          fetch_enable <= 1;
          cpu_state <= FETCH;
        end
      endcase
    end
  end


  always_comb begin
    if (memory_enable) begin
      if (d_inst_mem_in == `INST_PUSH) begin
        mem_addr = crd_data_mem_in;
      end else if (d_inst_mem_in == `INST_POP) begin
        mem_addr = cr_data_mem_in;
      end else begin
        mem_addr = res_mem_in;
      end
    end else begin
      mem_addr = pc;
    end
  end


  // decode
  logic [15:0] pc_de_in;
  logic [15:0] inst_de_in;

  logic [15:0] pc_de_out;
  logic [5:0] d_inst_de_out;
  logic [2:0] rs_addr_de_out;
  logic [2:0] rd_addr_de_out;
  logic [15:0] imm_de_out;
  logic [2:0] cr_addr_de_out;
  logic [2:0] cr_waddr_de_out;
  logic trap_de_out;
  logic ill_inst_de_out;

  assign pc_de_out = pc_de_in;

  decode decode (
      .en(decode_enable),

      .inst(inst_de_in),

      .d_inst(d_inst_de_out),
      .rs_addr(rs_addr_de_out),
      .rd_addr(rd_addr_de_out),
      .imm(imm_de_out),
      .cr_addr(cr_addr_de_out),
      .cr_waddr(cr_waddr_de_out),

      .trap(trap_de_out),
      .ill_inst(ill_inst_de_out)
  );

  // general registers
  logic [2:0] rs_addr;
  logic [2:0] rd_addr;
  logic [15:0] rs_data;
  logic [15:0] rd_data;
  logic gr_wen;
  logic [2:0] waddr;
  logic [15:0] wdata;

  assign rs_addr = rs_addr_de_out;
  assign rd_addr = rd_addr_de_out;

  registers registers (
      .clk(clk),
      .rst(rst),

      .raddr1(rs_addr_de_out),
      .raddr2(rd_addr_de_out),
      .rdata1(rs_data),
      .rdata2(rd_data),

      .wen  (gr_wen),
      .waddr(waddr),
      .wdata(wdata)
  );

  // control registers
  logic [15:0] cr_data;
  logic cr_wen;
  logic [2:0] cr_waddr;
  logic [15:0] cr_wdata;
  logic pc_wen;
  logic rfi;
  logic tr_wen;
  logic tr_ren;


  c_registers c_registers (
      .clk(clk),
      .rst(rst),
      .ill_inst(ill_inst_enable),
      .trap(trap_enable),
      .ir(ir_enable),
      .rfi(rfi),

      .raddr  (cr_addr_de_out),
      .rdata  (cr_data),
      .pc_out (pc),
      .psr_out(psr),

      .wen  (cr_wen),
      .waddr(cr_waddr),
      .wdata(cr_wdata),

      .pc_wen (pc_wen),
      .next_pc(next_pc),

      .tr_wen(tr_wen),
      .tr_ren(tr_ren)
  );

  // execute
  logic [15:0] pc_ex_in;
  logic [ 5:0] d_inst_ex_in;
  logic [15:0] rs_data_ex_in;
  logic [15:0] rd_data_ex_in;
  logic [15:0] imm_ex_in;
  logic [15:0] cr_data_ex_in;
  logic [15:0] rd_addr_ex_in;
  logic [ 2:0] cr_waddr_ex_in;

  logic [15:0] pc_ex_out;
  logic [ 5:0] d_inst_ex_out;
  logic [15:0] rd_data_ex_out;
  logic [15:0] cr_data_ex_out;
  logic [ 2:0] rd_addr_ex_out;
  logic [ 2:0] cr_waddr_ex_out;
  logic [15:0] crd_data_ex_out;
  logic [15:0] res_ex_out;
  logic [15:0] next_pc_ex_out;

  assign pc_ex_out = pc_ex_in;
  assign d_inst_ex_out = d_inst_ex_in;
  assign rd_data_ex_out = rd_data_ex_in;
  assign cr_data_ex_out = cr_data_ex_in;
  assign rd_addr_ex_out = rd_addr_ex_in;
  assign cr_waddr_ex_out = cr_waddr_ex_in;

  execute execute (
      .en(execute_enable),

      .pc(pc_ex_in),
      .d_inst(d_inst_ex_in),
      .rs_data(rs_data_ex_in),
      .rd_data(rd_data_ex_in),
      .imm(imm_ex_in),
      .cr_data(cr_data_ex_in),

      .res(res_ex_out),
      .crd_data(crd_data_ex_out),
      .next_pc(next_pc_ex_out)
  );

  // memory
  logic [ 5:0] d_inst_mem_in;
  logic [15:0] rd_data_mem_in;
  logic [15:0] cr_data_mem_in;
  logic [15:0] rd_addr_mem_in;
  logic [ 2:0] cr_waddr_mem_in;
  logic [15:0] res_mem_in;
  logic [15:0] crd_data_mem_in;
  logic [15:0] next_pc_mem_in;

  logic [ 5:0] d_inst_mem_out;
  logic [ 2:0] rd_addr_mem_out;
  logic [ 2:0] cr_waddr_mem_out;
  logic [15:0] res_mem_out;
  logic [15:0] crd_data_mem_out;
  logic [15:0] next_pc_mem_out;

  assign d_inst_mem_out = d_inst_mem_in;
  assign rd_addr_mem_out = rd_addr_mem_in;
  assign cr_waddr_mem_out = cr_waddr_mem_in;
  assign crd_data_mem_out = crd_data_mem_in;
  assign res_mem_out = res_mem_in;
  assign next_pc_mem_out = next_pc_mem_in;

  // writeback
  logic [ 5:0] d_inst_wb_in;

  logic [ 2:0] rd_addr_wb_in;
  logic [15:0] mem_rdata_wb_in;

  logic [ 2:0] cr_waddr_wb_in;
  logic [15:0] crd_data_wb_in;

  logic [15:0] res_wb_in;
  logic [15:0] next_pc_wb_in;

  assign next_pc = next_pc_wb_in;
  assign waddr = rd_addr_wb_in;
  assign cr_waddr = cr_waddr_wb_in;
  assign cr_wdata = crd_data_wb_in;


  always_comb begin
    if (d_inst_wb_in == `INST_LW || d_inst_wb_in == `INST_LH || d_inst_wb_in ==
        `INST_LHU
        || d_inst_wb_in == `INST_POP) begin
      wdata = mem_rdata_wb_in;
    end else begin
      wdata = res_wb_in;
    end
  end

  always_comb begin
    if (writeback_enable) begin
      if (d_inst_wb_in == `INST_RFI) begin
        pc_wen = 0;
      end else begin
        pc_wen = 1;
      end
      if (d_inst_wb_in == `INST_MOV || d_inst_wb_in == `INST_ADD || d_inst_wb_in ==
          `INST_SUB
          || d_inst_wb_in == `INST_AND || d_inst_wb_in == `INST_OR || d_inst_wb_in ==
          `INST_XOR
          || d_inst_wb_in == `INST_SLL || d_inst_wb_in == `INST_SRL || d_inst_wb_in ==
          `INST_SRA
          || d_inst_wb_in == `INST_ADDI || d_inst_wb_in == `INST_SUBI || d_inst_wb_in ==
          `INST_JALR
          || d_inst_wb_in == `INST_LH || d_inst_wb_in == `INST_LHU || d_inst_wb_in ==
          `INST_LW
          || d_inst_wb_in == `INST_JAL || d_inst_wb_in == `INST_LIL || d_inst_wb_in ==
          `INST_LIH
          || d_inst_wb_in == `INST_POP || d_inst_wb_in == `INST_RPC || d_inst_wb_in ==
          `INST_RSP
          || d_inst_wb_in == `INST_RPSR || d_inst_wb_in == `INST_RTLR || d_inst_wb_in ==
          `INST_RTHR
          || d_inst_wb_in == `INST_RPPC || d_inst_wb_in == `INST_RPPSR) begin
        gr_wen = 1;
      end else begin
        gr_wen = 0;
      end
    end else begin
      pc_wen = 0;
      gr_wen = 0;
    end
  end

  always_comb begin
    if (writeback_enable) begin
      if (d_inst_wb_in == `INST_PUSH || d_inst_wb_in == `INST_POP || d_inst_wb_in ==
          `INST_WSP
          || d_inst_wb_in == `INST_WPSR || d_inst_wb_in == `INST_WTLR || d_inst_wb_in ==
          `INST_WTHR
          || d_inst_wb_in == `INST_WPPC || d_inst_wb_in == `INST_WPPSR) begin
        cr_wen = 1;
      end else begin
        cr_wen = 0;
      end
    end else begin
      cr_wen = 0;
    end
  end

  always_comb begin
    if (writeback_enable) begin
      if (d_inst_wb_in == `INST_RFI) begin
        rfi = 1;
      end else begin
        rfi = 0;
      end
    end else begin
      rfi = 0;
    end
  end

  always_comb begin
    if (writeback_enable) begin
      if (d_inst_wb_in == `INST_WTR) begin
        tr_wen = 1;
      end else begin
        tr_wen = 0;
      end
    end else begin
      tr_wen = 0;
    end
  end

  always_comb begin
    if (writeback_enable) begin
      if (d_inst_wb_in == `INST_RTR) begin
        tr_ren = 1;
      end else begin
        tr_ren = 0;
      end
    end else begin
      tr_ren = 0;
    end
  end


  // pipeline
  always_ff @(posedge clk) begin
    if (decode_enable) begin
      pc_ex_in <= pc_de_out;
      d_inst_ex_in <= d_inst_de_out;
      rs_data_ex_in <= rs_data;
      rd_data_ex_in <= rd_data;
      imm_ex_in <= imm_de_out;
      rd_addr_ex_in <= rd_addr_de_out;
      cr_data_ex_in <= cr_data;
      cr_waddr_ex_in <= cr_waddr_de_out;
    end else if (execute_enable) begin
      d_inst_mem_in <= d_inst_ex_out;
      rd_data_mem_in <= rd_data_ex_out;
      cr_data_mem_in <= cr_data_ex_out;
      rd_addr_mem_in <= rd_addr_ex_out;
      cr_waddr_mem_in <= cr_waddr_ex_out;
      crd_data_mem_in <= crd_data_ex_out;
      res_mem_in <= res_ex_out;
      next_pc_mem_in <= next_pc_ex_out;
    end else if (memory_enable) begin
      d_inst_wb_in <= d_inst_mem_out;
      rd_addr_wb_in <= rd_addr_mem_out;
      cr_waddr_wb_in <= cr_waddr_mem_out;
      crd_data_wb_in <= crd_data_mem_out;
      res_wb_in <= res_mem_out;
      next_pc_wb_in <= next_pc_mem_out;
    end
  end

endmodule

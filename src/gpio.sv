module gpio (
    input logic clk,
    input logic rst,

    input logic gpio_valid,
    input logic gpio_wstrb,
    input logic [7:0] gpio_addr,
    input logic [15:0] gpio_wdata,

    input logic io0_in,
    input logic io1_in,
    input logic io2_in,
    input logic io3_in,
    input logic io4_in,
    input logic io5_in,
    input logic io6_in,
    input logic io7_in,

    output logic gpio_ready,
    output logic [15:0] gpio_rdata,

    output logic io0_oen,
    output logic io1_oen,
    output logic io2_oen,
    output logic io3_oen,
    output logic io4_oen,
    output logic io5_oen,
    output logic io6_oen,
    output logic io7_oen,

    output logic io0_out,
    output logic io1_out,
    output logic io2_out,
    output logic io3_out,
    output logic io4_out,
    output logic io5_out,
    output logic io6_out,
    output logic io7_out
);

  logic io0_ien;
  logic io1_ien;
  logic io2_ien;
  logic io3_ien;
  logic io4_ien;
  logic io5_ien;
  logic io6_ien;
  logic io7_ien;

  logic [7:0] gpio_out_reg;
  logic [7:0] gpio_in_reg;
  logic [7:0] gpio_dir_reg;

  always_ff @(posedge clk) begin
    if (rst || gpio_ready) begin
      gpio_ready <= 0;
    end else if (gpio_valid) begin
      gpio_ready <= 1;
    end
  end

  always_ff @(posedge clk) begin
    if (rst) begin
      gpio_in_reg <= 8'b0;
    end else begin
      gpio_in_reg[0] <= io0_ien ? io0_in : 0;
      gpio_in_reg[1] <= io1_ien ? io1_in : 0;
      gpio_in_reg[2] <= io2_ien ? io2_in : 0;
      gpio_in_reg[3] <= io3_ien ? io3_in : 0;
      gpio_in_reg[4] <= io4_ien ? io4_in : 0;
      gpio_in_reg[5] <= io5_ien ? io5_in : 0;
      gpio_in_reg[6] <= io6_ien ? io6_in : 0;
      gpio_in_reg[7] <= io7_ien ? io7_in : 0;
    end
  end

  always_comb begin
    case (gpio_addr)
      8'h02:   gpio_rdata = {8'b0, gpio_in_reg};
      default: gpio_rdata = 16'h0;
    endcase
  end

  always_ff @(posedge clk) begin
    if (rst) begin
      gpio_out_reg <= 8'b0;
      gpio_dir_reg <= 8'b0;
    end else if (gpio_wstrb) begin
      case (gpio_addr)
        8'h00:   gpio_out_reg <= gpio_wdata[7:0];
        8'h04:   gpio_dir_reg <= gpio_wdata[7:0];
        default: ;
      endcase
    end
  end

  assign io0_ien = gpio_dir_reg[0];
  assign io1_ien = gpio_dir_reg[1];
  assign io2_ien = gpio_dir_reg[2];
  assign io3_ien = gpio_dir_reg[3];
  assign io4_ien = gpio_dir_reg[4];
  assign io5_ien = gpio_dir_reg[5];
  assign io6_ien = gpio_dir_reg[6];
  assign io7_ien = gpio_dir_reg[7];

  assign io0_out = gpio_out_reg[0];
  assign io1_out = gpio_out_reg[1];
  assign io2_out = gpio_out_reg[2];
  assign io3_out = gpio_out_reg[3];
  assign io4_out = gpio_out_reg[4];
  assign io5_out = gpio_out_reg[5];
  assign io6_out = gpio_out_reg[6];
  assign io7_out = gpio_out_reg[7];

  assign io0_oen = ~gpio_dir_reg[0];
  assign io1_oen = ~gpio_dir_reg[1];
  assign io2_oen = ~gpio_dir_reg[2];
  assign io3_oen = ~gpio_dir_reg[3];
  assign io4_oen = ~gpio_dir_reg[4];
  assign io5_oen = ~gpio_dir_reg[5];
  assign io6_oen = ~gpio_dir_reg[6];
  assign io7_oen = ~gpio_dir_reg[7];

endmodule

module zktc_artys7 (
    input logic clk,
    input logic rstn,

    input logic rxd,

    output logic [3:0] led,
    output logic txd,

    inout io0,
    inout io1,
    inout io2,
    inout io3,
    inout io4,
    inout io5,
    inout io6,
    inout io7
);

  logic rst;
  assign rst = ~rstn;

  logic trap;

  // Memory Interface
  logic mem_ready;
  logic mem_valid;
  logic [1:0] mem_wstrb;
  logic [15:0] mem_addr;
  logic [15:0] mem_rdata;
  logic [15:0] mem_wdata;

  // BOOT
  logic boot_sel;
  logic boot_ready;
  logic boot_valid;
  logic [1:0] boot_wstrb;
  logic [15:0] boot_addr;
  logic [15:0] boot_rdata;
  logic [15:0] boot_wdata;

  // RAM
  logic ram_sel;
  logic ram_ready;
  logic ram_valid;
  logic [1:0] ram_wstrb;
  logic [15:0] ram_addr;
  logic [15:0] ram_rdata;
  logic [15:0] ram_wdata;

  // LED
  logic led_sel;
  logic led_ready;
  logic led_valid;
  logic led_wstrb;
  logic [3:0] led_data;

  // UART
  logic uart_sel;
  logic uart_ready;
  logic uart_valid;
  logic uart_wstrb;
  logic [7:0] uart_addr;
  logic [15:0] uart_rdata;
  logic [15:0] uart_wdata;

  logic uart_rx_irq;

  // GPIO
  logic gpio_sel;
  logic gpio_ready;
  logic gpio_valid;
  logic gpio_wstrb;
  logic [7:0] gpio_addr;
  logic [15:0] gpio_rdata;
  logic [15:0] gpio_wdata;

  logic io0_oen;
  logic io1_oen;
  logic io2_oen;
  logic io3_oen;
  logic io4_oen;
  logic io5_oen;
  logic io6_oen;
  logic io7_oen;

  logic io0_out;
  logic io1_out;
  logic io2_out;
  logic io3_out;
  logic io4_out;
  logic io5_out;
  logic io6_out;
  logic io7_out;

  logic io0_in;
  logic io1_in;
  logic io2_in;
  logic io3_in;
  logic io4_in;
  logic io5_in;
  logic io6_in;
  logic io7_in;

  assign io0 = io0_oen ? io0_out : 1'bz;
  assign io1 = io1_oen ? io1_out : 1'bz;
  assign io2 = io2_oen ? io2_out : 1'bz;
  assign io3 = io3_oen ? io3_out : 1'bz;
  assign io4 = io4_oen ? io4_out : 1'bz;
  assign io5 = io5_oen ? io5_out : 1'bz;
  assign io6 = io6_oen ? io6_out : 1'bz;
  assign io7 = io7_oen ? io7_out : 1'bz;

  assign io0_in = io0;
  assign io1_in = io1;
  assign io2_in = io2;
  assign io3_in = io3;
  assign io4_in = io4;
  assign io5_in = io5;
  assign io6_in = io6;
  assign io7_in = io7;

  assign boot_sel = mem_addr >= 16'hB000;
  assign ram_sel = (mem_addr >= 16'h0000) && (mem_addr < 16'h8000);
  assign led_sel = mem_addr == 16'h8000;
  assign uart_sel = (mem_addr >= 16'h8100) && (mem_addr < 16'h8200);
  assign gpio_sel = (mem_addr >= 16'h8200) && (mem_addr < 16'h8300);

  assign boot_valid = boot_sel ? mem_valid : 0;
  assign boot_wstrb = boot_sel ? mem_wstrb : 2'b0;
  assign boot_addr = boot_sel ? mem_addr - 16'hB000 : 16'h0;
  assign boot_wdata = boot_sel ? mem_wdata : 16'h0;

  assign ram_valid = ram_sel ? mem_valid : 0;
  assign ram_wstrb = ram_sel ? mem_wstrb : 2'b0;
  assign ram_addr = ram_sel ? mem_addr : 16'h0;
  assign ram_wdata = ram_sel ? mem_wdata : 16'h0;

  assign led_valid = led_sel ? mem_valid : 0;
  assign led_wstrb = led_sel ? mem_wstrb[0] : 2'b0;
  assign led_data = led_sel ? mem_wdata[3:0] : 4'b0;

  assign uart_valid = uart_sel ? mem_valid : 0;
  assign uart_wstrb = uart_sel ? mem_wstrb[0] : 1'b0;
  assign uart_addr = uart_sel ? mem_addr[7:0] : 8'h0;
  assign uart_wdata = uart_sel ? mem_wdata : 16'h0;

  assign gpio_valid = gpio_sel ? mem_valid : 0;
  assign gpio_wstrb = gpio_sel ? mem_wstrb[0] : 1'b0;
  assign gpio_addr = gpio_sel ? mem_addr[7:0] : 8'h0;
  assign gpio_wdata = gpio_sel ? mem_wdata : 8'h0;

  assign mem_rdata = boot_sel ? boot_rdata : ram_sel ? ram_rdata : uart_sel ? uart_rdata : gpio_sel ? gpio_rdata : 16'h0;
  assign mem_ready = boot_sel ? boot_ready : ram_sel ? ram_ready : led_sel ? led_ready : uart_sel ? uart_ready : gpio_sel ? gpio_ready : 1'b1;

  core core (
      .clk(clk),
      .rst(rst),

      .trap(trap),

      .mem_ready(mem_ready),
      .mem_rdata(mem_rdata),

      .mem_addr (mem_addr),
      .mem_valid(mem_valid),

      .mem_wstrb(mem_wstrb),
      .mem_wdata(mem_wdata)
  );

  boot #(
      .MEM_SIZE(16'h5000)
  ) boot (
      .clk(clk),
      .rst(rst),

      .wstrb(boot_wstrb),
      .valid(boot_valid),
      .addr (boot_addr),
      .rdata(boot_rdata),

      .ready(boot_ready),
      .wdata(boot_wdata)
  );

  ram #(
      .MEM_SIZE(16'h8000)
  ) ram (
      .clk(clk),
      .rst(rst),

      .wstrb(ram_wstrb),
      .valid(ram_valid),
      .addr (ram_addr),
      .rdata(ram_rdata),

      .ready(ram_ready),
      .wdata(ram_wdata)
  );

  always_ff @(posedge clk) begin
    if (rst) begin
      led <= 0;
    end else if (led_ready && led_wstrb) begin
      led <= led_data;
    end
  end

  always_ff @(posedge clk) begin
    if (rst || led_ready) begin
      led_ready <= 0;
    end else if (led_valid) begin
      led_ready <= 1;
    end
  end

  uart #(
      .WAIT_COUNT(868)
  ) uart (
      .clk(clk),
      .rst(rst),

      .uart_valid(uart_valid),
      .uart_wstrb(uart_wstrb),
      .uart_addr (uart_addr),
      .uart_wdata(uart_wdata),

      .rxd(rxd),
      .uart_rx_ack(uart_rx_ack),

      .uart_ready(uart_ready),
      .uart_rdata(uart_rdata),

      .txd(txd),
      .uart_rx_irq(uart_rx_irq)
  );

  gpio gpio (
      .clk(clk),
      .rst(rst),

      .gpio_valid(gpio_valid),
      .gpio_wstrb(gpio_wstrb),
      .gpio_addr (gpio_addr),
      .gpio_wdata(gpio_wdata),

      .io0_in(io0_in),
      .io1_in(io1_in),
      .io2_in(io2_in),
      .io3_in(io3_in),
      .io4_in(io4_in),
      .io5_in(io5_in),
      .io6_in(io6_in),
      .io7_in(io7_in),

      .gpio_ready(gpio_ready),
      .gpio_rdata(gpio_rdata),

      .io0_oen(io0_oen),
      .io1_oen(io1_oen),
      .io2_oen(io2_oen),
      .io3_oen(io3_oen),
      .io4_oen(io4_oen),
      .io5_oen(io5_oen),
      .io6_oen(io6_oen),
      .io7_oen(io7_oen),

      .io0_out(io0_out),
      .io1_out(io1_out),
      .io2_out(io2_out),
      .io3_out(io3_out),
      .io4_out(io4_out),
      .io5_out(io5_out),
      .io6_out(io6_out),
      .io7_out(io7_out)
  );

endmodule

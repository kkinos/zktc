module zktc_artys7 (
    input logic clk,
    input logic rstn,

    input logic rxd,

    output logic [3:0] led,
    output logic txd
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

  assign boot_sel = mem_addr >= 16'hB000;
  assign ram_sel = (mem_addr >= 16'h0000) && (mem_addr < 16'h5000);
  assign led_sel = mem_addr == 16'h8000;
  assign uart_sel = (mem_addr >= 16'h8100) && (mem_addr < 16'h8200);

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
  assign uart_wstrb = uart_sel ? mem_wstrb[0] : 2'b0;
  assign uart_addr = uart_sel ? mem_addr[7:0] : 8'h0;
  assign uart_wdata = uart_sel ? mem_wdata : 16'h0;

  assign mem_rdata = boot_sel ? boot_rdata : ram_sel ? ram_rdata : uart_sel ? uart_rdata : 16'h0;
  assign mem_ready = boot_sel ? boot_ready : ram_sel ? ram_ready : led_sel ? led_ready : uart_sel ? uart_ready : 1'b0;

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
      .MEM_SIZE(16'h5000)
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


endmodule

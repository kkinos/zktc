module zktc_artys7 (
    input logic clk,
    input logic rstn,

    input logic txd,

    output logic [3:0] led,
    output logic rxd
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

  // ROM
  logic rom_sel;
  logic rom_ready;
  logic rom_valid;
  logic [1:0] rom_wstrb;
  logic [15:0] rom_addr;
  logic [15:0] rom_rdata;
  logic [15:0] rom_wdata;

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

  assign rom_sel   = mem_addr >= 16'hB000;
  assign ram_sel   = (mem_addr >= 16'h0000) && (mem_addr < 16'h5000);
  assign led_sel   = mem_addr == 16'h8000;

  assign rom_valid = rom_sel ? mem_valid : 0;
  assign rom_wstrb = rom_sel ? mem_wstrb : 2'b0;
  assign rom_addr  = rom_sel ? mem_addr - 16'hB000 : 16'h0;
  assign rom_wdata = rom_sel ? mem_wdata : 16'h0;

  assign ram_valid = ram_sel ? mem_valid : 0;
  assign ram_wstrb = ram_sel ? mem_wstrb : 2'b0;
  assign ram_addr  = ram_sel ? mem_addr : 16'h0;
  assign ram_wdata = ram_sel ? mem_wdata : 16'h0;

  assign mem_rdata = rom_sel ? rom_rdata : ram_sel ? ram_rdata : 16'h0;


  assign led_valid = led_sel ? mem_valid : 0;
  assign led_wstrb = led_sel ? mem_wstrb : 2'b0;
  assign led_data  = led_sel ? mem_wdata[3:0] : 4'b0;


  always_comb begin
    if (rom_sel) begin
      mem_ready = rom_ready;
    end else if (ram_sel) begin
      mem_ready = ram_ready;
    end else if (led_sel) begin
      mem_ready = led_ready;
    end else begin
      mem_ready = 0;
    end
  end

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

      .wstrb(rom_wstrb),
      .valid(rom_valid),
      .addr (rom_addr),
      .rdata(rom_rdata),

      .ready(rom_ready),
      .wdata(rom_wdata)
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

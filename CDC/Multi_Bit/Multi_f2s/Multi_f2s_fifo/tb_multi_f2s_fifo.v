/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/ 
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/* Engineer    : Lqc                                                         
/* File        : tb_multi_f2s_fifo.v                                                         
/* Create      : 2022-09-01 14:27:15
/* Revise      : 2022-09-01 14:27:15                                                  
/* Module Name : tb_multi_f2s_fifo                                                  
/* Description : 利用异步FIFO实现多比特数据跨时钟域处理，快时钟到慢时钟                                                                         
/* Editor : sublime text3, tab size (4)                                                                                
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

`timescale 1ns/1ps
module tb_multi_f2s_fifo();

reg            rst   ;
reg            wr_clk;
reg            rd_clk;
reg  [7:0]     din   ;
reg            wr_en ;
reg            rd_en ;
wire [7:0]     dout  ;
wire           full  ;
wire           empty ;
wire           almost_full;
wire           almost_empty;

initial begin
    wr_clk = 'd1;
    rd_clk = 'd1;
    rst    <= 'd1;
    #50
    rst    <= 'd0;
end

//写使能信号设计
always @(posedge wr_clk or posedge rst) begin
    if (rst) begin
        wr_en <= 'd0;
    end
    else if (almost_full) begin       //当将满信号拉高时拉低写数据使能
        wr_en <= 'd0;
    end
    else begin
        wr_en <= 'd1;
    end
end

//写数据内容设计
always @(posedge wr_clk or posedge rst) begin
    if (rst) begin
        din <= 'd0;
    end
    else if (wr_en) begin
        din <= din + 'd1;
    end
    else begin
        din <= din;
    end
end

//读使能信号设计
always @(posedge rd_clk or posedge rst) begin
    if (rst) begin
        rd_en <= 'd0;
    end
    else if (almost_empty) begin      //当将空信号拉高时拉低读数据使能
        rd_en <= 'd0; 
    end
    else begin
        rd_en <= 'd1;
    end
end

//时钟信号设计
always #5   wr_clk  = ~wr_clk;
always #12  rd_clk  = ~rd_clk;

//例化异步FIFO
fifo_generator_0 async_fifo_f2s (
  .rst            (rst),                  // input wire rst
  .wr_clk         (wr_clk),               // input wire wr_clk
  .rd_clk         (rd_clk),               // input wire rd_clk
  .din            (din),                  // input wire [7 : 0] din
  .wr_en          (wr_en),                // input wire wr_en
  .rd_en          (rd_en),                // input wire rd_en
  .dout           (dout),                 // output wire [7 : 0] dout
  .full           (full),                 // output wire full
  .almost_full    (almost_full),          // output wire almost_full
  .empty          (empty),                // output wire empty
  .almost_empty   (almost_empty)          // output wire almost_empty
);

endmodule
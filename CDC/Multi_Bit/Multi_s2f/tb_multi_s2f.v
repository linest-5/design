/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/ 
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/* Engineer    : Lqc                                                         
/* File        : tb_multi_s2f.v                                                         
/* Create      : 2022-09-02 21:06:53
/* Revise      : 2022-09-02 21:06:53                                                  
/* Module Name : tb_multi_s2f                                                  
/* Description : 多比特信号从慢时钟同步到快时钟，含有数据有效信号 仿真模块                                                                         
/* Editor : sublime text3, tab size (4)                                                                                
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

`timescale 1ns/1ps
module tb_multi_s2f();

reg                          clka     ;
reg                          clkb     ;
reg                          rst      ;
reg  [DATA_WIDTH-1:0]        din      ;
reg                          valid_in ;
wire  [DATA_WIDTH-1:0]       dout     ;
wire                         valid_out;

parameter  DATA_WIDTH  =  'd8;

initial begin
	clka      = 'd1;
	clkb      = 'd1;
	rst      <= 'd1;
	#20
	rst      <= 'd0;
	din      <= 'd0;
	valid_in <= 'd0;
	#50
	din      <= 'd1;
	valid_in <= 'd1;
	#20
	valid_in <= 'd0;
	#200
	din      <= 'd2;
	valid_in <= 'd1;
	#20
	valid_in <= 'd0;
end

always #10 clka = ~clka;
always #9  clkb = ~clkb;

multi_s2f #(
		.DATA_WIDTH(DATA_WIDTH)
) inst_multi_s2f (
		.clka      (clka),
		.clkb      (clkb),
		.rst       (rst),
		.din       (din),
		.valid_in  (valid_in),
		.dout      (dout),
		.valid_out (valid_out)
	);


endmodule
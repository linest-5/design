/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/ 
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/* Engineer    : Lqc                                                         
/* File        : tb_multi_bit_f2s.v                                                         
/* Create      : 2022-09-01 11:30:48
/* Revise      : 2022-09-01 11:30:48                                                  
/* Module Name : tb_multi_bit_f2s                                                  
/* Description : 多比特信号跨时钟域快到慢仿真模块                                                                         
/* Editor : sublime text3, tab size (4)                                                                                
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

`timescale 1ns/1ps
module tb_multi_bit_f2s();

reg            clka;
reg            clkb;
reg            rst;
reg  [7:0]     din;
reg            valid_in;
wire [7:0]     dout;
wire           valid_out;

initial begin
	clka = 'd1;
	clkb = 'd1;
	rst  = 'd1;
	#50
	rst  = 'd0;
	din  = 'd0;
	valid_in = 'd0;
	#100
	din = 'd1;
	valid_in = 'd1;
	#10
	valid_in = 'd0;
	#200
	din = 'd2;
	valid_in = 'd1;
	#10
	valid_in = 'd0;	
	#200
	din = 'd3;
	valid_in = 'd1;
	#10
	valid_in = 'd0;	
end

always #5 clka = ~clka;
always #16 clkb = ~clkb;

multi_bit_f2s #(
	.DATA_WIDTH('d8)
) inst_multi_bit_f2s (
	.clka      (clka),
	.clkb      (clkb),
	.rst       (rst),
	.din       (din),
	.valid_in  (valid_in),
	.dout      (dout),
	.valid_out (valid_out)
);


endmodule
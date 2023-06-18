/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/ 
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/* Engineer    : Lqc                                                         
/* File        : tb_Narrow_pulse_det.v                                                         
/* Create      : 2022-09-01 09:58:16
/* Revise      : 2022-09-01 09:58:16                                                  
/* Module Name : tb_Narrow_pulse_det                                                  
/* Description : 窄脉冲检测电路仿真模块                                                                         
/* Editor : sublime text3, tab size (4)                                                                                
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

`timescale 1ns/1ps
module tb_Narrow_pulse_det();

reg       clk;
reg       rst;
reg       pulse;
wire      sync_pulse;

initial begin
	clk = 'd1;
	rst = 'd1;
	#100
	rst = 'd0;
	pulse = 'd0;
	#50
	pulse = 'd1;
	#5
	pulse = 'd0;
	#100
	pulse = 'd1;
	#5
	pulse = 'd0;	
end

always #5 clk = ~clk;

Narrow_pulse_det inst_Narrow_pulse_det (
	.clk(clk), 
	.rst(rst), 
	.pulse(pulse), 
	.sync_pulse(sync_pulse)
);

endmodule
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/ 
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/* Engineer    : Lqc                                                         
/* File        : tb_single_f2s.v                                                         
/* Create      : 2022-08-29 22:22:50
/* Revise      : 2022-08-29 22:22:50                                                  
/* Module Name : tb_single_f2s                                                 
/* Description : 结绳法仿真模块                                                                         
/* Editor : sublime text3, tab size (4)                                                                                
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

module tb_single_f2s();

reg          clka;
reg          clkb;
reg          rst;
reg          din;
wire         dout;

initial begin
	clka = 'd0;
	clkb = 'd0;
	rst  <= 'd1;
	din  <= 'd0;
	#20
	rst  <= 'd0;
	#15
	din  <= 'd1;
	#10
	din  <= 'd0;
	#100
	din  <= 'd1;
	#10
	din  <= 'd0;	
end

always #5    clka = ~clka;
always #10   clkb = ~clkb;

single_f2s inst_single_f2s (
	.clka(clka), 
	.clkb(clkb), 
	.rst(rst), 
	.din(din), 
	.dout(dout)
);

endmodule
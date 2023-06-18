/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/ 
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/* Engineer:    Lqc                                                                 
/* Create Date: 2022/08/24                                                          
/* Module Name: tb_Handshake_Sync                                                      
/* Description: 握手同步器设计模块仿真                                                     
/* Command:                                                                        
/*
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

module tb_Handshake_Sync();
	reg        clk_A;
	reg        clk_B;
	reg        rst_A;
	reg        rst_B;
	reg        in_A;
	wire       out_B;
	wire       out_B_pulse;
	wire       busy;		

initial begin
	clk_A = 'd0;
	clk_B = 'd0;
	rst_A = 'd1;
	rst_B = 'd1;
	in_A  = 'd0;
	#20
	rst_A = 'd0;
	rst_B = 'd0;
	in_A  = 'd0;
	#50
	in_A  = 'd1;
	#10
	in_A  = 'd0;
	#100
	in_A  = 'd1;
	#20
	in_A  = 'd0;	
end

always #5 clk_A = ~clk_A;
always #10 clk_B = ~clk_B;

Handshake_Sync inst_Handshake_Sync(
	.clk_A       (clk_A),
	.clk_B       (clk_B),
	.rst_A       (rst_A),
	.rst_B       (rst_B),
	.in_A        (in_A),
	.out_B       (out_B),
	.out_B_pulse (out_B_pulse),
	.busy        (busy)
);

endmodule 
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/ 
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/* Engineer    : Lqc                                                         
/* File        : single_bit_s2f_ff.v                                                         
/* Create      : 2022-08-30 09:54:55
/* Revise      : 2022-08-30 09:54:55                                                  
/* Module Name : single_bit_s2f_ff                                                  
/* Description : 跨时钟域处理
/*               打两拍处理                                                                         
/* Editor : sublime text3, tab size (4)                                                                                
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

module single_bit_s2f_ff(
	input         clka,         //fast clk
	input         clkb,         //slow clk
	input         rst,
	input         din,
	output        dout
	);
reg               din_reg1;
reg               din_reg2;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*      Main Code                                                                  */
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
always @(posedge clka or posedge rst) begin
	if (rst) begin
		din_reg1 <= 'd0;		
		din_reg2 <= 'd0;		
	end
	else begin
		din_reg1 <= din;		
		din_reg2 <= din_reg1;
	end
end

assign dout = din_reg2;
	
endmodule
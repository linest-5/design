/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/ 
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/* Engineer    : Lqc                                                         
/* File        : single_bit_f2s.v                                                         
/* Create      : 2022-08-29 21:20:47
/* Revise      : 2022-08-29 21:20:47                                                  
/* Module Name : single_bit_f2s                                                  
/* Description : 跨时钟域处理
/*               单比特信号快时钟到慢时钟处理方法
/*               信号展宽，然后利用边沿检测同步器      
/*    快时钟域下的两个输入脉冲的间隔必须大于或等于慢时钟域的2个时钟周期。                                                        
/* Editor : sublime text3, tab size (4)                                                                                                                                                        
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

module single_bit_f2s(
	input         clka,         //fast clk
	input         clkb,         //slow clk
	input         rst,
	input         din,
	output        dout
	);
reg               flag;
reg               flag_reg1;
reg               flag_reg2;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*      Main Code                                                                  */
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
//在快时钟域下对输入的信号进行检测
always @(posedge clka or posedge rst) begin
	if (rst) begin
		flag <= 'd0;
	end
	else if (din) begin
		flag <= ~flag;
	end
	else begin
		flag <= flag;
	end
end

//在慢时钟下对输入的信号打两拍做同步
always @(posedge clkb or posedge rst) begin
	if (rst) begin
		flag_reg1 <= 'd0;
		flag_reg2 <= 'd0;
	end
	else begin
		flag_reg1 <= flag;
		flag_reg2 <= flag_reg1;		
	end
end

//对打拍的信号做异或操作得到脉冲信号
assign dout = flag_reg1 ^ flag_reg2;

endmodule
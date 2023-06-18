/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/ 
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/* Engineer    : Lqc                                                         
/* File        : single_f2s.v                                                         
/* Create      : 2022-08-29 22:02:41
/* Revise      : 2022-08-29 22:02:41                                                  
/* Module Name : single_f2s                                                  
/* Description : 单比特跨时钟域处理，快到慢
/*               结绳法也称握手法 
/*          注意：原时钟输入的脉冲间隔需在目的时钟周期的5倍以上 
/*          另外此模块带有同步错误检测电路信号，当输入的脉冲信号
/*          过于密集，就会产生与输入脉冲同步的错误标志信号                                                                       
/* Editor : sublime text3, tab size (4)                                                                                
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

module single_f2s(
	input         clka,         //fast clk
	input         clkb,         //slow clk
	input         rst,
	input         din,
	output        dout,
	output        sync_fail     //同步错误标志信号
	);
reg               din_reg;
reg               a1,a2;
reg               b1,b2;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*      Main Code                                                                  */
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
//在快时钟域下对输入的信号展宽
always @(posedge clka or posedge rst) begin
	if (rst) begin
		din_reg <= 'd0;
	end
	else if (din) begin
		din_reg <= 'd1;
	end
	else if (a2) begin      //形成闭环
		din_reg <= 'd0;
	end
	else begin
		din_reg <= din_reg;
	end
end

//在慢时钟域下将展宽后的信号打拍同步
always @(posedge clkb or posedge rst) begin
	if (rst) begin
		b1 <= 'd0;
		b2 <= 'd0;
	end
	else begin
		b1 <= din_reg;
		b2 <= b1;
	end
end

//再将在慢时钟下同步得到的信号同步到快时钟域下
always @(posedge clka or posedge rst) begin
	if (rst) begin
		a1 <= 'd0;
		a2 <= 'd0;
	end
	else begin
		a1 <= b2;
		a2 <= a1;		
	end
end

assign dout = (b1 & (~b2));    //在慢时钟域下得到脉冲信号
assign sync_fail = a1 & din;   //同步错误标志信号，与输入的脉冲信号同步

endmodule
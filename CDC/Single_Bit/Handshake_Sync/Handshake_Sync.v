/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/ 
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/* Engineer:    Lqc                                                                 
/* Create Date: 2022/08/24                                                          
/* Module Name: Handshake_Sync                                                      
/* Description: 握手同步器设计                                                     
/* Command:                                                                        
/*   由较快时钟域传来的数据，用较慢的时钟域去采数据，会出现数据丢失的情况，所以本模块的
/*   作用就是将较快时钟域传来的数据进行数据展宽，这样在较慢的时钟域就可以不漏数据的采。                          
/*   并且最终的输出信号会有一个同步的脉冲输出，以及在同步器工作时有busy信号标识正在工作。
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

module Handshake_Sync(
	input           clk_A,          //时钟A，较快时钟    
	input           clk_B,          //时钟B，较慢时钟
	input           rst_A,          //时钟域A的复位信号，高有效
	input           rst_B,          //时钟域B的复位信号，高有效 
	input           in_A,           //时钟域A输入的信号 
	output reg      out_B,          //由时钟域A输入的信号同步到时钟域B的信号输出
	output          out_B_pulse,    //时钟域B输出同步信号的脉冲
	output          busy            //同步器工作忙状态信号
	);

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*     Define Signals                                                              */
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
reg            out_B_reg;           //由时钟域A输入的信号同步到时钟域B的信号输出打一拍
reg            in_A_widen;          //时钟域A输入的信号展宽信号
reg            in_A_widen_reg;      //时钟域A输入的信号展宽信号打一拍
reg            in_A_widen_sync;     //在时钟域B中打一拍
reg            out_B_clka_reg1;     //由时钟域A输入的信号同步到时钟域B的信号输出在时钟域A打一拍
reg            out_B_clka_reg2;     //由时钟域A输入的信号同步到时钟域B的信号输出在时钟域A打两拍

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*     Main Code                                                                   */
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
//时钟域A输入的信号展宽信号
always @(*) begin
	if (in_A) begin
		in_A_widen = 'd1;
	end
	else if (out_B_clka_reg2) begin
		in_A_widen = 'd0; 
	end
	else begin
		in_A_widen = in_A_widen_reg;
	end
end

//时钟域A输入的信号展宽信号打一拍
always @(posedge clk_A or posedge rst_A) begin
	if (rst_A) begin
		in_A_widen_reg <= 'd0;
	end
	else begin
		in_A_widen_reg <= in_A_widen;
	end
end

//由时钟域A输入的信号同步到时钟域B的信号输出
always @(posedge clk_B or posedge rst_B) begin
	if (rst_B) begin
		in_A_widen_sync <= 'd0;
		out_B <= 'd0;
	end
	else begin
		in_A_widen_sync <= in_A_widen;
		out_B <= in_A_widen_sync;		
	end
end

//对out_B在时钟域B下打一拍
always @(posedge clk_B or posedge rst_B) begin
	if (rst_B) begin
		out_B_reg <= 'd0;
	end
	else begin
		out_B_reg <= out_B;
	end
end

//时钟域B输出同步信号的脉冲
assign out_B_pulse = out_B & (!out_B_reg);

always @(posedge clk_A or posedge rst_A) begin
	if (rst_A) begin
		out_B_clka_reg1 <= 'd0;
		out_B_clka_reg2 <= 'd0;
	end
	else begin
		out_B_clka_reg1 <= out_B;
		out_B_clka_reg2 <= out_B_clka_reg1;		
	end
end

//同步器工作忙状态信号
assign busy = in_A_widen || out_B_clka_reg2;

endmodule
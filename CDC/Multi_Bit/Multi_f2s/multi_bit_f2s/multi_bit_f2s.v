/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/ 
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/* Engineer    : Lqc                                                         
/* File        : multi_bit_f2s.v                                                         
/* Create      : 2022-09-01 10:17:01
/* Revise      : 2022-09-01 10:17:01                                                  
/* Module Name : multi_bit_f2s                                                  
/* Description : 多比特信号跨时钟域快到慢                                                                         
/* Editor : sublime text3, tab size (4)                                                                                
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

module multi_bit_f2s #(
	parameter  DATA_WIDTH  =  'd8
	)
	(
	input                        clka,             //fast clk
	input                        clkb,             //slow clk
	input                        rst,              //复位信号，高有效
	input      [DATA_WIDTH-1:0]  din,              //输入数据
	input                        valid_in,         //摄入数据同步标志信号
	output reg [DATA_WIDTH-1:0]  dout,             //输出数据
	output reg                   valid_out         //输出数据同步标志信号
	);

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*      信号申明                                                                    */
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
reg                    valid_in_reg1;
reg                    valid_in_reg2;
reg                    valid_in_reg3;
wire                   valid_flag;
reg [DATA_WIDTH-1:0]   din_reg;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*      Main Code                                                                  */
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
//将输入的有效信号做展宽
always @(valid_in or valid_flag or rst) begin
	if (rst) begin
		valid_in_reg1 <= 'd0;
	end
	else if (valid_in) begin
		valid_in_reg1 <= 'd1;
	end
	else if ((!valid_in) && valid_flag) begin
		valid_in_reg1 <= 'd0;
	end
	else begin
		valid_in_reg1 <= valid_in_reg1;
	end
end

//对展宽后的标志信号在clkb（慢时钟域）进行打拍
always @(posedge clkb or posedge rst) begin
	if (rst) begin
		valid_in_reg2 <= 'd0;
		valid_in_reg3 <= 'd0;
	end
	else begin
		valid_in_reg2 <= valid_in_reg1;
		valid_in_reg3 <= valid_in_reg2;
	end
end

//检测上升沿
assign valid_flag = valid_in_reg2 && (!valid_in_reg3);

//对输入的数据在原时钟clka（快时钟域）打一拍，与valid_flag同步
always @(posedge clka or posedge rst) begin
	if (rst) begin
		din_reg <= 'd0;
	end
	else begin
		din_reg <= din;
	end
end

//在clkb（慢时钟域）下对数据进行采集
always @(posedge clkb or posedge rst) begin
	if (rst) begin
		dout <= 'd0;
	end
	else if (valid_flag) begin
		dout <= din_reg;
	end
	else begin
		dout <= dout;
	end
end

always @(posedge clkb or posedge rst) begin
	if (rst) begin
		valid_out <= 'd0;
	end
	else begin
		valid_out <= valid_flag;
	end
end

endmodule
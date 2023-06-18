/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/ 
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/* Engineer    : Lqc                                                         
/* File        : multi_s2f.v                                                         
/* Create      : 2022-09-02 20:33:35
/* Revise      : 2022-09-02 20:33:35                                                  
/* Module Name : multi_s2f                                                  
/* Description : 多比特信号从慢时钟同步到快时钟，含有数据有效信号                                                                         
/* Editor : sublime text3, tab size (4)                                                                                
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

module multi_s2f(
	input                         clka,       //slow clk
	input                         clkb,       //fast clk
	input                         rst,
	input  [DATA_WIDTH-1:0]       din,
	input                         valid_in,
	output reg [DATA_WIDTH-1:0]   dout,
	output reg                    valid_out
	);

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*        参数和信号申明                                                            */
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
parameter  DATA_WIDTH  =  'd8;

reg        valid_in_reg1;
reg        valid_in_reg2;
wire       valid_flag;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*        Main Code                                                                */
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
//对输入数据的标志信号做上升沿检测
always @(posedge clkb or posedge rst) begin
	if (rst) begin
		valid_in_reg1 <= 'd0;
		valid_in_reg2 <= 'd0;
	end
	else begin
		valid_in_reg1 <= valid_in;
		valid_in_reg2 <= valid_in_reg1;
	end
end

//上升沿检测得到标志信号
assign valid_flag = (valid_in_reg1 & (~valid_in_reg2));

//在快时钟域下对数据进行采样
always @(posedge clkb or posedge rst) begin
	if (rst) begin
		dout <= 'd0;
	end
	else if (valid_flag) begin
		dout <= din;
	end
	else begin
		dout <= dout;
	end
end

//对valid_flag信号打一拍作为输出数据的标志信号
always @(posedge clkb or posedge rst) begin
	if (rst) begin
		valid_out <= 'd0;
	end
	else begin
		valid_out <= valid_flag;
	end
end

endmodule
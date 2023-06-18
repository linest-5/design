/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/ 
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/* Engineer    : Lqc                                                         
/* File        : Narrow_pulse_det.v                                                         
/* Create      : 2022-09-01 09:38:46
/* Revise      : 2022-09-01 09:38:46                                                  
/* Module Name : Narrow_pulse_det                                                  
/* Description : 窄脉冲检测电路                                                                         
/* Editor : sublime text3, tab size (4)                                                                                
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

module Narrow_pulse_det(
	input             clk,
	input             rst,
	input             pulse,
	output            sync_pulse
	);

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*     信号申明                                                                     */
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
reg                   pulse_reg1;
reg                   pulse_reg2;
reg                   pulse_reg3;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*     Main Code                                                                   */
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
//将输入的脉冲作为第一个触发器的触发时钟
always @(pulse or pulse_reg3 or rst) begin
	if (rst) begin
		pulse_reg1 <= 'd0;
	end
	else if (pulse) begin
		pulse_reg1 <= 'd1;
	end
	else if ((!pulse) & pulse_reg3) begin
		pulse_reg1 <= 'd0;
	end
	else begin
		pulse_reg1 <= pulse_reg1;
	end
end

//对第一个触发得到的脉冲信号打拍
always @(posedge clk or posedge rst) begin
	if (rst) begin
		pulse_reg2 <= 'd0;
		pulse_reg3 <= 'd0;
	end
	else begin
		pulse_reg2 <= pulse_reg1;
		pulse_reg3 <= pulse_reg2;
	end
end

//pulse_reg3即为将窄脉冲信号同步到时钟上的同步脉冲信号
assign sync_pulse = pulse_reg3;

endmodule
module registers(clk, rst, PC_reg, PC_next, IR_reg, IR_next, ACC_reg, ACC_next, MDR_reg, MDR_next, MAR_reg, MAR_next, zflag_reg, zflag_next);

	input wire clk;
	input wire rst;
	output reg  [7:0]PC_reg; 
	input wire  [7:0]PC_next;
 
	output reg  [15:0]IR_reg;  
	input wire  [15:0]IR_next;  

	output reg  [15:0]ACC_reg;  
	input wire  [15:0]ACC_next;  

	output reg  [15:0]MDR_reg;  
	input wire  [15:0]MDR_next;  

	output reg  [7:0]MAR_reg;  
	input wire  [7:0]MAR_next;  

	output reg zflag_reg;
	input wire zflag_next;

	//provide synchronous reset for the registers
	always @(posedge clk)
	begin
		if(rst)
			begin
			PC_reg <= 0;
			IR_reg <= 0;
			ACC_reg <= 0;
			MDR_reg <= 0;
			MAR_reg <= 0;
			zflag_reg <= 0;
			end
		else
			begin	
			PC_reg <= PC_next;
			IR_reg <= IR_next;
			ACC_reg <= ACC_next;
			MDR_reg <= MDR_next;
			MAR_reg <= MAR_next;
			zflag_reg <= zflag_next;
			end
	end

endmodule
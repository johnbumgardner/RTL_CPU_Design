module datapath(clk, rst, muxPC, muxMAR, muxACC, loadMAR, loadPC, loadACC, loadMDR, loadIR, opALU, zflag, opcode, MemAddr, MemD, MemQ, muxOUT, mult_done, mult_ld);

	//inputs for the datapath
	input clk;
        input  rst;
        input  muxPC;
        input  muxMAR;
        input  muxACC;
        input  loadMAR;
        input  loadPC;
        input  loadACC;
        input  loadMDR;
        input  loadIR;
        input  [1:0] opALU; 
        input muxOUT;
	input mult_done, mult_ld; //for pipelined multipler

        output reg [7:0]opcode; //gets the thing to do
        output reg [7:0]MemAddr;
        output reg [15:0]MemD;
        input  [15:0]MemQ;
	output reg zflag;

	reg  [7:0]PC_next;
	reg  [15:0]IR_next;  
	reg  [15:0]ACC_next;  
	reg  [15:0]MDR_next;  
	reg  [7:0]MAR_next;  
	reg zflag_next;

	wire  [7:0]PC_reg;
	wire  [15:0]IR_reg;  
	wire  [15:0]ACC_reg;  
	wire  [15:0]MDR_reg;  
	wire  [7:0]MAR_reg;  

	wire  [15:0]ALU_out;  
	wire [15:0] MULT_out; //output for the pipelined multiplier
	wire zflag_reg;
	

	//one instance of ALU
	alu a1(MDR_reg, ACC_reg, opALU, ALU_out);
	
	//instance of a multiplier
	hw6_1 mult(clk, rst, mult_ld, MDR_reg[7:0], ACC_reg[7:0], MULT_out, mult_done);
	
	// one instance of register.
	//if theres a problem first place to check
	registers r1(clk, rst, PC_reg, PC_next, IR_reg, IR_next, ACC_reg, ACC_next, MDR_reg, MDR_next, MAR_reg, MAR_next, zflag_reg, zflag_next);

	//code to generate
	
	
	always@(*)
	begin
		//[7:0]PC_next;
		//Only change if loadpc is enabled.
		//Mux pc decides between pc+1 or branch address
		//Reset address is 0, Hence nothing for the datapath to do at reset.

		//potential problem
		PC_next <= loadPC ?  (muxPC ? IR_reg[15:8] : PC_reg+1) : PC_reg;
		
		//[15:0]IR_next;  
		//Gets value of mdr_reg if loadir is set
		IR_next <= loadIR ? MDR_reg : IR_reg;
		
		// [15:0]ACC_next;  
		//Only change when loaddacc is enabled.
		//Muxacc decides between mdr_reg and alu out
		ACC_next <= loadACC ? (muxACC ? MDR_reg : ALU_out): ACC_reg; 


		// [15:0]MDR_next;  
		//Gets value from memeory,  if load mdr is set

		MDR_next <= loadMDR ? MemQ : MDR_reg;
		
		//[7:0]MAR_next;  
		//Only change if loadmar is enabled.
		//Mux mar decides between  pcreg or IR[15:8]reg
		
		MAR_next <= loadMAR ? (muxMAR ? IR_reg[15:8] : PC_reg) : MAR_reg;
		
		//zflag_next;
		//Decide  based on the content of acc_reg
		zflag_next <= (ACC_reg==0);

		//needs to generate the following outputs
		//set this outputs based on the registered value and not the next value to prevent glitches.

		//based on ACC reg
		//opcode <= IR_reg[15:8]; //based on IR_reg
   		//MemAddr <= MAR_reg; //Same as MAR_reg
   		//MemD <= ACC_reg; //Same as ACC reg
		MemD <= ACC_reg;
		MemAddr <= MAR_reg;
		opcode <= IR_reg[7:0];
		zflag <= (ACC_reg==0);
	end
endmodule
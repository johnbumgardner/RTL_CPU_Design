module ctr(clk, rst, zflag, opcode, muxPC, muxMAR, muxACC, loadMAR, loadPC, loadACC, loadMDR, loadIR, opALU, MemRW, muxOUT, mult_done, mult_ld);
	
	//inputs
	input clk;
        input rst;
        input zflag;
        input [7:0]opcode;
          
	//outputs 
	output reg muxPC;
        output reg muxMAR;
        output reg muxACC;
        output reg loadMAR;
	output reg loadPC;
        output reg loadACC;
        output reg loadMDR;
        output reg loadIR;
        output reg [1:0] opALU;
        output reg MemRW;
	output reg muxOUT;
	output reg mult_done, mult_ld;

	//contains the states - 16 possible one
	reg [3:0]present_state;
	reg [3:0]next_state;
	
	//These opcode representation need to be followed for proper operation
	parameter op_add=8'b001;
	parameter op_or= 8'b010;
	parameter op_jump=8'b011;
	parameter op_jumpz=8'b100;
	parameter op_load=8'b101;
	parameter op_store=8'b110;
	parameter op_mult = 8'b1001;

	//States for the Control Module
	parameter fetch_1 = 4'b0000;
	parameter fetch_2 = 4'b0001;
	parameter fetch_3 = 4'b0010;
	parameter decode = 4'b0011;
	parameter exec_add_1 = 4'b0100;
	parameter exec_add_2 = 4'b0101;
	parameter exec_load_1 = 4'b0110;
	parameter exec_load_2 = 4'b0111;
	parameter store = 4'b1000;
	parameter jump = 4'b1001;
	parameter exec_or_1 = 4'b1010;
	parameter exec_or_2 = 4'b1011;
	parameter exec_mult_0 = 4'b1100;
	parameter exec_mult_1 = 4'b1101;
	parameter exec_mult_2 = 4'b1110;
	parameter exec_mult_3 = 4'b1111; 

	//controls state on the clk cycle
	always@(posedge clk)
	begin
		if(rst) present_state <= fetch_1;
		else present_state <= next_state;
	end

	//when something that affects the state changes
	always@(present_state or opcode or zflag)
	begin
			//initialize the flags to avoid x propogation
			muxPC <= 0; 
    			muxMAR <= 0; 
    			muxACC <= 0; 
    			loadMAR <= 0; 
    			loadPC <= 0; 
    			loadACC <= 0; 
    			loadMDR <= 0; 
    			loadIR <= 0; 
    			opALU <= 0; 
    			MemRW <= 0;
			
			//based on the state - go to another one
			case(present_state) 
			fetch_1: 
			begin 
				next_state <= fetch_2; 
				muxMAR <= 0; muxPC <= 0; loadPC <= 1; loadMAR <= 1; 
			end
			
			fetch_2: 
			begin 
				next_state <= fetch_3; 
				MemRW <= 0; loadMDR <= 1; 
			end
			
			fetch_3: 
			begin 
				next_state <= decode; 
				loadIR <= 1; 
			end
			
			decode: 
			begin
				muxMAR <= 1; loadMAR <= 1;
				//based on opcode pick what instruction to perform
				case(opcode)	
					op_add: next_state <= exec_add_1;
					op_or: next_state <= exec_or_1;
					op_jump: next_state <= jump;
					op_jumpz: next_state <= zflag ? jump : fetch_1;
					op_load: next_state <= exec_load_1;
					op_store: next_state <= store;
					op_mult: next_state <= exec_mult_0; //mult_ld = 1; end //use the mult_ld as the ld
					default: next_state <= fetch_1;
				endcase
			end	
			
			jump: 
			begin 
				next_state <= fetch_1; 
				muxPC <= 1; loadPC <= 1; 
			end
			
			store: 
			begin 
				next_state <= fetch_1; 
				MemRW <= 1; 
			end
			
			exec_load_1: 
			begin 
				next_state <= exec_load_2; 
				MemRW <= 0; loadMDR <= 1; 
			end
			
			exec_load_2: 
			begin 
				next_state <= fetch_1; 
				loadACC <= 1; muxACC <= 1; 
			end
			
			exec_or_1: 
			begin 
				next_state <= exec_or_2; 
				MemRW <= 0; loadMDR <= 1; 
			end
			
			exec_or_2: 
			begin 
				next_state <= fetch_1; 
				loadACC <= 1; muxACC <= 0; opALU <= 0; 
			end

			exec_add_1: 
			begin 
				next_state <= exec_add_2; 
				MemRW <= 0; loadMDR <= 1; 
			end
			
			exec_add_2: 
			begin 
				next_state <= fetch_1; 
				loadACC <= 1; muxACC <= 0; opALU <= 2'b01; 
			end
			
			exec_mult_0: 
			begin
				MemRW <= 0; loadMDR <= 1; 
				next_state <= exec_mult_1;	
				
			end
			exec_mult_1: 
				begin
				loadACC <= 1; muxACC <= 0; opALU <= 2; 
				next_state <= exec_mult_2;	
				end
			exec_mult_2: 
			begin
				 
				next_state <= exec_mult_3;	
			end
			
			exec_mult_3: 
			begin
				next_state <= fetch_1;
			end
		endcase
	end
endmodule
module alu(A, B, opALU, Rout);
	input [15:0] A; //16 bit input 1
	input [15:0] B; //16 bit input 2
	input [1:0]opALU; //2 bit input
	     		//1 A + B
             		//0 A | B
			//multiply
	
	output reg [15:0] Rout; //16 bit output
	integer count;
	always@(A or B or opALU)
	begin
		if(opALU == 1)
		begin
			Rout <= A + B;
		end
		if(opALU == 0)
		begin
			Rout <= A | B;
		end
		if(opALU == 2)
		begin
			for(count = 0; count <= A[7:0]; count = count + 1)
				Rout[7:0] <= Rout[7:0] + B[7:0];
			
		end

	end
endmodule
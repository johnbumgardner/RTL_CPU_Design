module hw6_1(clk,rst, ld, A, B, O, Done);
	input clk, rst, ld;//enable
	input [7:0]A;
	input [7:0]B;
	output reg[15:0]O;//output
	reg [2:0]C;//counter
	reg [1:0]select;
	output reg Done;
	reg [8:0] a;
	reg [8:0] b;
	reg [15:0] o;
	wire [15:0] shifted, added;
	shifter shifting(a,C,shifted);
	fulladder adding(o,O,added);
	always @(posedge clk or posedge rst)
	begin
		if(rst)
		begin
		O<=16'b0;
 		select<=0;
 	end
	else
 	begin
		case(select)
			0:
			begin
	    			Done=0;
	    			if(ld==1)
				begin
					a=A;
					b=B;
					C=0;
					select=1;
				end
	    			else 
				begin
					select=0;
				end
	  		end
			
			1:	
			begin
	    			if(b[C]==1)
				begin
					//O and A go to Full adder/shifter
					//shifter (a,C,o);
					//full_adder (o==shifted a,O,added);
					a=A;
					o=shifted;
					C=C+1;
	   				select=2;
					end
	    			else
				begin
					//O and zero to fulladder
					//full_adder (o==0,O,added);
					o=0;
					C=C+1;
	  				select=2;
				end
          		end
			
			2:
			begin
	    			//fulladder (a, b, O);
	    			O=added;
	    			if(C==Done)
					select=3;
	    			else
					select=1;
	  		end
			
			3:
			begin
	    			Done=1;
	    			select=0;
	  		end
		endcase
 	end
	end
endmodule
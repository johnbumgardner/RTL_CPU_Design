module proj1_tb;
	reg clk;
	reg rst;
	wire MemRW_IO;
	wire [7:0]MemAddr_IO;
	wire [15:0]MemD_IO;

	always@(t.c1.present_state) 
begin
	case (t.c1.present_state)

		0: $display($time," Fetch_1");
		1: $display($time," Fetch_2");
		2: $display($time," Fetch_3");
		3: $display($time," Decode");
		4: $display($time," Exec Add 1");
		5: $display($time," Exec Add 2");
		6: $display($time," Exec Load 1");
		7: $display($time," Exec Load 2");
		8: $display($time," Store");
		9: $display($time," Jump");
		10: $display($time," Exec Or 1");
		11: $display($time," Exec Or 2");
		12: $display($time," Mult 1");
		13: $display($time," Mult 2");
		14: $display($time," Mult 3");
		15: $display($time," Mult 4");
		default: $display($time," Unrecognized State");
	endcase 
end

always 
begin
      #5  clk = !clk;
end
		
initial 
begin
	$dumpfile("Proj1_waves.vcd");
  	$dumpvars;
	clk=1'b0;
	rst=1'b1;
	$readmemh("mem.dat", proj1_tb.t.m1.mem);
	#20 rst=1'b0;
	#435
	$display("Final value\n");
	$display("0x00d %d\n", proj1_tb.t.m1.mem[16'h000d]);
	$stop;
end

proj1 t(clk, rst, MemRW_IO, MemAddr_IO, MemD_IO);	   

endmodule


/*
 *	Files Provided by Dr. Sunderesan to assist in the 
 *	usage of the pipelined multiplier
 */

module fulladder(input [15:0] x, input [15:0] y, output [15:0] o);
	assign o=y+x;
endmodule

module shifter(input [15:0] in, input [2:0] n, output [15:0] o);
	reg [15:0] out_reg;
	assign o = out_reg;
	always @(n or in)
	case (n)
		7 : out_reg <= { in[7:0],7'b0};
		6 : out_reg <= { in[7:0],6'b0};
		5 : out_reg <= { in[7:0],5'b0};
		4 : out_reg <= { in[7:0],4'b0};
		3 : out_reg <= { in[7:0],3'b0};
		2 : out_reg <= { in[7:0],2'b0};
		1 : out_reg <= { in[7:0],1'b0};
		0 : out_reg <= in[7:0];
	endcase
endmodule
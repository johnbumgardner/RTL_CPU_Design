module  ram(we, d, q, addr);
	input we; //1 bit read / write enable
	input [15:0] d; //16 bit data input
	input [7:0] addr; //8 bit input address
	output reg [15:0] q;  //16 bit data output
	reg [15:0] mem [0:255]; //actual memory block

	always@(addr) begin
	if(we) mem[addr] = d; //if write enable is high
	else q = mem[addr];
	end
endmodule
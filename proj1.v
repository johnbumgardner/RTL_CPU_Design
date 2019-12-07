module proj1(clk, rst, MemRW_IO, MemAddr_IO, MemD_IO);

        input clk;
        input rst;
	output MemRW_IO;
	output [7:0]MemAddr_IO;
        output [15:0]MemD_IO;
	wire [1:0] opALU;
	wire muxPC, muxMAR, muxACC, loadMAR, loadPC, loadACC, loadMDR, loadIR, MemRW, zflag, muxOUT;
	wire [7:0] MemAddr, opcode;
	wire [15:0] MemD, MemQ;

	

	ram m1(MemRW, MemD, MemQ, MemAddr);
	
	ctr  c1( clk,  rst, zflag, opcode, muxPC, muxMAR, muxACC, loadMAR,  loadPC, loadACC,  loadMDR, loadIR,opALU, MemRW, muxOUT, mult_done, mult_ld);

	datapath  d1( clk, rst,  muxPC,  muxMAR, muxACC,  loadMAR,  loadPC, loadACC,  loadMDR,  loadIR, opALU,  zflag,  opcode, MemAddr,  MemD,  MemQ, muxOUT, mult_done, mult_ld );
	assign MemAddr_IO = MemAddr;
 	assign MemD_IO = MemD;
 	assign MemRW_IO = MemRW;
endmodule
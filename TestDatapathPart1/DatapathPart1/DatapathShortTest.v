`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:33:59 11/18/2015
// Design Name:   Datapath1
// Module Name:   C:/Users/Juanjo/Documents/Juanjo/Facu/Arquitectura/Trabajo Final/finalArquitectura/TestDatapathPart1/DatapathPart1/DatapathShortTest.v
// Project Name:  DatapathPart1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Datapath1
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module DatapathShortTest;

	// Inputs
	reg clock;
	reg [31:0] instruction;
	reg reset;
	reg [5:0]special=0;
	reg [4:0]rt=0;
	reg [4:0]rs=0;
	reg [15:0]immediate=0;
	reg [5:0]operation=0;
	reg [4:0]rd=0;
	reg [4:0]sa=0;
	reg [4:0]zeros=0;
	// Instantiate the Unit Under Test (UUT)
	Datapath1 uut (
		.clock(clock), 
		.resetGral(reset),
		.instruction(instruction)
	);

	initial begin
		// Initialize Inputs
		clock = 0;
	   reset=0;
		// Wait 100 ns for global reset to finish
		#100
		reset=1;
		#100
		reset=0;
		#100
		
		special=6'b001000;
		rt=0;
		rs=2;
		immediate=650;
		instruction={special,rs,rt,immediate};//sumo un valor inmediato de 650 al r2(esta en 0) y lo guardo en r0
		#1;
		clock = ~clock;
		#10;
				clock = ~clock;
		#10;
		
		
		special=6'b001000;
		rt=1;
		rs=2;
		immediate=3;
		instruction={special,rs,rt,immediate};//sumo un valor inmediato de 3 al r2(esta en 0) y lo guardo en r1
		
		#1;
		clock = ~clock;
		#10;
		clock = ~clock;
		#10;
		
		operation='b000100;
		rd=2;
		rt=0;
		rs=1;
		special=0;
		instruction={special,rs,rt,rd,zeros,operation}; // SLLV: r2 = r0 << r1 (desplazo 650 tres lugares a la izq)
		#1;
		      clock = ~clock;
		#10;
		      clock = ~clock;
		#10;
		      clock = ~clock;
		#10;
		      clock = ~clock;
		#10;
		      clock = ~clock;
		#10;
		      clock = ~clock;
		#10;
		      clock = ~clock;
		#10;
		      clock = ~clock;
		#10;
		      clock = ~clock;
		#10;
		      clock = ~clock;
		#10;
		      clock = ~clock;
		#10;
		      clock = ~clock;
	// Add stimulus here

	end
      
endmodule


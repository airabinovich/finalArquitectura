`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:24:06 11/20/2015
// Design Name:   Datapath1
// Module Name:   C:/Users/Juanjo/Documents/Juanjo/Facu/Arquitectura/Trabajo Final/finalArquitectura/TestDatapathPart1/DatapathPart1/Datapath-wo-Risks-wo-instrMem-Test.v
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

module DatapathTest;

	// Inputs
	reg clock;
	reg [31:0] instruction;
	reg resetGral;

	// Outputs
	wire [7:0] fetchOut;
	wire ALUzero;
	wire ALUOverflow;
	wire [4:0] rsEXOut;
	
	// Aux Regs
	reg [5:0]special=0;
	reg [4:0]rt=0;
	reg [4:0]rs=0;
	reg [15:0]immediate=0;
	reg [15:0]offset=0;
	reg [5:0]operation=0;
	reg [4:0]rd=0;
	reg [4:0]sa=0;
	reg [4:0]zeros=0;
	reg [4:0]base=0;
	// Instantiate the Unit Under Test (UUT)
	Datapath1 uut (
		.clock(clock), 
		.instruction(instruction), 
		.resetGral(resetGral), 
		.fetchOut(fetchOut), 
		.ALUzero(ALUzero), 
		.ALUOverflow(ALUOverflow), 
		.rsEXOut(rsEXOut)
	);

	initial begin
		// Initialize Inputs
		clock = 0;
		instruction = 0;
		resetGral = 1;

		// Wait 100 ns for global reset to finish
		#100;
      resetGral = 0;
		// Add stimulus here

	end
	
	always begin
		clock=~clock;
		case(fetchOut)
			0:begin
					special=6'b001000;
					rt=0;
					rs=2;
					immediate=650;
					instruction={special,rs,rt,immediate};//sumo un valor inmediato de 650 al r2(esta en 0) y lo guardo en r0
			  end
			1:begin
					special=6'b001000;
					rt=1;
					rs=2;
					immediate=3;
					instruction={special,rs,rt,immediate};//sumo un valor inmediato de 3 al r2(esta en 0) y lo guardo en r1
			  end
			2:begin
					operation='b000100;
					rd=2;
					rt=0;
					rs=1;
					special=0;
					instruction={special,rs,rt,rd,zeros,operation}; // SLLV: r2 = r0 << r1 (desplazo 650 tres lugares a la izq)
			  end
			default: begin
					special=6'b001000;
					rt=1;
					rs=1;
					immediate=1;
					instruction={special,rs,rt,immediate};//sumo un valor inmediato de 1 al r1 y lo guardo en r1
			end
			7:begin
					special=6'b101000; //Store byte en direccion 5 del reg 0
					base=5;
					rt=0;
					offset=0;
					instruction={special,base,rt,offset};
			end
			15:begin
					special=6'b100000; //Load byte de direccion 5 al reg 6
					base=5;
					rt=6;
					offset=0;
					instruction={special,base,rt,offset};
			end
		endcase
		#1;
	end
      
endmodule


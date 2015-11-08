`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:28:24 11/07/2015 
// Design Name: 
// Module Name:    REGBANK_banco 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module REGBANK_banco #(parameter addr_bits=5, word_wide=32)(
	input clock,
	input read_enable,
	input write_enable,
	input [addr_bits-1:0] addr_bus,
	inout [word_wide-1:0] data_bus
);
	/* bank_depth = 2^(addr_bits)
		el banco tiene la profundidad máxima que se puede direccionar
	*/
	localparam bank_depth = 1 << addr_bits;

	wire [bank_depth-1:0] read_enable_bus;
	wire [bank_depth-1:0] write_enable_bus;
	
	/*	genero un demultiplexor de tantos bits de selección como ancho del bus de dirección.
		Este demultiplexor se va a encargar de asignar el read_enable para el registro que corresponda
	*/
	REGBANK_demux #(.select_bits(addr_bits)) read_enable_addresser(
		.in(read_enable),
		.select(addr_bus),
		.out(read_enable_bus)
	);
	
	/*	genero un demultiplexor de tantos bits de selección como ancho del bus de dirección.
		Este demultiplexor se va a encargar de asignar el write_enable para el registro que corresponda
	*/
	REGBANK_demux #(.select_bits(addr_bits)) write_enable_addresser(
		.in(write_enable),
		.select(addr_bus),
		.out(write_enable_bus)
	);
	
	/* array de registros de tamaño parametrizado
		llega clock a todos los registros, lo que se reparte es el read y write_enable con los demultiplexores
	*/
	REGBANK_registro #(.bits_wide(word_wide)) banco_bank[bank_depth-1:0](
		.clock(clock),
		.write_enable(write_enable_bus),
		.read_enable(read_enable_bus),
		.data_in(data_bus),
		.data_out(data_bus)
	);

endmodule

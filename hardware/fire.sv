parameter nbits = 7; //note this is actually the precision in bits + 1 (includes zero)
//^note this is only in this file. make sure to change ram file and testbench if you change this value!

module fire(
	input logic reset, Clk, 
	input logic ld_MAC, ld_output //these are control signals, currently i'm sending from testbench
	//if this module was a part of a large nn there could be signals here indicating where it is, when to run, etc.
);

logic [7:0] output_buffer [4*4*256]; //replaced by output ram
logic [7:0] in_ram_out, w_ram_out, out_activation; //inputRAM and weightRAM output wires, outputRams input wire
logic [11:0] out_ram_addr;
logic [9:0] in_ram_addr, w_ram_addr;

assign in_ram_addr = 10'd3, w_ram_addr = 10'd4, out_ram_addr = 12'd2; //just assigned for testing purposes
input_RAM inRAM(.addr(in_ram_addr),.data(in_ram_out));
weight_RAM wRAM(.addr(w_ram_addr),.data(w_ram_out));
output_RAM outRAM(.addr(out_ram_addr), .data_in(out_activation), .ld(ld_output),.*);


//here we should be doing 3*4 = 12
PE PE1(.in_input(in_ram_out), .in_weight(w_ram_out), .out_activation(out_activation), .ld_MAC(ld_MAC),.*);

endmodule


module PE(
	input [nbits:0] in_input, in_weight,
	input logic Clk, reset, ld_MAC,
	output [nbits:0] out_activation);
logic [nbits:0] out_MAC, mult_out, add_out;
multiply m(in_weight, in_input, mult_out);
add a(mult_out, out_MAC, add_out);
register hold_MAC(.data_in(add_out), .data_out(out_MAC), .ld(ld_MAC), .*); //to initialize to zero hit reset
RELU activation(out_MAC, out_activation);
endmodule

module RELU(
	input [nbits:0] in,
	output [nbits:0] out );
assign out = ( in  & (1 << nbits)) ? 0 : in; //if in is negative = 0, else it's just in
endmodule

module add(
	input logic [nbits:0] a, b,
	output logic[nbits:0] result);
assign result = a + b;//(real'(a) + real'(b));
endmodule

module multiply(
	input logic [nbits:0] a,b,
	output logic [nbits:0] result);
assign result = a*b;//(real'(a) * real'(b));
endmodule

module register(
	input logic[nbits:0] data_in,
	input logic ld, reset, Clk,
	output logic[nbits:0] data_out);
always_ff @(posedge Clk)
begin
	if (reset)
		data_out <=0;
	else if(ld==1'b1)
		data_out <= data_in;
	else
		data_out <= data_out;
end
endmodule 
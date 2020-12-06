parameter nbits = 8; //note this is actually the precision in bits + 1 (includes zero)
module fire(
	input logic reset, Clk
	//if this module was a part of a large nn there could be signals here indicating where it is, when to run, etc.
);

endmodule


module PE(
	input [nbits:0] in_input, in_weight,
	input logic Clk, reset, ld_input,
	output [nbits:0] out_activation);
logic [nbits:0] out_MAC;
register hold_MAC(.data_in(in), .data_out(out_MAC;), .ld(ld_input), .*);
endmodule

module RELU(
	input [nbits:0] in,
	output [nbits:0] out );
assign out = ( ~in  & (1 << nbits)) ? 0 : in; //if in is negative = 0, else it's just in
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
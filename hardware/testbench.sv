parameter nbits = 256;

module testbench();
timeunit 10ns;
timeprecision 1ns;

logic reset, Clk, ld_MAC, ld_output;


always begin : CLOCK_GENERATION
 
 #1 Clk = ~Clk;

end
 
initial begin : CLOCK_INITIALIZATION
	Clk = 0;
end

fire f(.*);

logic [7:0] in_weight[9];
logic [7:0] in_input[9];//in_ram_out[9];
logic [9:0] in_ram_addr, w_ram_addr;
logic [nbits:0] bias3x3= 8'd2,PE_added;
logic [nbits:0] out_PE[9];

input_RAM inRAM(.addr(in_ram_addr),.data(in_input));
weight_RAM wRAM(.addr(w_ram_addr),.data(w_ram_out));
assign in_weight[0] = w_ram_out, in_weight[1]=w_ram_out, in_weight[2]=w_ram_out, 
in_weight[3]=w_ram_out, in_weight[4]=w_ram_out,in_weight[5]=w_ram_out, in_weight[6]=w_ram_out,
in_weight[7]=w_ram_out, in_weight[8]=w_ram_out;

initial begin : TEST_VECTORS

#2 reset = 0; ld_MAC = 0; ld_output = 0;
#2 reset = 1;
#2 reset = 0;

//1 channel 1x1
#2 in_ram_addr = 0; w_ram_addr = 1;

for(int i =0; i<9; i++) begin
	#2 in_ram_addr = i*9;
	#2 ld_MAC = 1;
	#2 ld_MAC = 0;

	#2 ld_output = 1;
	#2 ld_output = 0;

	#2 reset = 1; //clear the MAC
	#2 reset = 0;
end




end

endmodule
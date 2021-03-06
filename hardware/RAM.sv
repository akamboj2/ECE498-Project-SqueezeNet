module input_RAM( //read only
	input [9:0] addr,
	output [7:0] data [9]);

	
	parameter ADDR_WIDTH = 10;
  	parameter DATA_WIDTH =  8;
	logic [ADDR_WIDTH-1:0] addr_reg;
				
	// RAM definition				
	logic [DATA_WIDTH-1:0] RAM[0:2**ADDR_WIDTH-1];

	initial
	begin
		 $readmemh("C:/Users/Abhi Kamboj/ECE498-Project-SqueezeNet/hardware/ram_in3x3.txt", RAM);
	end

	assign data = '{RAM[addr], RAM[addr+1], RAM[addr+2], RAM[addr+3], 
			RAM[addr+4], RAM[addr+5], RAM[addr+6], RAM[addr+7], RAM[addr+8]};

endmodule  

//TODO: switch txtfile to have weights
module weight_RAM( //read only
	input [9:0] addr,
	output [7:0] data);

	
	parameter ADDR_WIDTH = 10;
  	parameter DATA_WIDTH =  8;
	logic [ADDR_WIDTH-1:0] addr_reg [2**ADDR_WIDTH-1:0];
				
	// RAM definition				
	logic [DATA_WIDTH-1:0] RAM[0:2**ADDR_WIDTH-1];

	initial
	begin
		$readmemh("C:/Users/Abhi Kamboj/ECE498-Project-SqueezeNet/hardware/ram.txt", RAM);
	end

	assign data = RAM[addr];

endmodule  

module output_RAM( //writes only
	input logic [11:0] addr, 
	input logic [7:0]data_in,
	input logic Clk, reset, ld);

	parameter ADDR_WIDTH = 2;
  	parameter DATA_WIDTH =  8;
	logic [ADDR_WIDTH-1:0] addr_reg;

	// RAM definition				
	logic [DATA_WIDTH-1:0] RAM[0:2**ADDR_WIDTH-1];

always_ff @(posedge Clk)
begin
	if (reset)
		for (integer i=0; i<2**ADDR_WIDTH; i++)
      			RAM[i] <=  {DATA_WIDTH{1'b0}};
	else if(ld==1'b1)
		RAM[addr] <= data_in;
end
endmodule 


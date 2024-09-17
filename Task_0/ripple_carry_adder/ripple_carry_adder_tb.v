// Test bench to test out the 2-bit ripple carry adder

module ripple_carry_adder_tb;

	reg [0:1] A, B;
	reg C_in;
	wire [0:1] Sum;
	wire C_out;
	
	ripple_carry_adder uut(
		
		.in_1(A),
		.in_2(B),
		.c_in(C_in),
		.sum(Sum),
		.c_out(C_out)
	);
	
	initial begin
	
		A = 2'b00; B = 2'b10; C_in = 1'b1; #100;
		A = 2'b01; B = 2'b10; C_in = 1'b1; #100;
		A = 2'b10; B = 2'b11; C_in = 1'b0; #100;
		A = 2'b11; B = 2'b10; C_in = 1'b1; #100;
		A = 2'b00; B = 2'b11; C_in = 1'b0; #100;
	
	end

endmodule
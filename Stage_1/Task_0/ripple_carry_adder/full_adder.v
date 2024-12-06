// Module: Full Adder
// Inputs: A, B, Cin
// Outputs: Cout, Sum

module full_adder( in_1, in_2, c_in, sum, c_out);

	input in_1, in_2, c_in;
	output sum, c_out;
	
	assign sum = in_1 ^ in_2 ^ c_in;
	assign c_out = (in_1 & in_2) + (c_in*(in_1 ^ in_2));

endmodule
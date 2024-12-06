// Sequence Detector Testbench

module sequence_detector_tb;

	reg clock = 1;
	reg [3:0] number;
	
	wire pattern;
	
	sequence_detector uut(
						.clock(clock),
						.number(number),
						.pattern(pattern)
	);
	
	always begin
	
		clock = ~clock; #25;
	
	end
	
	initial begin
	
		number = 4'b0000; #75;
		number = 4'b0101; #75;
		number = 4'b0001; #75;
		number = 4'b0000; #75;
		number = 4'b0001; #75;
		number = 4'b0000; #75;
		number = 4'b1001; #75;
		number = 4'b0100; #75;
		number = 4'b0100; #75;
		$finish;
	
	end

endmodule
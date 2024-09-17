// Test bench module to check the working of traffic light controller.

module traffic_light_controller_tb;

	reg clk = 0;
	wire R, Y, G;
	
	traffic_light_controller uut(
	
		.clk(clk),
		.red(R),
		.yellow(Y),
		.green(G)
	);
	
	always begin
	
		clk = ~clk; #10000;
	
	end

endmodule
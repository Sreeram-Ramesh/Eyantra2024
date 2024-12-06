// EcoMender Bot : Task 1A : PWM Generator
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design a module which will scale down the 1MHz Clock Frequency to 500Hz and perform Pulse Width Modulation on it.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//PWM Generator
//Inputs : clk_1MHz, pulse_width
//Output : clk_500Hz, pwm_signal

module pwm_generator(
    input clk_1MHz,
    input [3:0] pulse_width,
    output reg clk_500Hz, pwm_signal
);

initial begin
    clk_500Hz = 1; pwm_signal = 1;
end

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

reg [9:0] counter = 0;
reg [1:0] twice_counter = 0;
reg [4:0] pwm_counter = 1;
reg [6:0] pwm_clock = 0;

always @(posedge clk_1MHz) begin

	if (counter == 10'b1111101000) begin
	
		clk_500Hz = ~clk_500Hz;
		counter = 0;
		twice_counter = twice_counter + 1;
	
	end
	
	if (twice_counter == 2'b10) begin // Runs every 200 us to reset.
	
		pwm_signal = 1;
		pwm_counter = 0;
		twice_counter = 0;
	
	end
	
	if (pwm_clock == 7'b1100100) begin // Runs every 100 us to compare with the pulse width.
	
		if (pwm_counter == pulse_width) begin
		
			pwm_signal = 0;
		
		end
		
		pwm_counter = pwm_counter + 1;
		pwm_clock = 0;
	
	end
	
	pwm_clock = pwm_clock + 1;
	counter = counter + 1;

end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule

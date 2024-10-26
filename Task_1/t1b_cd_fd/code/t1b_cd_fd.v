// EcoMender Bot : Task 1B : Color Detection using State Machines
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design a module which will detect colors red, green, and blue using state machine and frequency detection.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//Color Detection
//Inputs : clk_1MHz, cs_out
//Output : filter, color

// Module Declaration
module t1b_cd_fd (
    input  clk_1MHz, cs_out,
    output reg [1:0] filter, color
);

// red   -> color = 1;
// green -> color = 2;
// blue  -> color = 3;

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////

reg [8:0] counter = 0;
reg [4:0] frequency = 0;
reg [4:0] prev_frequency = 0;
reg [1:0] prev_color = 0;

parameter RED_FILTER = 0, BLUE_FILTER = 1, CLEAR_FILTER = 2, GREEN_FILTER = 3;
parameter RED_COLOR = 1, BLUE_COLOR = 3, CLEAR_COLOR = 0, GREEN_COLOR = 2;  

initial begin // editing this initial block is allowed
    
	 filter = GREEN_FILTER; 
	 color = CLEAR_COLOR;
	 
end

always @(posedge cs_out) begin
	
	if (counter == 100 && clk_1MHz == 1 && frequency < 31) begin
	
		frequency = frequency + 1;
	
	end
	
	if (counter == 500) begin
	
		if (prev_frequency < frequency) begin
		
			case (filter)
		
				RED_FILTER: prev_color = RED_COLOR;
				BLUE_FILTER: prev_color = BLUE_COLOR;
				GREEN_FILTER: prev_color = GREEN_COLOR;
		
			endcase
			
			prev_frequency = frequency;
			
		end
		
		frequency = 0;
	
	end
	
	if (filter == CLEAR_FILTER) prev_frequency = 0;

end

always @(posedge clk_1MHz) begin

	if (counter == 500) begin
	
		case (filter)
		
			RED_FILTER: filter = BLUE_FILTER;
			BLUE_FILTER: begin
				filter = CLEAR_FILTER;
				color = prev_color;
			end
			GREEN_FILTER: filter = RED_FILTER;
		
		endcase
		
		counter = 0;
	
	end
	
	if (counter == 1 && filter == CLEAR_FILTER) begin
	
		filter = GREEN_FILTER;
		counter = 0;
	
	end
	
	counter = counter + 1;

end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule

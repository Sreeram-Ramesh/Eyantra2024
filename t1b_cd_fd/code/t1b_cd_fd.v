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
reg [14:0] cs_counter, csf_counter = 0;
reg [1:0] pcolor; // temporary register to store previous color.

initial begin // editing this initial block is allowed
    
	 filter = 3; 
	 color = 0;
	 pcolor = 0;
	 
end

always @(posedge clk_1MHz) begin

	if (counter == 500) begin
	
		case (filter)
			
			3: begin
				filter = 0;
			end
				
			0: begin
				filter = 1;
			end
				
			1: begin
				color = pcolor;
				filter = 2;
			end
				
			default;
			
		endcase
		
		counter = 0;
		
	end
	
	if (filter == 2 && counter == 1) begin
		
		filter = 3;
		counter = 0;

	end
		
	counter = counter + 1;

end

always @(posedge cs_out) begin

	if (counter == 500) begin
	
		if (csf_counter < cs_counter) begin
		
			csf_counter = cs_counter;
			
			case (filter)
		
				0: pcolor = 1;
				1: pcolor = 3;
				3: pcolor = 2;
				default;
		
			endcase
		
		end
		
		cs_counter = 0;
	
	end
	
	if (filter == 2) begin
	
		csf_counter = 0;
	
	end
	
	cs_counter = cs_counter + 1;

end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule

//Color Detection
//Inputs : clk_1MHz, cs_out
//Output : filter, cs_scaler

module cs_freq_monitor (
    input  clk_1MHz, cs_out,
    output reg [1:0] filter, cs_scaler,
	output reg [31:0] blue_frequency
);

// red   -> color = 1;
// green -> color = 2;
// blue  -> color = 3;

// red filter: S2 - 0, S3 - 0
// blue filter: S2 - 0, S3 - 1
// clear filter: S2 - 1, S3 - 0
// green filter: S2 - 1, S3 - 1

reg [8:0] counter;

parameter RED_FILTER = 0, BLUE_FILTER = 1, CLEAR_FILTER = 2, GREEN_FILTER = 3; 

initial begin // editing this initial block is allowed
    
	 filter = BLUE_FILTER; 
	 cs_scaler = 3;
	 blue_frequency = 0;
	 counter = 0;
	 
end

always @(posedge cs_out) begin
	
	if (counter <= 510) begin
		
		blue_frequency = blue_frequency + 1;
	
	end

end

always @(posedge clk_1MHz) begin
	
	if (counter <= 510) begin
		counter = counter + 1;
	end

end

endmodule
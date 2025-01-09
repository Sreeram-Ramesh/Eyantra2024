//Color detection and led color controller
//Inputs : clk_1MHz, cs_out
//Output : filter, cs_scaler

// red   -> color = 1;
// green -> color = 2;
// blue  -> color = 3;

// red filter: S2 - 0, S3 - 0
// blue filter: S2 - 0, S3 - 1
// clear filter: S2 - 1, S3 - 0
// green filter: S2 - 1, S3 - 1

// power down: S0 - 0, S1 - 0
// 2% scaling: S0 - 0, S1 - 1
// 20% scaling: S0 - 1, S1 - 0
// 100% scaling: S0 - 1, S1 - 1

module led_controller(
    input  clk_1MHz, cs_out,
    output reg [1:0] filter, cs_scaler,
    output reg [1:0] color
);

reg [8:0] counter;
reg [3:0] red_frequency, blue_frequency;
reg [3:0] green_frequency;
reg clear_color;

parameter RED_FILTER = 0, BLUE_FILTER = 1, CLEAR_FILTER = 2, GREEN_FILTER = 3;
parameter RED_COLOR = 1, BLUE_COLOR = 3, CLEAR_COLOR = 0, GREEN_COLOR = 2;

initial begin
    filter = GREEN_FILTER;
    cs_scaler = 3;
    color = CLEAR_COLOR;
    counter = 0;
    red_frequency = 0;
    blue_frequency = 0;
    green_frequency = 0;
    clear_color = 0;

end

always @(posedge cs_out) begin
    if (counter <= 510) begin
        case (filter)

            RED_FILTER: red_frequency = red_frequency + 1;
            BLUE_FILTER: blue_frequency = blue_frequency + 1;
            GREEN_FILTER: green_frequency = green_frequency + 1;
            default;

        endcase
    end

    if (clear_color && counter == 0) begin
        blue_frequency = 0;
        green_frequency = 0;
        red_frequency = 0;
    end
end

always @(posedge clk_1MHz) begin
    if (counter == 511) begin
        case (filter)
		
			RED_FILTER: filter = BLUE_FILTER;
			BLUE_FILTER: filter = CLEAR_FILTER;
			GREEN_FILTER: filter = RED_FILTER;
            default;
		
		endcase
		
		counter = 0;
    end

    if (filter == CLEAR_FILTER && counter == 1) begin
        if (blue_frequency >= 15 && blue_frequency <= 40) begin
            if (blue_frequency > green_frequency && blue_frequency > red_frequency) begin
                color = BLUE_COLOR;
            end
        end
        else if (green_frequency >= 20 && green_frequency <= 40) begin
            if (green_frequency > blue_frequency && green_frequency > red_frequency) begin
                color = GREEN_COLOR;
            end
        end
        else if (red_frequency >= 15 && red_frequency <= 50) begin
            if (red_frequency > blue_frequency && red_frequency > green_frequency) begin
                color = RED_COLOR;
            end
        end

        filter = GREEN_FILTER;
        counter = 0;
        clear_color = 1;
    end

    counter = counter + 1;

end

endmodule
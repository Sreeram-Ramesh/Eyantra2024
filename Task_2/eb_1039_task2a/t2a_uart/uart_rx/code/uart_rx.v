// EcoMender Bot : Task 2A - UART Receiver
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.

This file is used to receive UART Rx data packet from receiver line and then update the rx_msg and rx_complete data lines.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

/*
Module UART Receiver

Baudrate: 230400 

Input:  clk_3125 - 3125 KHz clock
        rx      - UART Receiver

Output: rx_msg - received input message of 8-bit width
        rx_parity - received parity bit
        rx_complete - successful uart packet processed signal
*/

// module declaration
module uart_rx(
    input clk_3125,
    input rx,
    output reg [7:0] rx_msg,
    output reg rx_parity,
    output reg rx_complete
    );

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

reg [3:0] state = 4'b0000;
reg [3:0]     counter = 0;
reg [7:0] rx_prev_msg = 0;
reg    rx_prev_parity = 0;
reg  	   rx_used_here = 0;


parameter START = 4'b0000, BIT0 = 4'b0001, BIT1 = 4'b0010, BIT2 = 4'b0011, BIT3 = 4'b0100, BIT4 = 4'b0101, BIT5 = 4'b0110, BIT6 = 4'b0111, BIT7 = 4'b1000, PARITY = 4'b1001, STOP = 4'b1010;

initial begin
         rx_msg = 0;
	   rx_parity = 0;
    rx_complete = 0;
end

always @(posedge clk_3125) begin	
    if (counter == 14) begin
        case (state)
            START:                                                  				state = BIT0;
            BIT0:                  {state, rx_prev_msg} = {BIT1, rx_used_here, 7'b0000000};
            BIT1:   {state, rx_prev_msg} = {BIT2, rx_prev_msg[7], rx_used_here, 6'b000000};
            BIT2:  {state, rx_prev_msg} = {BIT3, rx_prev_msg[7:6], rx_used_here, 5'b00000};
            BIT3:   {state, rx_prev_msg} = {BIT4, rx_prev_msg[7:5], rx_used_here, 4'b0000};
            BIT4:    {state, rx_prev_msg} = {BIT5, rx_prev_msg[7:4], rx_used_here, 3'b000};
            BIT5:     {state, rx_prev_msg} = {BIT6, rx_prev_msg[7:3], rx_used_here, 2'b00};
            BIT6:      {state, rx_prev_msg} = {BIT7, rx_prev_msg[7:2], rx_used_here, 1'b0};
            BIT7:          {state, rx_prev_msg} = {PARITY, rx_prev_msg[7:1], rx_used_here};
            PARITY:                         {state, rx_prev_parity} = {STOP, rx_used_here};
            STOP:  begin
                       {state, rx_parity, rx_complete} = {4'bzzzz, rx_prev_parity, 1'b1};
                rx_msg = (rx_prev_parity === (^rx_prev_msg)?1'b1:1'b0)?rx_prev_msg:8'h3F;
            end
            default;
        endcase
        counter = 0;
    end
    counter <= counter + 1;
	 rx_used_here      = rx;
    if (state === 4'bzzzz && rx == 1'b0) {state, rx_complete} = {START, 1'b0};
end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////


endmodule


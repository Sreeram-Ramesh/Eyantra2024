// EcoMender Bot : Task 2A - UART Transmitter
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.

This file is used to generate UART Tx data packet to transmit the messages based on the input data.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

/*
Module UART Transmitter

Input:  clk_3125 - 3125 KHz clock
        parity_type - even(0)/odd(1) parity type
        tx_start - signal to start the communication.
        data    - 8-bit data line to transmit

Output: tx      - UART Transmission Line
        tx_done - message transmitted flag
*/

// module declaration
module uart_tx(
    input clk_3125,
    input parity_type,tx_start,
    input [7:0] data,
    output reg tx, tx_done
);

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

reg [3:0] state;
reg [3:0] counter = 14;

initial begin
    tx      = 1;
    tx_done = 0;
end

parameter START = 4'b0000, BIT0 = 4'b0001, BIT1 = 4'b0010, BIT2 = 4'b0011, BIT3 = 4'b0100, BIT4 = 4'b0101, BIT5 = 4'b0110, BIT6 = 4'b0111, BIT7 = 4'b1000, PARITY = 4'b1001, STOP = 4'b1010; 

always @(posedge clk_3125) begin
    if (counter == 14) begin
        case (state)
            START:                                                                          {tx, state} = {data[7], BIT0};
            BIT0:                                                                           {tx, state} = {data[6], BIT1};
            BIT1:                                                                           {tx, state} = {data[5], BIT2};
            BIT2:                                                                           {tx, state} = {data[4], BIT3};
            BIT3:                                                                           {tx, state} = {data[3], BIT4};
            BIT4:                                                                           {tx, state} = {data[2], BIT5};
            BIT5:                                                                           {tx, state} = {data[1], BIT6};
            BIT6:                                                                           {tx, state} = {data[0], BIT7};
            BIT7:                                                                           {tx, state} = {^data, PARITY};
            PARITY:                                                                            {tx, state} = {1'b1, STOP};
            STOP:                                                            {tx, tx_done, state} = {1'b1, 1'b0, 4'bzzzz};
            default;
        endcase
        counter = 0;
    end
    if (tx_start == 1)        {state, tx, tx_done, counter} = {START, 6'b000000};
    if (tx == 1'b1 && state === 4'bzzzz && counter == 2) {tx, counter} = 5'b00000;
    if (counter == 13 && state == STOP)                           tx_done = 1'b1;
    counter = counter + 1;
end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule

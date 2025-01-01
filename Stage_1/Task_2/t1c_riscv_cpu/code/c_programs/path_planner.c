/*
* EcoMender Bot (EB): Task 2B Path Planner
*
* This program computes the valid path from the start point to the end point.
* Make sure you don't change anything outside the "Add your code here" section.
*/

#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>
#include <limits.h>
#define V 32

#ifdef linux // for host pc

    #include <stdio.h>

    void _put_byte(char c) { putchar(c); }

    void _put_str(char *str) {
        while (*str) {
            _put_byte(*str++);
        }
    }

    void print_output(uint8_t num) {
        if (num == 0) {
            putchar('0'); // if the number is 0, directly print '0'
            _put_byte('\n');
            return;
        }

        if (num < 0) {
            putchar('-'); // print the negative sign for negative numbers
            num = -num;   // make the number positive for easier processing
        }

        // convert the integer to a string
        char buffer[20]; // assuming a 32-bit integer, the maximum number of digits is 10 (plus sign and null terminator)
        uint8_t index = 0;

        while (num > 0) {
            buffer[index++] = '0' + num % 10; // convert the last digit to its character representation
            num /= 10;                        // move to the next digit
        }
        // print the characters in reverse order (from right to left)
        while (index > 0) { putchar(buffer[--index]); }
        _put_byte('\n');
    }

    void _put_value(uint8_t val) { print_output(val); }

#else  // for the test device

    void _put_value(uint8_t val) { }
    void _put_str(char *str) { }

#endif

// main function
int main(int argc, char const *argv[]) {

    #ifdef linux

        const uint8_t START_POINT   = atoi(argv[1]);
        const uint8_t END_POINT     = atoi(argv[2]);
        uint8_t NODE_POINT          = 0;
        uint8_t CPU_DONE            = 0;

    #else
        // Address value of variables for RISC-V Implementation
        #define START_POINT         (* (volatile uint8_t * ) 0x02000000)
        #define END_POINT           (* (volatile uint8_t * ) 0x02000004)
        #define NODE_POINT          (* (volatile uint8_t * ) 0x02000008)
        #define CPU_DONE            (* (volatile uint8_t * ) 0x0200000c)

    #endif

    // array to store the planned path
    uint8_t path_planned[V];
    // index to keep track of the path_planned array
    uint8_t idx = 0;



    /* Functions Usage

    instead of using printf() function for debugging,
    use the below function calls to print a number, string or a newline

    for newline: _put_byte('\n');
    for string:  _put_str("your string here");
    for number:  _put_value(your_number_here);

    Examples:
            _put_value(START_POINT);
            _put_value(END_POINT);
            _put_str("Hello World!");
            _put_byte('\n');
    */

    // ############# Add your code here #############
    // prefer declaring variable like this

    #ifdef linux
        uint32_t graph[V];
        uint32_t visited = 0;        // 32-bit visited array (1 bit per node) 1 byte
        uint8_t parent[V];           // To track parent for path reconstruction
        uint8_t path[V];
        uint8_t path_index = 0;

    #else
        uint32_t *graph = (uint32_t *) 0x02000010;
        uint8_t *parent = (uint8_t *) 0x02000094;
        uint8_t *path =   (uint8_t *) 0x020000B4;
        
        #define visited     (* (volatile uint32_t * ) 0x02000090)
        #define path_index   (* (volatile uint8_t * ) 0x020000D4)

    #endif

    graph[ 0] = 0x42200000;
    graph[ 1] = 0xA0100000;
    graph[ 2] = 0x5C000000;
    graph[ 3] = 0x20000000;
    graph[ 4] = 0x20000000;
    graph[ 5] = 0x20000000;
    graph[ 6] = 0x81C00000;
    graph[ 7] = 0x02000000;
    graph[ 8] = 0x02000000;
    graph[ 9] = 0x02000000;
    graph[10] = 0x801000A0;
    graph[11] = 0x40281000;
    graph[12] = 0x00160000;
    graph[13] = 0x00080000;
    graph[14] = 0x00098000;
    graph[15] = 0x00020000;
    graph[16] = 0x00026000;
    graph[17] = 0x00008000;
    graph[18] = 0x00009400;
    graph[19] = 0x00102800;
    graph[20] = 0x00001000;
    graph[21] = 0x00002300;
    graph[22] = 0x00000400;
    graph[23] = 0x00000482;
    graph[24] = 0x00200140;
    graph[25] = 0x00000080;
    graph[26] = 0x00200018;
    graph[27] = 0x00000020;
    graph[28] = 0x00000026;
    graph[29] = 0x00000008;
    graph[30] = 0x00000109;
    graph[31] = 0x00000002;

    visited = 0;
    for (int i = 0; i < V; i++) parent[i] = 255; // Initialize parent array with 255 (indicates no parent)

    visited |= (1 << START_POINT);     // Mark start node as visited
    parent[START_POINT] = START_POINT;       // Start node's parent is itself

    // Iteratively explore nodes
    for (int step = 0; step < V; ++step) {
        for (int node = 0; node < V; ++node) {
            // If node is visited, check its neighbors
            if (visited & (1 << node)) {
                for (int i = 0; i < V; ++i) {
                    if (((graph[node] & (1 << (V - 1 -i))) ? 1 : 0) && !(visited & (1 << i))) {
                        visited |= (1 << i);   // Mark neighbor as visited
                        parent[i] = node;      // Record parent
                        if (i == END_POINT)  // Stop if destination is reached
                            goto reconstruct;
                    }
                }
            }
        }
    }

    reconstruct:
    if (!(visited & (1 << END_POINT))) {
        return 0;
    }

    // Path reconstruction
    path_index = 0;
    for (int node = END_POINT; node != START_POINT; node = parent[node]) {
        path[path_index++] = node;
    }
    path[path_index++] = START_POINT; // Add the start node to the path

    // Print the path in reverse order (from start to destination)
    for (int i = path_index - 1; i >= 0; --i) {
        path_planned[idx] = path[i];
        ++idx;
    }
    // ##############################################

    // the node values are written into data memory sequentially.
    for (int i = 0; i < idx; ++i) {
        NODE_POINT = path_planned[i];
    }
    // Path Planning Computation Done Flag
    CPU_DONE = 1;

    #ifdef linux    // for host pc

        _put_str("######### Planned Path #########\n");
        for (int i = 0; i < idx; ++i) {
            _put_value(path_planned[i]);
        }
        _put_str("################################\n");

    #endif

    return 0;
}
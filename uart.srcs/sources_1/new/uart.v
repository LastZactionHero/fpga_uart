`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2018 12:38:43 AM
// Design Name: 
// Module Name: uart
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart(
    input CLK100MHZ,
    input uart_txd_in,
    input ck_rst,
    output [3:0]led,
    output uart_rxd_out
    );
    parameter baud_clk_div_n = 10416; // 100MHZ / 9600
    reg [13:0]baud_cnt;
    reg uart_clk;
    reg [7:0]xmit_buffer;

    // UART Clock Divider to match baud
    always @(posedge CLK100MHZ) begin
        if(!ck_rst || baud_cnt > baud_clk_div_n) begin
            baud_cnt = 0;
            xmit_buffer = 65; // A
        end
        else
            baud_cnt = baud_cnt + 1;
        
        uart_clk <= baud_cnt == baud_clk_div_n;
    end
    
    // UART xmit state counter, counter to 10
    reg [3:0]xmit_cnt;
    always @(posedge uart_clk, posedge CLK100MHZ) begin
        if(!ck_rst)
            xmit_cnt = 0;
        else if(uart_clk && xmit_cnt == 9)
            xmit_cnt = 0;
        else if(uart_clk)
            xmit_cnt = xmit_cnt + 1;
    end
    
    assign uart_rxd_out = (xmit_cnt == 0) ? 0 :
                          (xmit_cnt == 9) ? 1 :
                          xmit_buffer[xmit_cnt - 1];   
    assign led[0] = ck_rst;
endmodule

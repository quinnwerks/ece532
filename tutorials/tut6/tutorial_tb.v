`timescale 1ns / 1ps

module tb();

    //Wires to connect to DUT
    reg clock, reset;
    wire usb_uart_rxd, usb_uart_txd;
    wire [7:0] led;

    //DUT
    design_1_wrapper dut(
        .sys_clock(clock),
        .reset(reset),
        .usb_uart_rxd(usb_uart_rxd),
        .usb_uart_txd(usb_uart_txd),
        .led(led)
    );
    
    assign usb_uart_rxd = 0;
    
    //Reset signal
    initial begin
        reset = 0;
        #40 reset = 1;
    end
    
    //Clock signal
    initial clock = 0;
    always begin
        #2 clock = ~clock;
    end

endmodule
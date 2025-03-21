`timescale 1ns/1ps

module led_blinker (
    input clk,             
    input reset,              
    input door_open,     
    input full_parking,       
    output reg door_open_led, 
    output reg full_led      
);

    parameter CLK_FREQ = 40_000_000;  // 40 MHz clock frequency
    parameter HALF_SEC = CLK_FREQ / 2; // 0.5 seconds for 2 Hz blinking
    parameter ONE_SEC = CLK_FREQ;      // 1 second interval

    reg [31:0] clk_counter;
    reg [4:0] toggle_counter;
    reg door_blinking, full_blinking;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            clk_counter <= 0;
            toggle_counter <= 0;
            door_open_led <= 0;
            full_led <= 0;
            door_blinking <= 0;
            full_blinking <= 0;
        end else begin
            if (door_open && !full_parking) begin
                door_blinking <= 1;
                full_blinking <= 0;
                toggle_counter <= 0;
            end else if (full_parking) begin
                full_blinking <= 1;
                door_blinking <= 0;
                toggle_counter <= 0;
            end

            if (door_blinking) begin
                if (clk_counter == HALF_SEC - 1) begin
                    clk_counter <= 0;
                    door_open_led <= ~door_open_led; // Toggle LED
                    toggle_counter <= toggle_counter + 1;
                    if (toggle_counter == 20) begin // 10 seconds (20 toggles)
                        door_blinking <= 0;
                        door_open_led <= 0;
                    end
                end else begin
                    clk_counter <= clk_counter + 1;
                end
            end else if (full_blinking) begin
                if (clk_counter == ONE_SEC - 1) begin
                    clk_counter <= 0;
                    full_led <= ~full_led;
                    toggle_counter <= toggle_counter + 1;
                    if (toggle_counter == 6) begin 
                        full_blinking <= 0;
                        full_led <= 0;
                    end
                end else begin
                    clk_counter <= clk_counter + 1;
                end
            end else begin
                clk_counter <= 0;
            end
        end
    end

endmodule

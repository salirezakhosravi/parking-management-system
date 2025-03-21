`timescale 1ns/1ps

module parking_timer (
    input clk,           
    input reset,              
    input parking_state, 
    output reg signal,     
    output reg [15:0] parking_timer    
);

    reg [3:0] seconds_ones;
    reg [3:0] seconds_tenths;
    reg [3:0] minutes_ones;
    reg [3:0] minutes_tenths;
    reg [3:0] hours_ones;  
    reg [3:0] hours_tenths;


    reg [25:0] clk_div;
    wire one_second_pulse = (clk_div == 26'd40_000_000); 

    reg [3:0] additional_seconds;

    signal = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            clk_div <= 0;
        end else if (car_entered && !car_exited) begin
            clk_div <= (one_second_pulse) ? 0 : clk_div + 1;
        end else begin
            clk_div <= 0;
        end
    end

    // Time counting logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            seconds_ones <= 0;
            seconds_tens <= 0;
            minutes_ones <= 0;
            minutes_tens <= 0;
            hours_ones <= 0;
            hours_tens <= 0;
            signal <= 0;
            parking_timer <= 16'b0;
        end else if (parking_state) begin
            if (one_second_pulse) begin
                // Increment seconds
                if (seconds_ones == 4'd9) begin
                    seconds_ones <= 0;
                    if (seconds_tens == 4'd5) begin
                        seconds_tens <= 0;
                        // Increment minutes
                        if (minutes_ones == 4'd9) begin
                            minutes_ones <= 0;
                            if (minutes_tens == 4'd5) begin
                                minutes_tens <= 0;
                                // Increment hours
                                if (hours_ones == 4'd9) begin
                                    hours_ones <= 0;
                                    if (hours_tens == 4'd2) begin
                                        hours_tens <= 0; // Wrap around to 0 after 23:59
                                    end else begin
                                        hours_tens <= hours_tens + 1;
                                    end
                                end else begin
                                    hours_ones <= hours_ones + 1;
                                end
                            end else begin
                                minutes_tens <= minutes_tens + 1;
                            end
                        end else begin
                            minutes_ones <= minutes_ones + 1;
                        end
                    end else begin
                        seconds_tens <= seconds_tens + 1;
                    end
                end else begin
                    seconds_ones <= seconds_ones + 1;
                end

                // Update time output in HHMM BCD format
                parking_timer <= {hours_tens, hours_ones, minutes_tens, minutes_ones};
            end
        end else if (~parking_state) begin
            // Reset time counters when the car exits
            signal <= 1;
            if (one_second_pulse) begin
                additional_seconds <= additional_seconds + 1;
            end
            if(additional_seconds == 15) begin
                seconds_ones <= 0;
                seconds_tens <= 0;
                minutes_ones <= 0;
                minutes_tens <= 0;
                hours_ones <= 0;
                hours_tens <= 0;
                additional_seconds <= 0;
                signal <= 0;
                parking_timer <= 16'b0;
            end
        end
    end

endmodule

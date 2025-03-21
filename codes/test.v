`timescale 1ns/1ps
`include "parking_system_managment (1).v"

module parking_fsm_tb;
    
    reg clk;
    reg reset;
    reg entry_sensor;
    reg exit_sensor;
    reg [1:0] exiting_position;

    wire door_open;
    wire full_led;
    wire [1:0] best_position;
    wire [3:0] parking_spots;
    wire [2:0] capacity;

    parking_system_managment dut (
        .clk(clk),
        .reset(reset),
        .entry_sensor(entry_sensor),
        .exit_sensor(exit_sensor),
        .exiting_position(exiting_position),
        .door_open(door_open),
        .full_led(full_led),
        .best_position(best_position),
        .parking_spots(parking_spots),
        .capacity(capacity)
    );

    always #5 clk = ~clk;

    integer input_file, output_file;
    integer status;
    reg [3:0] input_line;

    initial begin
        clk = 0;
        reset = 1;
        entry_sensor = 0;
        exit_sensor = 0;
        exiting_position = 2'b00;

        input_file = $fopen("input.txt", "r");
        output_file = $fopen("output.txt", "w");

        if (input_file == 0 || output_file == 0) begin
            $display("Error: Could not open input/output files!");
            $finish;
        end

        #20 reset = 0;

        $fwrite(output_file, "ParkingState Display Alarm\n");

        while (!$feof(input_file)) begin
            status = $fscanf(input_file, "%b", input_line); // Read 4-bit input
            if (status != 1) begin
                $display("Error reading input file");
                $finish;
            end
            
            entry_sensor = input_line[3];
            exit_sensor = input_line[2];
            exiting_position = input_line[1:0];

            #10;

            $fwrite(output_file, "%b [%d,%d]\t%s\n",
                    parking_spots,
                    capacity,
                    best_position,
                    (full_led ? "Full" : (door_open ? "Door" : "")));

            $display("Parking: %b | Capacity: %d | BestPos: %d | Alarm: %s", 
                    parking_spots, capacity, best_position,
                     (full_led ? "Full" : (door_open ? "Door" : "")));
        end

        $fclose(input_file);
        $fclose(output_file);
        #50;
        $finish;
    end
endmodule
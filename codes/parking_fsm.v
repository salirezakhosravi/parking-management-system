module parking_system_managment (
    input clk,
    input reset,
    input entry_sensor, 
    input exit_sensor,   
    input [1:0] exiting_position,
    output reg door_open, 
    output reg full_led,
    output reg [1:0] best_position,
    output reg [3:0] parking_spots, 
    output reg [2:0] capacity
);

    reg [2:0] next_state;
    reg [2:0] current_state;

    parameter CAPACITY_0 = 3'b000;
    parameter CAPACITY_1 = 3'b001;
    parameter CAPACITY_2 = 3'b010;
    parameter CAPACITY_3 = 3'b011;
    parameter CAPACITY_4 = 3'b100;

    
    function [1:0] find_best_position(input [3:0] spots);
        begin
            if (!spots[0])
                find_best_position = 2'b00;
            else if (!spots[1])
                find_best_position = 2'b01;
            else if (!spots[2])
                find_best_position = 2'b10;
            else if (!spots[3])
                find_best_position = 2'b11;
            else
                find_best_position = 2'bxx;  
        end
    endfunction


    
    always @(posedge clk) begin
        next_state = current_state;
        door_open = 0;
        full_led = 0;

        case (current_state)
            CAPACITY_4: begin
                if (entry_sensor) begin
                    parking_spots[0] = 1'b1; 
                    next_state = CAPACITY_3; 
                    best_position = find_best_position(parking_spots);
                    door_open = 1;           
                end else if (exit_sensor) begin
                    next_state = CAPACITY_4; 
                    door_open = 0;           
                end else begin
                    next_state = current_state;
                end
            end

            CAPACITY_3: begin
                if (entry_sensor) begin
                    parking_spots[best_position] = 1'b1; 
                    next_state = CAPACITY_2; 
                    best_position = find_best_position(parking_spots);
                    door_open = 1;           
                end else if (exit_sensor) begin
                    if (parking_spots[exiting_position]) begin
                        parking_spots[exiting_position] = 1'b0; 
                        next_state = CAPACITY_4; 
                        best_position = find_best_position(parking_spots);
                        door_open = 1;           
                    end
                end else begin
                    next_state = current_state;
                end
            end

            CAPACITY_2: begin
                if (entry_sensor) begin
                    parking_spots[best_position] = 1'b1;
                    next_state = CAPACITY_1;
                    best_position = find_best_position(parking_spots);
                    door_open = 1; 
                end else if (exit_sensor) begin
                    if (parking_spots[exiting_position]) begin
                        parking_spots[exiting_position] = 1'b0; 
                        next_state = CAPACITY_3; 
                        best_position = find_best_position(parking_spots);
                        door_open = 1;           
                    end
                end else begin
                    next_state = current_state;
                end
            end

            CAPACITY_1: begin
                if (entry_sensor) begin
                    parking_spots[best_position] = 1'b1; 
                    next_state = CAPACITY_0; 
                    best_position = find_best_position(parking_spots);
                    door_open = 1;          
                end else if (exit_sensor) begin
                    if (parking_spots[exiting_position]) begin
                        parking_spots[exiting_position] = 1'b0;
                        next_state = CAPACITY_2; 
                        best_position = find_best_position(parking_spots);
                        door_open = 1;          
                    end
                end else begin
                    next_state = current_state;
                end
            end

            CAPACITY_0: begin
                if (exit_sensor) begin
                    parking_spots[exiting_position] = 1'b0; 
                    next_state = CAPACITY_1; 
                    best_position = find_best_position(parking_spots);
                    door_open = 1;          
                end else if (entry_sensor) begin
                    door_open = 0; 
                    full_led = 1;  
                end else begin
                    next_state = current_state;
                end
            end
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= CAPACITY_4;
            parking_spots <= 4'b0000;    
            best_position <= 2'b00;
            capacity <= 3'b100;
        end else begin
            current_state <= next_state;
            capacity <= next_state;
        end
    end
endmodule

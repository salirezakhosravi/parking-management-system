`include "swich_bounce.v"
`include "parking_fsm.v"
`include "mux_digit.v"
`include "counter.v"
`include "door_module.v"

module parking (
    input clk,
    input reset,
    input exit_sensor,
    input exit_sensor,
    input [1:0] exiting_position,
    output wire door_open, 
    output wire full_led,
    output wire [1:0] best_position,
    output wire [3:0] parking_spots, 
    output wire [2:0] capacity
    output wire [4:0] seg_sel,
    output wire [7:0] seg_data
);

wire [15:0] parking_time0 ,parking_time1, parking_time2, parking_time3;
wire led_door , led_full;
wire exits_db , entrys_db;

debounce_circuit dben (
    .clk(clk),
    .reset(reset),
    .sig(entry_sensor),
    .deb_sig(entrys_db)
);

debounce_circuit dbex (
    .clk(clk),
    .reset(reset),
    .sig(exit_sensor),
    .deb_sig(exits_db)
);

parking_system_managment pfsm (
    .clk(clk),
    .reset(reset,)
    .entry_sensor(entrys_db),
    .exit_sensor(exits_db),
    .exiting_position(exiting_position),
    .door_open(led_door),
    .full_led(led_full),
    .best_position(best_position),
    .parking_spots(parking_spots),
    .capacity(capacity)
);

bcd2seven_seg seg (
    .clk(clk),
    .reset(reset),
    .a({4'b0000, {1'b0,capacity}, 4'b0000, {2'b00, best_position}})
    .SEG_SEL(seg_sel),
    SEG_DATA(seg_data)
);

led_blinker blink (
    .clk(clk),
    .reset(reset),
    .door_open(led_door),
    .full_parking(led_full),
    .door_open_led(door_open),
    .full_led(full_led)
);


    
endmodule
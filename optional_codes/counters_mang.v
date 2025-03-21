`include "counter.v"

module counters_managment (
    input clk,
    input reset,
    input [3:0] parking_spots,
    input [15:0] parking_cb  /// parking capacity and best position
    output reg [15:0] parking_display
);

wire [15:0] parking_time0, parking_time1, parking_time2, parking_time3;
wire signal0, signal1, signal2, signal3;
parking_time = 0;

counter counter0 (
    .clk(clk),
    .reset(reset),
    .parking_state(parking_spots[0]),
    .signal(signal0)
    .parking_timer(parking_time0)
);

counter counter1 (
    .clk(clk),
    .reset(reset),
    .parking_state(parking_spots[1]),
    .signal(signal1),
    .parking_timer(parking_time1)
);

counter counter2 (
    .clk(clk),
    .reset(reset),
    .parking_state(parking_spots[2]),
    .signal(signal2),
    .parking_timer(parking_time2)
);

counter counter3 (
    .clk(clk),
    .reset(reset),
    .parking_state(parking_spots[3]),
    .signal(signal3),
    .parking_timer(parking_time3)
);

always @(posedge clk) begin
    if(reset)begin
        parking_display <= parking_cb;
    end

    if(signal0) begin
        parking_display <= parking_time0;
    end

    else if(signal1) begin
        parking_display <= parking_time1;
    end

    else if(signal2) begin
        parking_display <= parking_time2;
    end

    else if(signal3) begin
        parking_display <= parking_time3;
    end

    else begin
        parking_display <=  parking_cb;
    end
end
    
endmodule
module bcd2seven_seg (
    input clk,
    input reset,
    input [15:0]a,
    output [4:0] SEG_SEL,
    output reg [7:0]SEG_DATA
);

    reg [3:0] current_digit;
    reg [2:0] segment_select = 2'00;

    always @(current_digit)
        begin
            case(current_digit)
                4'b0000:SEG_DATA = 8'b00111111;
                4'b0001:SEG_DATA = 8'b00000110;
                4'b0010:SEG_DATA = 8'b01011011;
                4'b0011:SEG_DATA = 8'b01001111;
                4'b0100:SEG_DATA = 8'b01100110;
                4'b0101:SEG_DATA = 8'b01101101;
                4'b0110:SEG_DATA = 8'b01111101;
                4'b0111:SEG_DATA = 8'b00000111;
                4'b1000:SEG_DATA = 8'b01111111;
                4'b1001:SEG_DATA = 8'b01111011;
            endcase
        end
// assign SEG_SEL= 5'b00001;

    always @(posedge clk) begin
        segment_select <= segment_select + 1;
        case (segment_select)
            2'00: begin
                assign SEG_SEL = 5'b00001;
                current_digit <= a[3:0]; 
            end 

            2'01: begin
                assign SEG_SEL = 5'b00010;
                current_digit <= a[7:4]; 
            end

            2'10: begin
                assign SEG_SEL = 5'b00100;
                current_digit <= a[11:8]; 
            end

            2'11: begin
                assign SEG_SEL = 5'b01000;
                current_digit <= a[15:12]; 
            end 
        endcase
    end  


endmodule
module freqDivider ( input clk_in, output clk_out );
    reg clk_out;
    reg [25:0] counter = 0;
    always @ (posedge clk_in)
        begin
            if (counter == 10000000 - 1)
                begin
                    counter <= 0;
                    clk_out <= ~ clk_out;
                end
            else
                begin
                counter <= counter + 1;
            end
        end
endmodule
module debounce_circuit (
    input clk,         
    input reset,       
    input sig,       
    output deb_sig       
);

    reg Q0, Q1, Q2;  

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q0 <= 1'b0;
            Q1 <= 1'b0;
            Q2 <= 1'b0;
        end else begin
            Q0 <= sig;   
            Q1 <= Q0;   
            Q2 <= Q1;
        end
    end
    
    assign deb_sig = Q0 & Q1 & ~Q2;

endmodule
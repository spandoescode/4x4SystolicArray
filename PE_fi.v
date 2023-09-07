module PE_fi (
    clk, en, rst, A, B, A_out, B_out, C_out
);
    input clk;
    input en; 
    input rst;
    input wire [15:0] A;
    input wire [15:0] B;
    output reg [15:0] A_out;
    output reg [15:0] B_out;
    output reg [15:0] C_out; // 33 bit to account for 16 * 16 bit multiplication

    wire [31:0] mul;
    wire [15:0] C;

    reg [15:0] out_mem;

    initial begin 
        // Initialise all registers to 0
        A_out <= 16'd0;
        B_out <= 16'd0;
        C_out <= 16'd0;
        out_mem <= 16'd0;
    end

    always @(posedge clk ) begin
        if (rst) begin
            A_out <= 16'd0;
            B_out <= 16'd0;
            C_out <= 16'd0;
            out_mem <= 16'd0; 
        end else if (en) begin 
            // MAC
            out_mem <= C + out_mem;

            // Propogate output
            A_out <= A;
            B_out <= B;
            C_out <= out_mem;
        end
    end

    // Truncate the 32 bit result of the 
    // multiplication to the middle 16 bits
    assign mul = A * B;
    assign C = mul[23:8];

endmodule
module output_mem (
    clk, rst, read_addr, read_data, w_en, c00, c01, c02, c03, c10, c11, c12, c13, c20, c21, c22, c23, c30, c31, c32, c33
);
    input clk;
    input rst;
    input w_en;
    input [3:0] read_addr; // 4 bits to access 2 ^ 4 = 16 locations
    input [32:0] c00, c01, c02, c03, c10, c11, c12, c13, c20, c21, c22, c23, c30, c31, c32, c33; // Direct connections from PE array

    output reg [32:0] read_data;

    // Output memory
    reg [32:0] output_mem [15:0];

    always @(posedge clk ) begin
        // Read from memory
        read_data <= output_mem[read_addr];

        if (w_en) begin 
            output_mem[0] <= c00;
            output_mem[1] <= c01;
            output_mem[2] <= c02;
            output_mem[3] <= c03;

            output_mem[4] <= c10;
            output_mem[5] <= c11;
            output_mem[6] <= c12;
            output_mem[7] <= c13;

            output_mem[8] <= c20;
            output_mem[9] <= c21;
            output_mem[10] <= c22;
            output_mem[11] <= c23;

            output_mem[12] <= c30;
            output_mem[13] <= c31;
            output_mem[14] <= c32;
            output_mem[15] <= c33;
        end
    end

endmodule
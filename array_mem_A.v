module array_mem_A (
    clk, w_en, r_en, write_addr, write_data, read_addr_0, read_data_0, read_addr_1, read_data_1, read_addr_2, read_data_2, read_addr_3, read_data_3
);
    input clk;
    input w_en;
    input r_en;

    input [6:0] write_addr;
    input [15:0] write_data;

    input [6:0] read_addr_0; // 6 bits to addres 16 * 4 = 2 ^ 6 = 64 array locations 
    input [6:0] read_addr_1;
    input [6:0] read_addr_2;
    input [6:0] read_addr_3;

    output reg [15:0] read_data_0;
    output reg [15:0] read_data_1;
    output reg [15:0] read_data_2;
    output reg [15:0] read_data_3;

    reg [15:0] array_mem [127:0];

    initial begin
        // Read the program from the file (matrix needs to be stored in row major order)
        $readmemb("array_A_fi.txt", array_mem);
    end

    always @(posedge clk ) begin
        if (w_en) begin
            // Write to memory
            array_mem[write_addr] <= write_data;
        end

        if (r_en) begin 
            // Read from memory
            read_data_0 <= array_mem[read_addr_0];
            read_data_1 <= array_mem[read_addr_1];
            read_data_2 <= array_mem[read_addr_2];
            read_data_3 <= array_mem[read_addr_3];
        end
    end

endmodule
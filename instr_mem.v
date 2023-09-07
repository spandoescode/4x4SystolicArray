module instr_mem (
    clk, read_addr, read_data
);
    input clk;
    input [3:0] read_addr;
    output reg [4:0] read_data;

    reg [4:0] instr_mem [15:0];

    initial begin
        // Read the program from the file
        $readmemb("instr.txt", instr_mem);
    end

    always @(posedge clk ) begin
        read_data <= instr_mem[read_addr];
    end
endmodule
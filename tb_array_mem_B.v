module tb_array_mem_B;
    reg clk;
    reg w_en;

    reg [5:0] write_addr;
    reg [15:0] write_data;

    reg [5:0] read_addr_0; // 6 bits to addres 16 * 4 = 2 ^ 6 = 64 array locations 
    reg [5:0] read_addr_1;
    reg [5:0] read_addr_2;
    reg [5:0] read_addr_3;

    wire [15:0] read_data_0;
    wire [15:0] read_data_1;
    wire [15:0] read_data_2;
    wire [15:0] read_data_3;

    array_mem_B dut(.clk(clk), .w_en(w_en), .write_addr(write_addr), .write_data(write_data), .read_addr_0(read_addr_0), .read_data_0(read_data_0), .read_addr_1(read_addr_1), .read_data_1(read_data_1), .read_addr_2(read_addr_2), .read_data_2(read_data_2), .read_addr_3(read_addr_3), .read_data_3(read_data_3));

    always #5 clk = ~clk;

    initial begin 
        $dumpfile("array_mem_B.vcd");
        $dumpvars(0,tb_array_mem_B);

        clk <= 0;
        w_en <= 0;

        #5;
        read_addr_0 <= 6'd1;
        read_addr_1 <= 6'd2;
        read_addr_2 <= 6'd3;
        read_addr_3 <= 6'd4;

        #10;
        read_addr_0 <= 6'd5;
        read_addr_1 <= 6'd9;
        read_addr_2 <= 6'd13;
        read_addr_3 <= 6'd17;

        #10;
        w_en <= 1;
        write_addr <= 6'd20;
        write_data <= 16'd42;

        #10;
        read_addr_0 <= 6'd20;

        #60 $finish;
    end
    
endmodule
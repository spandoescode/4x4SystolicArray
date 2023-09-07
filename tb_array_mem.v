module tb_array_mem;
    reg clk;
    reg en_A, en_B;
    reg [6:0] read_addr_A;
    reg [6:0] read_addr_B;
    wire [15:0] read_data_A;
    wire [15:0] read_data_B;

    array_mem dut(.clk(clk), .en_A(en_A), .en_B(en_B), .read_addr_A(read_addr_A), .read_addr_B(read_addr_B), .read_data_A(read_data_A), .read_data_B(read_data_B));

    always #5 clk = ~clk;

    initial begin 
        $dumpfile("array_mem.vcd");
        $dumpvars(0,tb_array_mem);

        clk <= 0;
        en_A <= 1;
        en_B <= 1;
        read_addr_A <= 6'd0;
        read_addr_B <= 6'd0;

        #10 read_addr_A <= 6'd1;
        #10 read_addr_A <= 6'd2;
        #10 read_addr_A <= 6'd3;
        #10 read_addr_A <= 6'd4;
        #10 read_addr_A <= 6'd5;
        #10 read_addr_A <= 6'd6;
        #10 read_addr_A <= 6'd7;
        #10 read_addr_A <= 6'd8;
        #10 read_addr_A <= 6'd9;
        #10 read_addr_A <= 6'd10;
        #10 read_addr_A <= 6'd11;
        #10 read_addr_A <= 6'd12;
        #10 read_addr_A <= 6'd13;
        #10 read_addr_A <= 6'd14;
        #10 read_addr_A <= 6'd15;
        #10 read_addr_A <= 6'd16;
        #10 read_addr_A <= 6'd17;

        #10 read_addr_B <= 6'd1;
        #10 read_addr_B <= 6'd2;
        #10 read_addr_B <= 6'd3;
        #10 read_addr_B <= 6'd4;
        #10 read_addr_B <= 6'd5;
        #10 read_addr_B <= 6'd6;
        #10 read_addr_B <= 6'd7;
        #10 read_addr_B <= 6'd8;
        #10 read_addr_B <= 6'd9;
        #10 read_addr_B <= 6'd10;
        #10 read_addr_B <= 6'd11;
        #10 read_addr_B <= 6'd12;
        #10 read_addr_B <= 6'd13;
        #10 read_addr_B <= 6'd14;
        #10 read_addr_B <= 6'd15;
        #10 read_addr_B <= 6'd16;
        #10 read_addr_B <= 6'd17;

        #300 $finish;
    end
    
endmodule
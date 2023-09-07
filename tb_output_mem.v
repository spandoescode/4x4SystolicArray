module tb_output_mem;
    reg clk;

    reg [3:0] read_addr;
    wire [32:0] read_data;

    output_mem dut(.clk(clk), .read_addr(read_addr), .read_data(read_data));

    always #5 clk = ~clk;

    initial begin 
        $dumpfile("output_mem.vcd");
        $dumpvars(0,tb_output_mem);

        clk <= 0;

        #5 read_addr <= 6'd0;
        #10 read_addr <= 6'd1;
        #10 read_addr <= 6'd2;
        #10 read_addr <= 6'd3;
        #10 read_addr <= 6'd4;
        #10 read_addr <= 6'd5;
        #10 read_addr <= 6'd6;
        #10 read_addr <= 6'd7;
        #10 read_addr <= 6'd8;
        #10 read_addr <= 6'd9;
        #10 read_addr <= 6'd10;
        #10 read_addr <= 6'd11;
        #10 read_addr <= 6'd12;
        #10 read_addr <= 6'd13;
        #10 read_addr <= 6'd14;
        #10 read_addr <= 6'd15;

        #200 $finish;
    end
    
endmodule
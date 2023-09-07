module tb_instr_mem;
    reg clk;
    reg [3:0] in;
    wire [4:0] out;

    instr_mem dut(.clk(clk), .read_addr(in), .read_data(out));

    always #5 clk = ~clk;

    initial begin 
        $dumpfile("instr_mem.vcd");
        $dumpvars(0,tb_instr_mem);

        clk <= 0;

        #5 in <= 4'd0;
        #10 in <= 4'd1;
        #10 in <= 4'd2;
        #10 in <= 4'd3;
        #10 in <= 4'd4;
        #10 in <= 4'd5;

        #100 $finish;
    end
    
endmodule
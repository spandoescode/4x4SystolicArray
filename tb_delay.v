module tb_delay;
    reg clk;
    reg [15:0] in;
    wire [15:0] out;

    delay dut(.clk(clk), .in(in), .out(out));

    always #5 clk = ~clk;

    initial begin 
        $dumpfile("delay.vcd");
        $dumpvars(0, tb_delay);

        clk <= 0;

        #5 in <= 16'd1;
        #10 in <= 16'd2;
        #10 in <= 16'd3;
        #10 in <= 16'd4;

        #100 $finish;
    end
    
endmodule
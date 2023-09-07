module tb_PE;
    reg clk;
    reg en;
    reg rst;
    reg [15:0] A, B;
    wire [15:0] A_out, B_out;
    wire [32:0] C_out;

    PE dut(.clk(clk), .en(en), .rst(rst), .A(A), .B(B), .A_out(A_out), .B_out(B_out), .C_out(C_out));

    always #5 clk = ~clk;

    initial begin 
        $dumpfile("PE.vcd");
        $dumpvars(0, tb_PE);

        clk <= 0;
        en <= 1;
        A = 16'd0;
        B = 16'd0;

        #5 A = 16'd2; B = 16'd4;
        #10 A = 16'd3; B = 16'd2; 

        #10 en = 0;

        #20 rst = 1;

        #100 $finish;
    end
    
endmodule
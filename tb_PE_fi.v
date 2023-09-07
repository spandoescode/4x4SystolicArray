module tb_PE_fi;
    reg clk;
    reg en;
    reg rst;
    reg [15:0] A, B;
    wire [15:0] A_out, B_out;
    wire [15:0] C_out;

    PE dut(.clk(clk), .en(en), .rst(rst), .A(A), .B(B), .A_out(A_out), .B_out(B_out), .C_out(C_out));

    always #5 clk = ~clk;

    initial begin 
        $dumpfile("PE_fi.vcd");
        $dumpvars(0, tb_PE_fi);

        clk <= 0;
        en <= 1;
        A = 16'd0;
        B = 16'd0;

        #5 A = 16'b0000000110000000; B = 16'b0000001000000000;
        #10 A = 16'b0000000001000011; B = 16'b0000000011001010; 

        #20 rst = 1;

        #100 $finish;
    end
    
endmodule
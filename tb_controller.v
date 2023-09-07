module tb_controller;
    reg clk;
    reg en;

    wire done;
    reg [15:0] storage [128:0];

    controller dut(.clk(clk), .en(en), .done(done));

    always #5 clk = ~clk;

    initial begin 
        $dumpfile("controller.vcd");
        $dumpvars(0, tb_controller);

        clk <= 0;

        #10 en <= 1;

        #1000 $finish;
    end
endmodule
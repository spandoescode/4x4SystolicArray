module tb_controller_fi;
    reg clk;
    reg en;
    wire done;

    integer i, j;

    reg [4:0] read_addr_C;
    wire [15:0] read_data_C;

    reg [15:0] storage [127:0];

    controller_fi dut(.clk(clk), .en(en), .done(done), .read_addr_C(read_addr_C), .read_data_C(read_data_C));

    always #5 clk = ~clk;

    initial begin 
        $dumpfile("controller_fi.vcd");
        $dumpvars(0, tb_controller_fi);

        clk <= 0;

        read_addr_C <= 0;
        i <= 0;

        #10 en <= 1;

        #1500 $finish;
    end

    always @(posedge done) begin 
        read_addr_C = 0;

        for(j=0; j<18; j++) begin
            #10 storage[i] <= read_data_C;
            read_addr_C <= j+1;

            if (j != 17 && j != 0) begin 
                i <= i + 1;    
            end
        end

        $writememb("sim_output.txt", storage);
    end

    
endmodule
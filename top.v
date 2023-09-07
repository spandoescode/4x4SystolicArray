module top (
    input clk,
    input rst,
    input ap_start,
    input enA, enB, enI,
    input [15:0] addrA, addrB, addrI,
    input [15:0] dataA, dataB, dataI,
    input [4:0] addrI, dataI
    output [15:0] addrO, dataO,
    output wire ap_done
);

    // Instantiate the controller
    controller CU(.clk(clk), .en(ap_start), .w_en_A(enA), .w_en_B(enB), .write_addr_A(addrA), .write_addr_B(addrB), .write_data_A(dataA), .write_data_B(dataB), .read_addr_C(addrO), .read_data_C(dataO), .done(ap_done));
    
endmodule
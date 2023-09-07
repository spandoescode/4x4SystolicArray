module controller_fi (
    clk, en, w_en_A, w_en_B, write_addr_A, write_addr_B, write_data_A, write_data_B, read_addr_C, read_data_C, done
);
    input clk;
    input en;
    reg rst;

    input w_en_A;
    input w_en_B;
    reg r_en_A, r_en_B;
    reg w_en_C;

    input [6:0] write_addr_A, write_addr_B;
    input [15:0] write_data_A, write_data_B;
    input [4:0] read_addr_C;

    // Signals to start the matrix multiplication
    reg p_en0;
    reg p_en1;
    reg p_en2;
    reg p_en3;
    reg p_en4;
    reg p_en5;
    reg p_en6;

    output reg done;

    output [15:0] read_data_C;

    reg is_started_transfer;
    reg is_completed_transfer;
    reg [3:0] PC; // To address 16 locations of instruction memory
    reg [6:0] counter; // To store integer values up till 2 ^ 5 = 32
    reg [6:0] offset;
    reg [6:0] add_offset; // To store the value of offset * offset
    reg [6:0] base_offset; // To load the correct memory addresses
    reg [6:0] counter_limit;
    wire [4:0] instruction;

    // Wires for delay connections for memory A
    wire [15:0] in_dA_1, out_dA_1;
    wire [15:0] in_dA_20, out_dA_20;
    wire [15:0] out_dA_21;
    wire [15:0] in_dA_30, out_dA_30;
    wire [15:0] out_dA_31;
    wire [15:0] out_dA_32;

    // Initialise the delay elements for memory A
    delay dA_1(.clk(clk), .in(in_dA_1), .out(out_dA_1));
    delay dA_20(.clk(clk), .in(in_dA_20), .out(out_dA_20));
    delay dA_21(.clk(clk), .in(out_dA_20), .out(out_dA_21));
    delay dA_30(.clk(clk), .in(in_dA_30), .out(out_dA_30));
    delay dA_31(.clk(clk), .in(out_dA_30), .out(out_dA_31));
    delay dA_32(.clk(clk), .in(out_dA_31), .out(out_dA_32));

    // Wires for data memory connections for memory A
    wire [6:0] A_read_addr_0;
    wire [6:0] A_read_addr_1;
    wire [6:0] A_read_addr_2;
    wire [6:0] A_read_addr_3;
    wire [15:0] A_read_data_0;

    // Wires for delay connections for memory B
    wire [15:0] in_dB_1, out_dB_1;
    wire [15:0] in_dB_20, out_dB_20;
    wire [15:0] out_dB_21;
    wire [15:0] in_dB_30, out_dB_30;
    wire [15:0] out_dB_31;
    wire [15:0] out_dB_32;

    // Initialise the delay elements for memory B
    delay dB_1(.clk(clk), .in(in_dB_1), .out(out_dB_1));
    delay dB_20(.clk(clk), .in(in_dB_20), .out(out_dB_20));
    delay dB_21(.clk(clk), .in(out_dB_20), .out(out_dB_21));
    delay dB_30(.clk(clk), .in(in_dB_30), .out(out_dB_30));
    delay dB_31(.clk(clk), .in(out_dB_30), .out(out_dB_31));
    delay dB_32(.clk(clk), .in(out_dB_31), .out(out_dB_32));

    // Wires for data memory connections for memory B
    wire [6:0] B_read_addr_0;
    wire [6:0] B_read_addr_1;
    wire [6:0] B_read_addr_2;
    wire [6:0] B_read_addr_3;
    wire [15:0] B_read_data_0;

    // Initialise the data memory banks
    array_mem_A mem_A(.clk(clk), .w_en(w_en_A), .r_en(r_en_A), .write_addr(write_addr_A), .write_data(write_data_A), .read_addr_0(A_read_addr_0), .read_data_0(A_read_data_0), .read_addr_1(A_read_addr_1), .read_data_1(in_dA_1), .read_addr_2(A_read_addr_2), .read_data_2(in_dA_20), .read_addr_3(A_read_addr_3), .read_data_3(in_dA_30));
    array_mem_B mem_B(.clk(clk), .w_en(w_en_B), .r_en(r_en_B), .write_addr(write_addr_B), .write_data(write_data_B), .read_addr_0(B_read_addr_0), .read_data_0(B_read_data_0), .read_addr_1(B_read_addr_1), .read_data_1(in_dB_1), .read_addr_2(B_read_addr_2), .read_data_2(in_dB_20), .read_addr_3(B_read_addr_3), .read_data_3(in_dB_30));

    // Registers to store the address of the datat to be fetched from the memory
    reg [6:0] row_addr_0, row_addr_1, row_addr_2, row_addr_3; 
    reg [6:0] col_addr_0, col_addr_1, col_addr_2, col_addr_3;

    // Wires for PE array connections
    wire [15:0] gnd;
    wire [15:0] a00, a01, a02, a03;
    wire [15:0] a10, a11, a12, a13;
    wire [15:0] a20, a21, a22, a23;
    wire [15:0] a30, a31, a32, a33;

    wire [15:0] b00, b01, b02, b03;
    wire [15:0] b10, b11, b12, b13;
    wire [15:0] b20, b21, b22, b23;
    wire [15:0] b30, b31, b32, b33;

    wire [15:0] c00, c01, c02, c03;
    wire [15:0] c10, c11, c12, c13;
    wire [15:0] c20, c21, c22, c23;
    wire [15:0] c30, c31, c32, c33;

    // Initialise the output memory
    output_mem_fi mem_C(.clk(clk), .read_addr(read_addr_C), .read_data(read_data_C), .w_en(w_en_C), .c00(c00), .c01(c01), .c02(c02), .c03(c03), .c10(c10), .c11(c11), .c12(c12), .c13(c13), .c20(c20), .c21(c21), .c22(c22), .c23(c23), .c30(c30), .c31(c31), .c32(c32), .c33(c33));

    // Initialise the PE array
    PE_fi pe00(.clk(clk), .en(p_en0), .rst(rst), .A(A_read_data_0), .B(B_read_data_0), .A_out(a00), .B_out(b00), .C_out(c00));
    PE_fi pe01(.clk(clk), .en(p_en1), .rst(rst), .A(a00), .B(out_dB_1), .A_out(a01), .B_out(b01), .C_out(c01));
    PE_fi pe02(.clk(clk), .en(p_en2), .rst(rst), .A(a01), .B(out_dB_21), .A_out(a02), .B_out(b02), .C_out(c02));
    PE_fi pe03(.clk(clk), .en(p_en3), .rst(rst), .A(a02), .B(out_dB_32), .A_out(a03), .B_out(b03), .C_out(c03));
    
    PE_fi pe10(.clk(clk), .en(p_en1), .rst(rst), .A(out_dA_1), .B(b00), .A_out(a10), .B_out(b10), .C_out(c10));
    PE_fi pe11(.clk(clk), .en(p_en2), .rst(rst), .A(a10), .B(b01), .A_out(a11), .B_out(b11), .C_out(c11));
    PE_fi pe12(.clk(clk), .en(p_en3), .rst(rst), .A(a11), .B(b02), .A_out(a12), .B_out(b12), .C_out(c12));
    PE_fi pe13(.clk(clk), .en(p_en4), .rst(rst), .A(a12), .B(b03), .A_out(a13), .B_out(b13), .C_out(c13));
    
    PE_fi pe20(.clk(clk), .en(p_en2), .rst(rst), .A(out_dA_21), .B(b10), .A_out(a20), .B_out(b20), .C_out(c20));
    PE_fi pe21(.clk(clk), .en(p_en3), .rst(rst), .A(a20), .B(b11), .A_out(a21), .B_out(b21), .C_out(c21));
    PE_fi pe22(.clk(clk), .en(p_en4), .rst(rst), .A(a21), .B(b12), .A_out(a22), .B_out(b22), .C_out(c22));
    PE_fi pe23(.clk(clk), .en(p_en5), .rst(rst), .A(a22), .B(b13), .A_out(a23), .B_out(b23), .C_out(c23));

    PE_fi pe30(.clk(clk), .en(p_en3), .rst(rst), .A(out_dA_32), .B(b20), .A_out(a30), .B_out(b30), .C_out(c30));
    PE_fi pe31(.clk(clk), .en(p_en4), .rst(rst), .A(a30), .B(b21), .A_out(a31), .B_out(b31), .C_out(c31));
    PE_fi pe32(.clk(clk), .en(p_en5), .rst(rst), .A(a31), .B(b22), .A_out(a32), .B_out(b32), .C_out(c32));
    PE_fi pe33(.clk(clk), .en(p_en6), .rst(rst), .A(a32), .B(b23), .A_out(a33), .B_out(b33), .C_out(c33));

    // Initialise the instruction memory 
    instr_mem IM(.clk(clk), .read_addr(PC), .read_data(instruction));

    initial begin 
        // Set the PC to the start of the program and set the counter to the size of the array
        PC <= 0;
        base_offset <= 0;
        add_offset <= 0;
        counter <= -1;
        is_started_transfer <= 0;
        is_completed_transfer <= 0;
        r_en_A <= 0;
        r_en_B <= 0;
        done <= 0;
    end

    always @(posedge clk ) begin
        if (en) begin 
            // Exit character check
            if (instruction !== 0) begin 
                if (is_started_transfer === 0) begin 
                    // Copy the value of the instruction to the counter
                    offset <= instruction;

                    // Set the counter limit
                    counter_limit <= (3 * instruction);

                    // Set the transfer flag to 1
                    is_started_transfer <= 1;
                    
                    // Enable reading for the data memories
                    r_en_A <= 1;
                    r_en_B <= 1;

                    // Reset the ap_done flag
                    done <= 0;
                end 

                // Increment the counter
                counter <= counter + 1;

                // Turn on the p_en for respective PEs at the correct time 
                case (counter)
                    6'd0: begin
                            // Stop the output memory from being overwritten 
                            w_en_C = 0;

                            // Lift the PE reset
                            rst <= 0;  
                        end
                    6'd1: p_en0 <= 1;
                    6'd2: p_en1 <= 1;
                    6'd3: p_en2 <= 1;
                    6'd4: p_en3 <= 1;
                    6'd5: p_en4 <= 1;
                    6'd6: p_en5 <= 1;                   
                    6'd7: p_en6 <= 1;
                endcase

                // Switch off the p_en for respective PEs at the correct time
                if (counter == offset + 2) begin 
                    p_en0 <= 0;
                end else if (counter == offset + 3) begin 
                    p_en1 <= 0;
                end else if (counter == offset + 4) begin 
                    p_en2 <= 0;
                end else if (counter == offset + 5) begin 
                    p_en3 <= 0;
                end else if (counter == offset + 6) begin 
                    p_en4 <= 0;
                end else if (counter == offset + 7) begin 
                    p_en5 <= 0;
                end else if (counter == offset + 8) begin 
                    p_en6 <= 0;
                end

                if(counter == offset) begin 
                    row_addr_0 <= 7'd127;
                    row_addr_1 <= 7'd127;
                    row_addr_2 <= 7'd127;
                    row_addr_3 <= 7'd127;

                    col_addr_0 <= 7'd127;
                    col_addr_1 <= 7'd127;
                    col_addr_2 <= 7'd127;
                    col_addr_3 <= 7'd127;

                    // r_en_A <= 0;
                    // r_en_B <= 0;               
                end 

                if (counter == offset - 1) begin 
                    // Stop the PE array from recieving any more inputs
                    is_completed_transfer <= 1;

                    // Calculate offset * offset
                    add_offset <= offset * 4;
                end
                
                if (is_completed_transfer == 0) begin 
                    // Send matrix values to the PE array
                    row_addr_0 <= base_offset + counter;
                    row_addr_1 <= base_offset + counter + instruction;
                    row_addr_2 <= base_offset + counter + instruction + instruction;
                    row_addr_3 <= base_offset + counter + instruction + instruction + instruction;

                    col_addr_0 <= base_offset + counter;
                    col_addr_1 <= base_offset + counter + instruction;
                    col_addr_2 <= base_offset + counter + instruction + instruction;
                    col_addr_3 <= base_offset + counter + instruction + instruction + instruction;
                end

                // If the matrix multiplication has been completed
                if (counter == counter_limit -1) begin 
                    // Increment the Program Counter
                    PC <= PC + 5'd1;

                    // Transfer result to the output memory
                    w_en_C <= 1;

                    // Increment the Base Offset
                    // base_offset <= base_offset + (instruction * instruction);
                    base_offset <= base_offset + add_offset;                                                     
                end

                if (counter === counter_limit) begin 
                    // Reset the data transfer flag
                    is_started_transfer <= 0;

                    // Reset the completed transfer flag
                    is_completed_transfer <= 0;

                    // Reset the counter
                    counter <= 0;

                    // Reset the PE data
                    rst <= 1;

                    // Set the ap_done signal to high
                    done <= 1; 
                end 
            end else begin 
                if (counter == 0) begin 
                    // Stop the output memory from being overwritten 
                    w_en_C = 0;
                end
            end
        end
    end

    assign A_read_addr_0 = row_addr_0;
    assign A_read_addr_1 = row_addr_1;
    assign A_read_addr_2 = row_addr_2;
    assign A_read_addr_3 = row_addr_3;

    assign B_read_addr_0 = col_addr_0;
    assign B_read_addr_1 = col_addr_1;
    assign B_read_addr_2 = col_addr_2;
    assign B_read_addr_3 = col_addr_3;

endmodule
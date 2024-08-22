`timescale 1ns / 1ps
module top(
    input clk, reset,
    input[7:0] a00, a01, a02, a10, a11, a12, a20, a21, a22,
    input[7:0] b00, b01, b02, b10, b11, b12, b20, b21, b22,
    output[7:0] c00, c01, c02, c10, c11, c12, c20, c21, c22
    );
    
//    multiplier m1(a,b,cm);
//    adder a1(a,b,ca);
    
    //Array Controls
    reg start0 = 0; reg start1 = 0; reg start2 = 0;
    reg start3 = 0; reg start4 = 0; reg start5 = 0;
    reg start6 = 0; reg start7 = 0; reg start8 = 0;
    
    //Array Inputs
                                    reg [7:0] top1 = 8'b0000_0000; reg [7:0] top2 = 8'b0000_0000; reg [7:0] top3 = 8'b0000_0000;
    reg [7:0] left1 = 8'b0000_0000;
    reg [7:0] left2 = 8'b0000_0000;
    reg [7:0] left3 = 8'b0000_0000;
    
    //State Machine
    reg [3:0] state = 0;
    reg [3:0] next_state = 0;
    
    always @ (*)
    begin
        case (state)
            4'b0000:
            begin
                          top1 = 0; top2 = 0; top3 = 0;
                left1 = 0;
                left2 = 0;
                left3 = 0;
                
                start0 = 0; start1 = 0; start2 = 0;
                start3 = 0; start4 = 0; start5 = 0;
                start6 = 0; start7 = 0; start8 = 0;
                
                next_state = 1;
            end
            4'b0001:
            begin
                           top1 = b00; top2 = 0; top3 = 0;
                left1 = a00;
                left2 = 0;
                left3 = 0;
                
                start0 = 1; start1 = 0; start2 = 0;
                start3 = 0; start4 = 0; start5 = 0;
                start6 = 0; start7 = 0; start8 = 0;
                
                next_state = 2;               
            end
            4'b0010:
            begin
                          top1 = b10; top2 = b01; top3 = 0;
                left1 = a01;
                left2 = a10;
                left3 = 0;
                
                start0 = 1; start1 = 1; start2 = 0;
                start3 = 1; start4 = 0; start5 = 0;
                start6 = 0; start7 = 0; start8 = 0;
                
                next_state = 3;               
            end
            4'b0011:
            begin
                          top1 = b20; top2 = b11; top3 = b02;
                left1 = a02;
                left2 = a11;
                left3 = a20;
                
                start0 = 1; start1 = 1; start2 = 1;
                start3 = 1; start4 = 1; start5 = 0;
                start6 = 1; start7 = 0; start8 = 0;
                
                next_state = 4;                
            end
            4'b0100:
            begin
                          top1 = 0; top2 = b21; top3 = b12;
                left1 = 0;
                left2 = a12;
                left3 = a21;
                
                start0 = 0; start1 = 1; start2 = 1;
                start3 = 1; start4 = 1; start5 = 1;
                start6 = 1; start7 = 1; start8 = 0;
                
                next_state = 5;               
            end
            4'b0101:
            begin
                          top1 = 0; top2 = 0; top3 = b22;
                left1 = 0;
                left2 = 0;
                left3 = a22;
                
                start0 = 0; start1 = 0; start2 = 1;
                start3 = 0; start4 = 1; start5 = 1;
                start6 = 1; start7 = 1; start8 = 1;
                
                next_state = 6;               
            end
            4'b0110:
            begin
                          top1 = 0; top2 = 0; top3 = 0;
                left1 = 0;
                left2 = 0;
                left3 = 0;
                
                start0 = 0; start1 = 0; start2 = 0;
                start3 = 0; start4 = 0; start5 = 1;
                start6 = 0; start7 = 1; start8 = 1;
                
                next_state = 7;               
            end
            4'b0111:
            begin
                          top1 = 0; top2 = 0; top3 = 0;
                left1 = 0;
                left2 = 0;
                left3 = 0;
                
                start0 = 0; start1 = 0; start2 = 0;
                start3 = 0; start4 = 0; start5 = 0;
                start6 = 0; start7 = 0; start8 = 1;
                
                next_state = 8;               
            end
            4'b1000:
            begin
                start8 = 0;
                next_state = 0;                
            end
            default:
            begin
                          top1 = 0; top2 = 0; top3 = 0;
                left1 = 0;
                left2 = 0;
                left3 = 0;
                
                start0 = 0; start1 = 0; start2 = 0;
                start3 = 0; start4 = 0; start5 = 0;
                start6 = 0; start7 = 0; start8 = 0;
                
                next_state = 0;
            end
            
        endcase
    end
    
    always @(posedge clk or posedge reset)
    begin
        if(reset)
            state <= 0;
        else
            state <= next_state;
    end
    
//    z0 z1 z2
//    z3 z4 z5
//    z6 z7 z8

//     next1
//next2  z  pass2
//    pass1
    
    wire [7:0] pass01, pass02;
    MAC z0(.clk(clk), .reset(reset), .start(start0), .next1(top1), .next2(left1), .pass1(pass01), .pass2(pass02), .c(c00));
    wire [7:0] pass11, pass12;
    MAC z1(.clk(clk), .reset(reset), .start(start1), .next1(top2), .next2(pass02), .pass1(pass11), .pass2(pass12), .c(c01));
    wire [7:0] pass21, pass22;
    MAC z2(.clk(clk), .reset(reset), .start(start2), .next1(top3), .next2(pass12), .pass1(pass21), .pass2(pass22), .c(c02));
   
    wire [7:0] pass31, pass32;
    MAC z3(.clk(clk), .reset(reset), .start(start3), .next1(pass01), .next2(left2), .pass1(pass31), .pass2(pass32), .c(c10));
    wire [7:0] pass41, pass42;
    MAC z4(.clk(clk), .reset(reset), .start(start4), .next1(pass11), .next2(pass32), .pass1(pass41), .pass2(pass42), .c(c11));
    wire [7:0] pass51, pass52;
    MAC z5(.clk(clk), .reset(reset), .start(start5), .next1(pass21), .next2(pass42), .pass1(pass51), .pass2(pass52), .c(c12));
    
    wire [7:0] pass61, pass62;
    MAC z6(.clk(clk), .reset(reset), .start(start6), .next1(pass31), .next2(left3), .pass1(pass61), .pass2(pass62), .c(c20));
    wire [7:0] pass71, pass72;
    MAC z7(.clk(clk), .reset(reset), .start(start7), .next1(pass41), .next2(pass62), .pass1(pass71), .pass2(pass72), .c(c21));
    wire [7:0] pass81, pass82;
    MAC z8(.clk(clk), .reset(reset), .start(start8), .next1(pass51), .next2(pass72), .pass1(pass81), .pass2(pass82), .c(c22));
endmodule

module MAC(
    input clk,
    input reset,
    input start,
    input [7:0] next1,
    input [7:0] next2,
    output [7:0] pass1,
    output [7:0] pass2,
    output [7:0] c
);
    reg [7:0] pass1_reg = 0;
    reg [7:0] pass2_reg = 0;
    
    assign pass1 = pass1_reg;
    assign pass2 = pass2_reg;
    
    reg[7:0] final = 0;
    wire [7:0] final_wire = final;
    wire [7:0] mul;
    wire [7:0] add;
    
    assign c = final;
    
    multiplier m1(.a(next1),.b(next2),.c(mul));
    adder a1(.a(final_wire), .b(mul), .c(add));
    
    always @ (negedge clk or posedge reset)
    begin
        if(start)
            final = add;
        else
            final = final;
        if(reset)
            final = 0;
        pass1_reg <= next1;
        pass2_reg <= next2;
    end

endmodule

module adder(
    input [7:0] a,
    input [7:0] b,
    output [7:0] c
    );
    
    wire[4:0] afraction = {1,a[3:0]};
    wire[4:0] bfraction = {1,b[3:0]};
    
    wire a_0 = (a == 8'b0000_0000);
    wire b_0 = (b == 8'b0000_0000);
    
    wire[2:0] aexponent = a[6:4];// - 2'b11;
    wire[2:0] bexponent = b[6:4];// - 2'b11;
    
    
    //Checks if the exponenet of a is greater than b's
    wire agreater_exp = aexponent >= bexponent;
    wire[2:0] greater_exp_val = agreater_exp ? aexponent: bexponent;
    
    //Checks if the signs are different
    wire diff_sign = a[7] ^ b[7];
    
    //Perfroms the shifting based on the smaller exponent
    wire [4:0] a_shift = agreater_exp ? afraction: afraction >> (bexponent - aexponent);  
    wire [4:0] b_shift = agreater_exp ? bfraction >> (aexponent - bexponent): bfraction;  
    
    //Checks which shifted value is greater
    wire a_shift_greater = a_shift >= b_shift;
    
    //Diff sign flags
    wire ds_c1 = (a_shift_greater && a[7]);
    wire ds_c2 = (~a_shift_greater && b[7]);
    wire ds_c3 = (a_shift_greater && b[7]);
    wire ds_c4 = (~a_shift_greater && a[7]);
    
    //Adds the 2 shifted values
    //wire[4:0] diff_sign_val = a_shift_greater ? (a_shift - b_shift): (b_shift - a_shift);
    wire[5:0] same_sign_val = a_shift + b_shift;
        
    //Finds the different sign significand
    //Case 1: a is greater and a is negative -> (-1) (a-b)
    //Case 2: b is greater and b is negative -> (-1) (b-a)
    //Case 3: a is greater and b is negative -> (a-b)
    //Case 4: b is greater and a is negative -> (b-a)
    wire[4:0] a_b = (a_shift - b_shift);
    wire[4:0] b_a = (b_shift - a_shift);
    
    wire[4:0] greater_cond = (ds_c1 || ds_c3) ? a_b: b_a;
    wire[4:0] gc_shift1 = (greater_cond << 1);
    wire[4:0] gc_shift2 = (greater_cond << 2);
    wire[4:0] gc_shift3 = (greater_cond << 3);
    wire[4:0] gc_shift4 = (greater_cond << 4);
    
    // 1000 - 0 101 0000
    // -0110 - 1 100 1000 -> 10000 - 01100 = 00100. (I don't know how to renormalize after subtracting)
    //4 cases:
    //Case 1: ~a_b[4] shift left 1, then subtract 1 from exponent, then take a_b[3:0] as significand
    //Case 2: ~a_b[4:3] shift left 2, then subtract 2 from exponent, then take a_b[3:0] as significand
    //Case 3: ~a_b[4:2] shift left 3, then subtract 3 from exponent, then take a_b[3:0] as significand
    //Case 4: ~a_b[4:1] shift left 4, then subtract 4 from exponent, then take a_b[3:0] as significand
    
    wire shift_case1 = ~greater_cond[4];
    wire shift_case2 = ~greater_cond[4:3];    
    wire shift_case3 = ~greater_cond[4:2];    
    wire shift_case4 = ~greater_cond[4:1];        
    
    wire[3:0] diff_sign_significand = shift_case1 ? (shift_case2 ? (shift_case3 ? (shift_case4 ? (gc_shift4[3:0]):gc_shift3[3:0]):gc_shift2[3:0]):gc_shift1[3:0]): greater_cond[3:0];    
    wire diff_sign_sign = (ds_c1 || ds_c2) ? 1'b1: 1'b0;
    wire[2:0] diff_sign_shift = shift_case1 ? (shift_case2 ? (shift_case3 ? (shift_case4 ? (4):3):2):1): 0;
    wire[2:0] diff_sign_exponent_val = greater_exp_val - diff_sign_shift;
    wire[7:0] diff_sign_final = {diff_sign_sign, diff_sign_exponent_val ,diff_sign_significand};
    
    //Same sign significand
    wire[3:0] same_sign_significand = same_sign_val[5] ? same_sign_val[4:1]: same_sign_val[3:0];
    
    //Concatenates everything together
    wire[2:0] same_sign_exp = agreater_exp ? aexponent + same_sign_val[5]: bexponent + same_sign_val[5];
    wire[7:0] same_sign_final = agreater_exp ? {a[7],(same_sign_exp),same_sign_significand}:{a[7],(same_sign_exp),same_sign_significand};
    
    wire [7:0] no_zeros = diff_sign ? diff_sign_final: same_sign_final;
    wire zero_val = (a_b == b_a) && diff_sign && (aexponent == bexponent);
    assign c = (zero_val && !(a_0 || b_0)) ? (8'b0_000_0000):((a_0 || b_0) ? (a_0 ? b:a):no_zeros);
            
endmodule

module multiplier(
    input [7:0] a,
    input [7:0] b,
    output [7:0] c
    );
    
    wire[4:0] afraction = {1'b1,a[3:0]};
    wire[4:0] bfraction = {1'b1,b[3:0]};
    
    wire[2:0] aexponent = a[6:4] - 2'b11;
    wire[2:0] bexponent = b[6:4] - 2'b11;
    
    //Sign Bit (1 bit)   
    wire f_sign = a[7] ^ b[7];
    
    //Multiplying Significands (4 bits) (5 bits * 5 bits)    
    wire [9:0] significand = (afraction * bfraction);
    
    //Final significand has 2 cases
    //Case 1: there is no 1 in the MSB, -> take the [7:4] bits
    //Case 2: there is a 1 in the MSB, -> take the [8:5] bits
    wire [3:0] f_significand = significand[9] ? significand[8:5]: significand[7:4];
    
    //Adding Exponents
    wire[2:0] f_exponent = aexponent + bexponent + 3 + significand[9];
    
    assign c = ((a == 0) || (b == 0)) ? 8'b00000000: {f_sign,f_exponent,f_significand};
    
endmodule

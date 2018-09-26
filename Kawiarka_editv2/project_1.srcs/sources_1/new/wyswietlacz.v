`include "defines.v"


/*
    MULTIPLEXOWANY, CZTEROSEGMENTOWY WYŒWIETLACZ 7SEG Z KROPK¥
    
*/  

//////////////////////////////////////////////////////////////////////////////////


module wyswietlacz_4x7(
    input wire clk,                 // zegar (nie mniej, ni¿ 250Hz)
    input wire [4:0] L_1,           // liczba segement 1 (6 bit = kropka)
    input wire [4:0] L_2,           // liczba segement 2 (6 bit = kropka)
    input wire [4:0] L_3,           // liczba segement 3 (6 bit = kropka)
    input wire [4:0] L_4,           // liczba segement 4 (6 bit = kropka)
    output reg [3:0] segment_out,   // wskaŸnik wyœwietlanej liczby (0-wyœwietlany, 1-zgaszony)
    output reg seg_um,              // góra, œrodek 1
    output reg seg_ul,              // góra, lewo 2
    output reg seg_ur,              // góra, prawo 3
    output reg seg_mm,              // œrodek, œrodek 4
    output reg seg_dl,              // dó³, lewo 5
    output reg seg_dr,              // dó³, prawo 6
    output reg seg_dm,              // dól, œrodek 7
    output reg seg_dot              // kropka
    );
    
    function [7:0]liczbaNAsygnaly;
    input [4:0]liczba;
        begin
            case (liczba[3:0])
                default: liczbaNAsygnaly = ~8'b00000000;       // nic nie œwieci
                4'b0000: liczbaNAsygnaly = ~{liczba[4:4],7'b1110111};  // 0
                4'b0001: liczbaNAsygnaly = ~{liczba[4:4],7'b0010010};  // 1
                4'b0010: liczbaNAsygnaly = ~{liczba[4:4],7'b1011101};  // 2
                4'b0011: liczbaNAsygnaly = ~{liczba[4:4],7'b1011011};  // 3
                4'b0100: liczbaNAsygnaly = ~{liczba[4:4],7'b0111010};  // 4
                4'b0101: liczbaNAsygnaly = ~{liczba[4:4],7'b1101011};  // 5
                4'b0110: liczbaNAsygnaly = ~{liczba[4:4],7'b1101111};  // 6
                4'b0111: liczbaNAsygnaly = ~{liczba[4:4],7'b1010010};  // 7
                4'b1000: liczbaNAsygnaly = ~{liczba[4:4],7'b1111111};  // 8
                4'b1001: liczbaNAsygnaly = ~{liczba[4:4],7'b1111011};  // 9
                                                      
                4'b1010: liczbaNAsygnaly = ~{liczba[4:4],7'b0001000};  // -
                4'b1011: liczbaNAsygnaly = ~{liczba[4:4],7'b1111110};  // a 
                4'b1100: liczbaNAsygnaly = ~{liczba[4:4],7'b1101101};  // e
                4'b1111: liczbaNAsygnaly = ~{liczba[4:4],7'b0000000};  // nic
            endcase
         end
    endfunction
    
    
    always @(negedge clk)
        begin
            case (segment_out)
                default: begin segment_out <= ~4'b0001; {seg_dot,seg_um,seg_ul,seg_ur,seg_mm,seg_dl,seg_dr,seg_dm} <= liczbaNAsygnaly(L_1); end // inicjalizacja - pierwszy segment zapalony
                4'b1110: begin segment_out <= ~4'b0010; {seg_dot,seg_um,seg_ul,seg_ur,seg_mm,seg_dl,seg_dr,seg_dm} <= liczbaNAsygnaly(L_2); end // z ka¿dym pe³nym cyklem zmieniamy wyœwietlany segment
                4'b1101: begin segment_out <= ~4'b0100; {seg_dot,seg_um,seg_ul,seg_ur,seg_mm,seg_dl,seg_dr,seg_dm} <= liczbaNAsygnaly(L_3); end // z ka¿dym pe³nym cyklem zmieniamy wyœwietlany segment
                4'b1011: begin segment_out <= ~4'b1000; {seg_dot,seg_um,seg_ul,seg_ur,seg_mm,seg_dl,seg_dr,seg_dm} <= liczbaNAsygnaly(L_4); end // z ka¿dym pe³nym cyklem zmieniamy wyœwietlany segment
                4'b0111: begin segment_out <= ~4'b0001; {seg_dot,seg_um,seg_ul,seg_ur,seg_mm,seg_dl,seg_dr,seg_dm} <= liczbaNAsygnaly(L_1); end // ustawiamy wyswietlany segment na pierwszy 
            endcase
        end
        
endmodule

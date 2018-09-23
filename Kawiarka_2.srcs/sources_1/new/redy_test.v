`include "defines.v"

module redy_test(i_w, i_c,signal_s);

// signal_s - wyjœciowy sygna³

// i_w - ilosci wody wody
// i_c - iloœæ kawy

//porty
output signal_s;
input i_w, i_c;

assign signal_s = i_w | i_c ;

endmodule



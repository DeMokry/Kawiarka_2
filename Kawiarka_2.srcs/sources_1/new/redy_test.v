`include "defines.v"

module redy_test(i_w, i_c,signal_s);

// signal_s - wyj�ciowy sygna�

// i_w - ilosci wody wody
// i_c - ilo�� kawy

//porty
output signal_s;
input i_w, i_c;

assign signal_s = i_w | i_c ;

endmodule



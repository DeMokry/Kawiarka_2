`include "defines.v"

module sprawnosc(i_w,i_k, i_m, signal_s);

// c_k - czujnik ilo�ci kubk�w
// i_w - ilosc wody
// i_k - ilo�� kawy
// i_m - ilo�� mleka
// p_b - posiadany bilon na wydanie reszty
// signal_s - wyj�ciowy sygna�

// deklaracja port�w
output signal_s;
input i_w, i_k, i_m;

assign signal_s = i_w | i_k | i_m;

endmodule

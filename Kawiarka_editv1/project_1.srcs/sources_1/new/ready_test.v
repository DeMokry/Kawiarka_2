`include "defines.v"

module sprawnosc(i_w,i_k, i_m, signal_s);

// c_k - czujnik iloœci kubków
// i_w - ilosc wody
// i_k - iloœæ kawy
// i_m - iloœæ mleka
// p_b - posiadany bilon na wydanie reszty
// signal_s - wyjœciowy sygna³

// deklaracja portów
output signal_s;
input i_w, i_k, i_m;

assign signal_s = i_w | i_k | i_m;

endmodule

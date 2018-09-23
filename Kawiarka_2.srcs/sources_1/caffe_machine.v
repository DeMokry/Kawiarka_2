`timescale 1ns / 1ps


module caffee_machine(
	//zegar
    input clk_1Mhz,                     // zegar 1 Mhz
	
	//przyciski
    input reset,                        // resetuj maszynê do kawy
    input start,                        // rób kawê
	input caffe_sel,					// 0 - s³aba, 1 - mocna
	
	//czujniki
	input caffe_grinded,				// odpowiednia iloœæ kawy zosta³a zmielona
	input water_done,					// wystarczaj¹ca iloœæ wody zosta³a nalana
	input caffe_done,					// sygna³ od czujnika iloœci kawy wsypnej
	input cleaning_done,				// czyszczenie zakoñczone
	
	//wyjœcia steruj¹ce
	output reg big_portion,				// 1 - mocna kawa, 0-s³aba kawa
	output grind_cafe,				    // miel kawê
	output hot_water_pour,			    // lej wody
	output caffe_pour,				    // syp kawy
	output clean_machine,			    // pozbywanie siê pozosta³oœci
	
	//ledy
	output reg idle,					// bezczyny
	output reg working,					// pracuje
    output reg done                     // kawa gotowa
);


	parameter IDLE       = 3'b000;        // stan bezczynnosci
	parameter GRINDING   = 3'b001;        // mielenie
	parameter CAFFE_POUR = 3'b010;        // sypanie kawy
	parameter WATER_POUR = 3'b011;        // zalewanie gor¹ca wod¹
	parameter CLEANING   = 3'b100;        // czyszczenie 

    reg [2:0] status;                     //zmienna przechowuj¹ca obecny status

    always @(posedge clk_1Mhz) begin    // always wywo³uj¹cy siê na ka¿dym zboczu narastaj¹cym zegara clk_1Mhz
        if (reset == 1) begin           // je¿eli przycisk reset wciœniêty
            status  <= IDLE;            // ustawiamy obecny stan na "bezczynnoœæ
            done    <= 1;               
			working <= 0;
			idle	<= 0;
            
        end else begin                  // je¿eli przycisk reset nie jest wciœniêty
            case (status)               // Sprawdzamy zmienn¹ status
                IDLE : begin            // je¿eli jest w niej zapisany obecny stan "idle"
					done    <= 1;               
					working <= 0;
					idle	<= 1;
					if (start == 1)begin			// je¿eli wciœniêty przycisk "start"
						status  	<= GRINDING; 	// przechodzimy do stanu mielenie
						big_portion	<= caffe_sel; 	// zapamiêtujemy stan - czu kawa ma byc mocna czy s³aba
					end
					else                			// je¿eli nie wciœniêty
						status  <= IDLE;			// zostajemy w stanie "Idle"
					end
                    
                GRINDING : begin            // Je¿eli obecny stan to GRINDING
					done    <= 0;               
					working <= 1;
					idle	<= 0;
					
					if (caffe_grinded == 1)begin	// je¿eli odpowiednia iloœæ kawy zosta³a zmielona
						status  	<= CAFFE_POUR; 	// przechodzimy do stanu sypanie kawy
					end
					else                			// je¿eli nie 
						status  <= GRINDING;		// zostajemy w stanie "GRINDING"
					end
				
                CAFFE_POUR : begin			// Je¿eli obecny stan to CAFFE_POUR
					done    <= 0;               
					working <= 1;
					idle	<= 0;
					
					if (caffe_done == 1)begin		// je¿eli odpowiednia iloœæ kawy zosta³a nasypana
						status  	<= WATER_POUR; 	// przechodzimy do stanu zalewanie
					end
					else                			// je¿eli nie
						status  <= CAFFE_POUR;		// zostajemy w stanie "CAFFE_POUR"
					end
					
				WATER_POUR : begin			// Je¿eli obecny stan to WATER_POUR
					done    <= 0;               
					working <= 1;
					idle	<= 0;
					
					if (water_done == 1)begin		// je¿eli odpowiednia iloœæ wody zostanie nalana
						status  	<= CLEANING; 	// przechodzimy do stanu CLEANING
					end
					else                			// je¿eli nie
						status  <= WATER_POUR;		// zostajemy w stanie "CAFFE_POUR"
					end
					
                CLEANING : begin			// Je¿eli obecny stan to CLEANING
					done    <= 1;               
					working <= 1;
					idle	<= 0;
				
					if (cleaning_done == 1)begin	// je¿eli maszyna zostanie wyczyszczona
					   if (start == 0)             // je¿eli ktoœ trzyma³ przycisk, czekamy a¿ go puœci
					       status  	<= IDLE; 		// przechodzimy do stanu IDLE
					end
					else                			// je¿eli nie
				        status  <= CLEANING;		// zostajemy w stanie "CLEANING"
					end
            endcase
        end
    end

assign grind_cafe = (status == GRINDING);
assign hot_water_pour = (status == WATER_POUR);
assign caffe_pour =	(status == CAFFE_POUR);
assign clean_machine = (status == CLEANING);

initial
    big_portion <= 0;
    
    

endmodule

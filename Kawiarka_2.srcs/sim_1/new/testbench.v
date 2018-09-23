`timescale 1ns / 1ps

module test_bench(

    );
    
    reg clk_1Mhz, res, start, caffee_sel;       // in
    wire caffe_grinded, water_done, caffe_done, cleaning_done;  //in from sensors
    wire big_portion, grind_cafe, hot_water_pour, caffe_pour, clean_machine;    //out
    wire idle, working, done;   //out
    
    
    sensor_simulator 
    #(
        .big(20),
        .smal(10)
    )
    czujnik_ilosci_zmielonej_kawy(
        .clk_1Mhz(clk_1Mhz),
        .big_portion(big_portion),
        .start(grind_cafe),
        .done(caffe_grinded)
    );
    
    sensor_simulator 
    #(
        .big(20),
        .smal(10)
    )
    czujnik_ilosci_nasypanej_kawy(
        .clk_1Mhz(clk_1Mhz),
        .big_portion(big_portion),
        .start(caffe_pour),
        .done(caffe_done)
    );
    
    sensor_simulator 
    #(
        .big(20),
        .smal(10)
    )
    czujnik_ilosci_nalanej_wody(
        .clk_1Mhz(clk_1Mhz),
        .big_portion(big_portion),
        .start(hot_water_pour),
        .done(water_done)
    );
    
    sensor_simulator 
    #(
        .big(20),
        .smal(10)
    )
    czujnik_czystosci(
        .clk_1Mhz(clk_1Mhz),
        .big_portion(big_portion),
        .start(clean_machine),
        .done(cleaning_done)
    );
    
    
    caffee_machine kafka_1(
        //zegar
        .clk_1Mhz(clk_1Mhz),                         // zegar 1 Mhz
        
        //przyciski
        .reset(res),                                // resetuj maszynê do kawy
        .start(start),                              // rób kawê
        .caffe_sel(caffee_sel),                     // 0 - s³aba, 1 - mocna
        
        //czujniki
        .caffe_grinded(caffe_grinded),              // odpowiednia iloœæ kawy zosta³a zmielona
        .water_done(water_done),                    // wystarczajÄ…ca iloœæ wody zosta³a nalana
        .caffe_done(caffe_done),                    // sygna³ od czujnika iloœci kawy wsypnej
        .cleaning_done(cleaning_done),              // czyszczenie zakoñczone
        
        //wyjœcia steruj¹ce
        .big_portion(big_portion),                   // 1 - mocna kawa, 0-s³aba kawa
        .grind_cafe(grind_cafe),                     // miel kawê
        .hot_water_pour(hot_water_pour),             // lej wody
        .caffe_pour(caffe_pour),                     // syp kawy
        .clean_machine(clean_machine),               // pozbywanie siê pozosta³oœci
        
        //ledy
        .idle(idle),                                 // bezczyny
        .working(working),                           // pracuje
        .done(done)                                  // kawa gotowa
    );
    
    
    always@* begin
        #500 clk_1Mhz    <= ~clk_1Mhz;
    end

    initial begin
        clk_1Mhz    <= 0;
        res         <= 1;
        start       <= 0;
        caffee_sel  <= 0;
        #1000
        res         <= 0;
        #3000 
        start       <= 1;
        #2000
        start       <= 0;
        wait( idle == 1 )
        caffee_sel  <= 1;
        #1000
        start       <= 1;
        #1000
        start       <= 0;
        
       
    end 

//reg clk_1Mhz, res, start, caffee_sel;       // in

endmodule

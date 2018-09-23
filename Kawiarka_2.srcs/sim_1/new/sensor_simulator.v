`timescale 1us / 1ps

module sensor_simulator(
    input clk_1Mhz,
    input big_portion,
    input start,
    output reg done
    );


initial
    done <= 0;

    parameter big = 100;
    parameter smal = 10;

    always@*begin
    
        if (start == 1)begin
            if ( big_portion == 1 )
                #big done  <= 1;
            else
                #smal done <= 1;
        end
        else
            done <= 0;
        
    
    end

endmodule
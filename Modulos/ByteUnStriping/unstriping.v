`timescale 1ns/1ps

module unstriping (clk, FL0, FL1, FL2, FL3, toDemux);
    input clk;
    input [7:0] FL0; //FromeLane 0
    input [7:0] FL1; //FromeLane 1
    input [7:0] FL2; //FromeLane 2
    input [7:0] FL3; //FromeLane 3

    output [7:0] toDemux;

    reg [7:0] toDemux;

    reg [1:0] c; //Contador para ver que lane se debe usar
    reg D; // D=0 => no estamos transmitiendo datos || D=1 => estamos transmitiendo datos


    parameter COM = 8'hBC,PAD = 8'hF7,SKP = 8'h1C,STP = 8'hFB, SDP = 8'h5C ;
    parameter END = 8'hFD,EDB = 8'hFE,FTS = 8'h3C,IDL = 8'h7C;

    always @ (posedge clk) begin
      if (D) begin
        if (FL3 == END) begin
          toDemux = FL3;
          D=0;
          c=2'b00;
        end else begin
          if (c==2'b00) begin
                toDemux=FL0;
                c = c+1;
            end else if (c==2'b01) begin
                toDemux=FL1;
                c = c+1;
                
            end else if (c==2'b10) begin
                toDemux=FL2;
                c = c+1;
                
            end else if (c==2'b11) begin
                toDemux = FL3;
                c = c+1;
                end  
        end
      end else begin
        if (FL0 == STP) begin
          D=1;
          toDemux = FL0;
          c = 2'b01;
        end
        if (FL0 == SDP) begin
          D=1;
          toDemux = FL0;
          c = 2'b01;
        end
      end
    end
endmodule

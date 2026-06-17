// Top-level para síntese no Cyclone IV EP4CE115F29C7
// Conecta todos os módulos e define as interfaces físicas do FPGA
module TOPLEVEL (
    input        CLOCK_50,   // clock de 50 MHz do FPGA
    input  [17:0] SW,        // 18 chaves do FPGA
    input        KEY0,       // push button ativo baixo
    output [6:0] HEX0,       // display 7 segmentos
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3,
    output [6:0] HEX4,
    output [6:0] HEX5,
    output [6:0] HEX6,
    output [6:0] HEX7
);

    // =========================================================
    // Extensão das chaves de 18 para 32 bits
    // Os 14 bits superiores são zerados
    // =========================================================
    wire [31:0] sw_32bits = {14'b0, SW};

    // =========================================================
    // Clock dividido para o processador
    // Ajuste o DIVISOR conforme a velocidade desejada
    // =========================================================
    wire clk_proc;
    DIVISORFREQUENCIA #(.DIVISOR(25000000)) meu_divisor (
        .clk_in (CLOCK_50),
        .clk_out(clk_proc)
    );

    // =========================================================
    // Módulo do botão com debounce e detecção de borda
    // =========================================================
    wire botton_pulse;
    BOTAO meu_botao (
        .clk   (clk_proc),
        .btn_n (KEY0),
        .BOTTON(botton_pulse)
    );

    // =========================================================
    // Saída do display (32 bits)
    // =========================================================
    wire [31:0] saida_display;

    // =========================================================
    // Datapath geral do processador
    // =========================================================
    DATAPATHGERAL meu_processador (
        .clk              (clk_proc),
        .BOTTON           (botton_pulse),
        .Dado_Switches_Ext(sw_32bits),
        .Saida_Display_Out(saida_display)
    );

    // =========================================================
    // Conversão para display de 7 segmentos
    // =========================================================
    DISPLAY7SEGMENTOS meu_display (
        .dado(saida_display),
        .HEX0(HEX0), .HEX1(HEX1),
        .HEX2(HEX2), .HEX3(HEX3),
        .HEX4(HEX4), .HEX5(HEX5),
        .HEX6(HEX6), .HEX7(HEX7)
    );

endmodule

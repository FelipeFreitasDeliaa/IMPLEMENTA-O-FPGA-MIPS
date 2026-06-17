module BOTAO (
    input  clk,      // clock do processador (já dividido)
    input  btn_n,    // botão físico — ativo em nível baixo (0 = pressionado)
    output reg BOTTON // pulso de 1 ciclo ao pressionar
);
    // Shift register: sincronizador + debounce
    // Exige 4 amostras consecutivas em 1 para considerar botão pressionado
    reg [3:0] shift;
    wire btn_ativo = ~btn_n;  // converte para ativo alto

    always @(posedge clk)
        shift <= {shift[2:0], btn_ativo};

    wire btn_estavel = &shift;  // 1 apenas quando todos os 4 bits são 1

    // Detector de borda de subida: gera pulso de 1 ciclo no primeiro press
    // Se o usuário mantiver o botão pressionado, BOTTON volta a 0 no ciclo seguinte
    // Novo pulso só ocorre após soltar e pressionar novamente
    reg btn_prev;
    always @(posedge clk) begin
        btn_prev <= btn_estavel;
        BOTTON   <= btn_estavel & ~btn_prev;
    end

endmodule

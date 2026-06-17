module PROGRAMCOUNTER (
    input        clk,
    input        HLT,
    input        Stall,    // NOVO — trava PC durante IN sem botão
    input        Branch,
    input        z_flag,
    input        Jump,
    input        JR,
    input [31:0] Imediato_Branch,
    input [31:0] Imediato_Jump,
    input [31:0] Endereco_JR,
    output reg [31:0] PC_atual
);
    initial begin
        PC_atual = 32'd0;
    end

    always @(negedge clk) begin
        if (HLT)
            PC_atual <= PC_atual;
        else if (Stall)         // NOVO
            PC_atual <= PC_atual;
        else if (JR)
            PC_atual <= Endereco_JR;
        else if (Jump)
            PC_atual <= Imediato_Jump;
        else if (Branch && z_flag)
            PC_atual <= PC_atual + 32'd1 + Imediato_Branch;
        else
            PC_atual <= PC_atual + 32'd1;
    end
endmodule

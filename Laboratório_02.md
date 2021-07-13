# Laboratório 2



## Exercício 10

>  Idealize uma sub rotina que utilize o algoritmo
> de deslocamentos e adições sucessivas para
> computar o produto entre dois valores de 16
> bits
>
> Sub rotina Mul16b:
>
> - Entrada: registradores R0 e R1
>
> - Saída: registrador R2 (produto)
>           

```
// INICIO DA SUBROTINA
Mul16b
        PUSH {R3-R6} ; armazena estado atual. Exceto R0,R1 e R2 .
        MOV R2, #0 ; VALOR INICIAL DE R2
        CMP R0, #0
        BEQ Mul16b_Fim ; TESTA SE UM DOS DOIS ARGUMENTOS É ZERO
        CMP R1, #0
        BEQ Mul16b_Fim ; TESTA SE UM DOS DOIS ARGUMENTOS É ZERO
```

Este pedaço testa se um dos argumentos é zero. Se for, o resultado da multiplicação já e3stá armazenado em R2 é o correto e então pula para o fim da rotina.

```
        MOV R4, R0 ; registradores de trabalho  
        MOV R5, R1 ; inicializados.(preservam valores de entrada)
Mul16b_MainLoop
        ANDS R3, R5, #1
        CMP R3,#1
        BNE Mul16b_PulaSoma
        ADD R2,  R4 ;  SOMA R0 SE LSB DE R1 FOR 1
Mul16b_PulaSoma

```

Prepara registradores de trabalho para operações de deslocamento, para preservar registradores de entrada.

Testa  o bit menos significativo de R1, armazenando o resultado em R7 para preservar o valor de R1.

Se o valor deste bit for um, então soma o atual valor de R0 em R2. Senão, não soma.

```
        LSR R5, R5, #1 ; desloca r5 para a direita
        LSL R4, R4, #1 ; desloca r4 para a esquerda
```

Desloca-se (logicamente) o registrador R0 para a esquerda e o registrador R1 para a direita preparando o estado dos registradores para o novo ciclo. R0 e R1 são modificados nesta subrotina.

```
        CMP R5, #0 ; se R5 zerou completamente...
        BEQ Mul16b_Fim
        B Mul16b_MainLoop
```

Se não houverem mais bits no registrador R1, finaliza a subrotina. Senão volta para o loop que compara o último bit de R1...

```
Mul16b_Fim
        POP {R3-R6} ; recupera estado inicial
        BX LR
// FINAL DA SUBROTINA
```

Finaliza subrotina.





# Exercício 11

> Idealize uma sub rotina que calcule o fatorial
> de um número com resultado de 32 bits
>
> - Parâmetro de entrada: R0
> - Valor de retorno: R0
> - Os valores de todos os demais registradores do
>   processador deverão ser preservados
> - Idealize uma forma de retornar o valor -1 caso
>   o resultado do fatorial extrapole 32 bits

 O maior fatorial que cabe em 32 bits é 12!

```
// SUBROTINA FATORIAL

fatorial
        PUSH {R1} ; armazena estado atual do registrador utilizado como auxiliar.
        CMP R0, #12
        BHI fatorial_estouro ; SE FOR MAIOR QUE 12, ESTOURA A QUANTIDADE DE BITS
        
        
        CMP R0,#0           ; TESTA FATORIAL DE ZERO 0! = 1 POR DEFINIÇÃO
        BEQ fatorial_fim_1  ;
```

Salva o estado do registrador R1 usado nesta subrotina

Testa se R0 é maior do que 12. Se for, o resultado não caberá em 32 bits, então desvia para o tratamento de estouro.

Testa se R0 é Zero. Neste caso, por definição da fatorial (função Gamma), o resultado é 1.  desvia para o tratamento deste caso específico.

```
        MOV R1, R0 ; COPIA VALOR INICIAL
        SUBS R1, R0, #1 ; SUBTRAI 1 DO VALOR
        BEQ fatorial_fim ; SE RESULTOU EM ZERO É FATORIAL DE 1!, CUJO RESULTADO É 1
```

Subtrai 1 do valor inicial e coloca no registrador R1. Testa este registrador, se zero, então o resultado já está em R0. Se 1, então o  resultado também está em R0. Desvia para o fim,

```
fatorial_loop
        MUL R0, R1
        SUBS R1, #1
        BEQ fatorial_fim
        B fatorial_loop
```

Loop para cálculo do fatorial 

R0 = R0 * R1

R1 = R1 - 1

Se R1=0, sai do loop

```
fatorial_fim_1
        MOV R0, #1
        B fatorial_fim        

// EM CASO DE ESTOURO
fatorial_estouro
        MOV R0, #-1
        B fatorial_fim        
        
fatorial_fim        
        POP {R1} ; recupera valores anteriores
        BX LR
        
// FIM DA SUBROTINA FATORIAL

```

Tratamento das condições de saída.

Recuperação do valor original do registrador de trabalho.
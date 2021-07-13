        PUBLIC  __iar_program_start
        PUBLIC  __vector_table

        SECTION .text:CODE:REORDER(1)
        
        ;; Keep vector table even if it's not referenced
        REQUIRE __vector_table
        
        THUMB
        
__iar_program_start


//Exercício
//11
//•
//Idealize uma sub rotina que calcule o fatorial
//de um número com resultado de 32 bits
//–
//Parâmetro de entrada: R0
//–
//Valor de retorno: R0
//–
//Os valores de todos os demais registradores do
//processador deverão ser preservados
//•
//Idealize uma forma de retornar o valor -1 caso
//o resultado do fatorial extrapole 32 bits

// maior fatorial que cabe em 32 bits é 12!

main       
        MOV R1, #8
        MOV R3, #12
        MOV R5, #32
        MOV R7, #1
        MOV R9, #0

        MOV R0, R1
        BL fatorial
        MOV R2, R0
        
        MOV R0, R3
        BL fatorial
        MOV R4, R0

        MOV R0, R5
        BL fatorial
        MOV R6, R0

        MOV R0, R7
        BL fatorial
        MOV R8, R0

        MOV R0, R9
        BL fatorial
        MOV R10, R0


        B       main


// SUBROTINA FATORIAL

fatorial
        PUSH {R1} ; armazena estado atual do registrador utilizado como auxiliar.
        CMP R0, #12
        BHI fatorial_estouro ; SE FOR MAIOR QUE 12, ESTOURA A QUANTIDADE DE BITS
        
        
        CMP R0,#0           ; TESTA FATORIAL DE ZERO 0! = 1 POR DEFINIÇÃO
        BEQ fatorial_fim_1  ;
       
        MOV R1, R0 ; COPIA VALOR INICIAL
        SUBS R1, R0, #1 ; SUBTRAI 1 DO VALOR
        BEQ fatorial_fim ; SE RESULTOU EM ZERO É FATORIAL DE 1!, CUJO RESULTADO É 1
fatorial_loop
        MUL R0, R1
        SUBS R1, #1
        BEQ fatorial_fim
        B fatorial_loop
        

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
       
        ;; Forward declaration of sections.
        SECTION CSTACK:DATA:NOROOT(3)
        SECTION .intvec:CODE:NOROOT(2)
        
        DATA

__vector_table
        DCD     sfe(CSTACK)
        DCD     __iar_program_start

        DCD     NMI_Handler
        DCD     HardFault_Handler
        DCD     MemManage_Handler
        DCD     BusFault_Handler
        DCD     UsageFault_Handler
        DCD     0
        DCD     0
        DCD     0
        DCD     0
        DCD     SVC_Handler
        DCD     DebugMon_Handler
        DCD     0
        DCD     PendSV_Handler
        DCD     SysTick_Handler

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Default interrupt handlers.
;;

        PUBWEAK NMI_Handler
        PUBWEAK HardFault_Handler
        PUBWEAK MemManage_Handler
        PUBWEAK BusFault_Handler
        PUBWEAK UsageFault_Handler
        PUBWEAK SVC_Handler
        PUBWEAK DebugMon_Handler
        PUBWEAK PendSV_Handler
        PUBWEAK SysTick_Handler

        SECTION .text:CODE:REORDER:NOROOT(1)
        THUMB

NMI_Handler
HardFault_Handler
MemManage_Handler
BusFault_Handler
UsageFault_Handler
SVC_Handler
DebugMon_Handler
PendSV_Handler
SysTick_Handler
Default_Handler
__default_handler
        CALL_GRAPH_ROOT __default_handler, "interrupt"
        NOCALL __default_handler
        B __default_handler

        END

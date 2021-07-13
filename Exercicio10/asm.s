        PUBLIC  __iar_program_start
        PUBLIC  __vector_table

        SECTION .text:CODE:REORDER(1)
        
        ;; Keep vector table even if it's not referenced
        REQUIRE __vector_table
        
        THUMB
        
__iar_program_start
        
        
//Exercício 10
//•
//Idealize uma sub rotina que utilize o algoritmo
//de deslocamentos e adições sucessivas para
//computar o produto entre dois valores de 16
//bits
//•
//Sub rotina Mul16b:
//–
//Entrada: registradores R0 e R1
//–
//Saída: registrador R2 (produto)
        
        
        
main    
        MOV R4, #453
        MOV R5, #45
        
        MOV R0, R4
        MOV R1, R5
        BL Mul16b
        MOV R6, R2

        MOV R4, #0
        MOV R5, #45
        
        MOV R0, R4
        MOV R1, R5
        BL Mul16b
        MOV R8, R2

        MOV R4, #453
        MOV R5, #0
        
        MOV R0, R4
        MOV R1, R5
        BL Mul16b
        MOV R9, R2
        
        
        MOV R4, #0
        MOV R5, #0
        
        MOV R0, R4
        MOV R1, R5
        BL Mul16b
        MOV R10, R2

        B       main

// INICIO DA SUBROTINA
Mul16b
        PUSH {R3-R6} ; armazena estado atual. Exceto R0,R1 e R2 .
        
        MOV R2, #0 ; VALOR INICIAL DE R2
        CMP R0, #0
        BEQ Mul16b_Fim ; TESTA SE UM DOS DOIS ARGUMENTOS É ZERO
        CMP R1, #0
        BEQ Mul16b_Fim ; TESTA SE UM DOS DOIS ARGUMENTOS É ZERO

        MOV R4, R0 ; registradores de trabalho  
        MOV R5, R1 ; inicializados.(preservam valores de entrada)
        
Mul16b_MainLoop
        ANDS R3, R5, #1
        CMP R3,#1
        BNE Mul16b_PulaSoma
        ADD R2,  R4 ;  SOMA R0 SE LSB DE R1 FOR 1
 
Mul16b_PulaSoma
        LSR R5, R5, #1 ; desloca r5 para a direita
        LSL R4, R4, #1 ; desloca r4 para a esquerda
        
        CMP R5, #0 ; se R5 zerou completamente...
        BEQ Mul16b_Fim
        B Mul16b_MainLoop
        
Mul16b_Fim

        POP {R3-R6} ; recupera estado inicial
        BX LR
// FINAL DA SUBROTINA

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

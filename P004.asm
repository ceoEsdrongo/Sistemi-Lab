;**************************************************
;*** Struttura base programma con la PIC 16F84 ***
;***                                            ***
;    [Programma assoluto]
;
; (c) 2023, Federico Melon
;
;**************************************************
        PROCESSOR       16F84A	          ; definizione del tipo di Pic per il quale è stato scritto il programma
        RADIX           DEC	              ; i numeri scritti senza notazione sono da intendersi come decimali
        INCLUDE         "P16F84A.INC"     ; inclusione del file che contiene la definizione delle costanti di riferimento al file dei registri (memoria Ram)
        ERRORLEVEL      -302		        ; permette di escludere alcuni errori di compilazione, la segnalazione 302 ricorda di commutare il banco di memoria qualora si utilizzino registri che non stanno nel banco 0


        ;Setup of PIC configuration flags
        ;XT oscillator
        ;Disable watch dog timer
        ;Enable power up timer
        ;Disable code protect
        __CONFIG        _XT_OSC & _CP_OFF & _WDT_OFF &_PWRTE_ON

;=============================================================
;       DEFINE
;=============================================================
; Definizione comandi
; #define  Bank1	bsf     STATUS,RP0		              ; Attiva banco 1
; #define  Bank0 bcf     STATUS,RP0	                  ; Attiva banco 0
;=============================================================
; 		SIMBOLI
;=============================================================
; LABEL	CODE 	OPERANDO	COMMENTO
;=============================================================
LED_ON  EQU     01					                  ; Led acceso
LED_OFF EQU	    00					                  ; Led spento
;=============================================================
;       AREA DATI
;=============================================================	
; LABEL	CODE 	OPERANDO	COMMENTO
;=============================================================
REG1    EQU     0x0C					  
REG2    EQU     0x0D
;=============================================================
;       PROGRAMMA PRINCIPALE
;=============================================================
; LABEL	CODE 	OPERANDO	COMMENTO
;=============================================================        ;Reset Vector
        ;Start point at CPU reset
        ORG     0x0000				                  ; indirizzo di inizio programma
        goto    Main
;=============================================================
;       INTERRUPT AREA
;=============================================================
        ORG     0x0004				                  ; indirizzo inizio routine interrupt
        retfie					                          ; ritorno programma principale
;=============================================================
;       AREA PROGRAMMA PRINCIPALE
;=============================================================
Main:
; Codice Programma
        bsf     STATUS,RP0			                  ; attiva banco 1
        movlw   B'00000000'
        movwf   TRISA 				                  ; bit della porta A definiti come uscite
        movlw   0					                  ; bit della porta B definiti come uscite
        movwf   TRISB
        bcf     STATUS,RP0	                          ; attiva banco 0
        clrf    PORTB                                  ; Inizializza PORTB a 0
LoopBit0:
        movlw   LED_ON				                  ; Accendi il LED collegato al bit 0 di PORTB
        movwf   PORTB
        call    Delay_1Hz                             ; Delay per 1 Hz
        movlw   LED_OFF				                  ; Spegne il LED collegato al bit 0 di PORTB
        movwf   PORTB
        call    Delay_1Hz                             ; Delay per 1 Hz
        goto    LoopBit1                               ; Passa al lampeggio per il bit 1 di PORTB
LoopBit1:
        movlw   LED_ON				                  ; Accendi il LED collegato al bit 1 di PORTB
        movwf   PORTB
        call    Delay_05Hz                            ; Delay per 0.5 Hz
        movlw   LED_OFF				                  ; Spegne il LED collegato al bit 1 di PORTB
        movwf   PORTB
        call    Delay_05Hz                            ; Delay per 0.5 Hz
        goto    LoopBit0                               ; Torna al lampeggio per il bit 0 di PORTB
;=============================================================
;       AREA ROUTINE
;=============================================================
Delay_1Hz:
    movlw   0x86        ; Carica il valore per ottenere un ritardo di circa 1 secondo
    movwf   REG1        ; Carica il conteggio
Delay_1Hz_Loop:
    movlw   0xA0        ; Carica il valore per il conteggio interno (ottenuto empiricamente per avere 1 secondo con frequenza 4MHz)
    movwf   REG2        ; Carica il conteggio interno
Delay_1Hz_Loop1:
    nop                 ; Delay loop
    nop                 ; Due NOP per ogni ciclo
    decfsz  REG2, f     ; Decrementa il conteggio interno
    goto    Delay_1Hz_Loop1  ; Continua il loop interno finché non è zero
    decfsz  REG1, f     ; Decrementa il conteggio esterno
    goto    Delay_1Hz_Loop   ; Continua il loop esterno finché non è zero
    return

Delay_05Hz:
    movlw   0x43        ; Carica il valore per ottenere un ritardo di circa 2 secondi (perché la frequenza è dimezzata rispetto a 1Hz)
    movwf   REG1        ; Carica il conteggio
Delay_05Hz_Loop:
    movlw   0xA0        ; Carica il valore per il conteggio interno (ottenuto empiricamente per avere 1 secondo con frequenza 4MHz)
    movwf   REG2        ; Carica il conteggio interno
Delay_05Hz_Loop1:
    nop                 ; Delay loop
    nop                 ; Due NOP per ogni ciclo
    decfsz  REG2, f     ; Decrementa il conteggio interno
    goto    Delay_05Hz_Loop1  ; Continua il loop interno finché non è zero
    decfsz  REG1, f     ; Decrementa il conteggio esterno
    goto    Delay_05Hz_Loop   ; Continua il loop esterno finché non è zero
    return

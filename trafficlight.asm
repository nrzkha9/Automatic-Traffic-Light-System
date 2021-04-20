	#include<p18f4550.inc>

loop1 		set 0x00
loop2 		set 0x01

			org 0x00
 			goto start
			org 0x08
			retfie
			org 0x18
			retfie

nothing 	macro n
			variable i
i=0
			while i < n
			nop
i+=1
			endw
			endm

;******************************************************************
;******************************************************************

start		CLRF	TRISC
			CLRF	TRISD
			CLRF	PORTD,A
			CLRF	TRISA
			CLRF	PORTA,A
			
traffic		CLRF	PORTC,A
			BSF		PORTC,0,A    ;red(1)
			BSF		PORTC,6,A    ;green(2)
			BTFSC	PORTB,0,A
			BRA		pedestrian
			CALL	led1         ;delay7sec
			CLRF	PORTC,A
			BSF		PORTC,5,A    ;yellow(2)
			BSF		PORTC,0,A    ;red(1)
			BTFSC	PORTB,0,A
			BRA		pedestrian
			CALL	CONT         ;delay3sec
			CLRF	PORTC,A
			BSF		PORTC,2,A    ;green(1)
			BSF		PORTC,4,A    ;red(2)
			BTFSC	PORTB,0,A
			BRA		pedestrian
			CALL	led1    	 ;delay7sec
			CLRF	PORTC,A
			BSF		PORTC,1,A    ;yellow(1)
			BSF		PORTC,4,A    ;red(2)
			BTFSC	PORTB,0,A
			BRA		pedestrian
			CALL	CONT		 ;delay3sec
			BRA		traffic

;*********************************************************************
;**********************************************************************

pedestrian	CLRF	PORTC,A
			BSF		PORTC,0,A    ;red(1)
			BSF		PORTC,4,A    ;red(2)
			CALL	ped		     ;delay10sec
			CLRF	PORTC,A
			BRA		traffic

;******************************************************************
;******************************************************************

ped			clrf	PORTA, A
			CLRF	PORTD,A
			movlw	B'00000110'
			movwf	PORTA,A
			call    DELAY
			clrf	PORTA, A
			movlw	B'00111111'
			movwf	PORTA,A
ALL	 		MOVLW D'9'
			MOVWF PRODH,A
COUNT3 		MOVLW D'10'          ;count=10
			MOVWF PRODL,A
DISPLAY3 	MOVFF PRODH,PORTD    ;move number to BCD
			CALL DELAY
			DECF PRODH,F,A
			DECFSZ PRODL,F,A     ;count decrease by 1
			BRA DISPLAY3
			RETURN

;********************************************************************
;********************************************************************

led1		clrf	PORTA, A
			movlw	B'00000110'
			movwf	PORTA,A
			call    DELAY
			clrf	PORTA, A
			movlw	B'00111111'
			movwf	PORTA,A
FIRST 		MOVLW 	D'9'
			MOVWF 	PRODH,A
COUNT1 		MOVLW 	D'6'   		  ;count=6
			MOVWF 	PRODL,A
DISPLAY1 	MOVFF 	PRODH,PORTD   ;move number to BCD
			CALL 	DELAY
			DECF 	PRODH,F,A
			DECFSZ 	PRODL,F,A     ;count decrease by 1
			BRA 	DISPLAY1
			RETURN	

CONT 		MOVLW 	D'3'
			MOVWF 	PRODH,A
COUNT2 		MOVLW 	D'4'          ;count=4
			MOVWF 	PRODL,A
DISPLAY2 	MOVFF 	PRODH,PORTD   ;move number to BCD
			CALL 	DELAY
			DECF 	PRODH,F,A
			DECFSZ 	PRODL,F,A     ;count decrease by 1
			BRA 	DISPLAY2
			RETURN

;***********************************************************************
;***********************************************************************

DELAY 		MOVLW D'250'          ;1sec delay subroutine
			MOVWF loop2,A         ;5MHz frequency
AGAIN5 		MOVLW D'250'
			MOVWF loop1,A
AGAIN6 		nothing D'17'
			DECFSZ loop1,F,A
			BRA AGAIN6
			DECFSZ loop2,F,A
			BRA AGAIN5
			NOP
			RETURN
			END




































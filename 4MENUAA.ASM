;	Israel Celis Campagnoli
;	twitter @israelcelis1310
;	https://ve.linkedin.com/in/israelceliscampagnoli
;	Practicas en Assembler Digitales III
;	Universidad Nacional Experimental "Antonio Jóse de Sucre"
;	Vicerectorado "Luis Caballero Mejías"
		
       .MODEL SMALL                 
       .STACK 100H
	.DATA

	PROM DB 00H
	PAG DB 00H
	FILA DB 00H
	COLUMNA DB 00H
	PR DB "		1.- Horizontal",0AH,0AH,0AH,0DH
	   DB "		2.- Vertical",0AH,0AH,0AH,0DH
	   DB "		3.- Cuadrilatero",0AH,0AH,0AH,0DH
	   DB "	        4.- Diagonal",0AH,0AH,0AH,0DH
	   DB "		5.- Triangulo",0AH,0AH,0AH,0DH
	   DB "		6.- Salir$",0DH
	ET1 DB "	Tipo:",0AH,0AH,0AH,0DH
	    DB "	P1F:",0AH,0AH,0AH,0DH
	    DB "	P2F:",0AH,0AH,0AH,0DH
	    DB "	P1C:",0AH,0AH,0AH,0DH
	    DB "	P2C:",0AH,0AH,0AH,0DH
	FM2 DB "$",0DH
	    DB "	P3F:",0AH,0AH,0AH,0DH
	    DB "	P3C:$"

	CADENA LABEL BYTE
	MAX DB 04H
	NREAL DB ?
	BUFFER DB 04H
	
	TIPO DB 00H
	P1F DW 00H
	P1C DW 00H
	P2F DW 00H
	P2C DW 00H
	P3F DW 00H
	P3C DW 00H
	FORMATO1 DB 0DH DUP(0)
	FORMATO2 DB 13H DUP(0)
	SW	DW ?
	FCORD1 		DW 0000H
	CCORD1 		DW 0000H
	FCORD2		DW 0000H
	CCORD2		DW 0000H
	ATRIBUTO        DB 03H
	PENDIENTE	DW ?
	DIVISOR		DW ?
	RESTO		DW ?
	CUENTA		DW ?
	
	.CODE
	MOV AX,SEG PROM
	MOV DS,AX
	MOV ES,AX
	
PG0:	CALL BORPA
	CALL PANT
	MOV FILA,04H
	MOV COLUMNA,00H
	CALL CURSOR
	MOV DX,OFFSET PR
	CALL IMPRIME

	
	MOV PAG,00H
	CALL PANT

L1:	CALL TECLA
	CMP AL,"1"
	JE S1
	CMP AL,"2"
	JE S2           
	CMP AL,"3"
	JE S3
	CMP AL,"4"
	JE S4
	CMP AL,"5"
	JE S5
	CMP AL,"6"
	JMP FIN

S1:	MOV TIPO,"H"
	JMP PG
S2:	MOV TIPO,"V"
	JMP PG
S3:	MOV TIPO,"C"
	JMP PG
S4:	MOV TIPO,"D"
	JMP PG
S5:	MOV TIPO,"T"
	JMP PT

PT:	MOV FM2,00H
	
PG:	MOV PAG,01H
	PUSH AX
	CALL PANT
	MOV FILA,02H
	MOV COLUMNA,00H
	CALL CURSOR
	MOV DX,OFFSET ET1
	CALL IMPRIME
	MOV COLUMNA,13
	CALL CURSOR
	POP AX       
	MOV AH,09H
	MOV BL,07H
	MOV CX,01H
	INT 10H
	
	CMP TIPO,"T"
	JNE SIG
	MOV CX,06
	JMP SIG1
SIG:	MOV CX,04
	INC FILA
	INC FILA
	INC FILA

SIG1:	MOV DI,OFFSET P1F
VUELVE1:MOV DX,OFFSET CADENA
       
VUELVE:	CALL CURSOR
	MOV DX,OFFSET CADENA
	CALL EDITA 
	CALL REVISA
	MOV ES:[DI],BX
	INC DI
	INC DI
	INC FILA 
	INC FILA
	INC FILA
	LOOP VUELVE1
	

DIBUJA:	MOV AL,0FH
	CALL MODO
	MOV AX,P1F
	MOV BX,P2F
	CMP AX,BX
	JNE PASO2
	MOV AX,P1C
	MOV BX,P2C
	CMP AX,BX
	JNE PASO1
	CALL PUNTO
	JMP FIN

PASO1:	JA INVIERTE
	MOV AX,P1F
	MOV FCORD1,AX
	MOV FCORD2,AX
	MOV AX,P1C
	MOV CCORD1,AX
	MOV AX,P2C
	MOV CCORD2,AX
	CALL HORIZONTAL
	JMP FIN
INVIERTE: MOV AX,P1F
	MOV FCORD1,AX
	MOV FCORD2,AX
	MOV AX,P1C
	MOV CCORD2,AX
	MOV AX,P2C
	MOV CCORD1,AX
	CALL HORIZONTAL
	JMP FIN

PASO2:	MOV AX,P1C
	MOV BX,P2C
	CMP AX,BX
	JNE PASO3
	MOV AX,P1F
	MOV BX,P2F
	CMP AX,BX	
	JA INVIERTE1
	MOV AX,P1F
	MOV FCORD1,AX
	MOV AX,P2F
	MOV FCORD2,AX
	MOV AX,P1C
	MOV CCORD1,AX
	MOV CCORD2,AX
	CALL VERTICAL
	JMP FIN
INVIERTE1: MOV BX,P2C
	MOV CCORD1,BX
	MOV CCORD2,BX
	MOV AX,P1F
	MOV FCORD2,AX
	MOV AX,P2F
	MOV FCORD1,AX
	CALL VERTICAL
	JMP FIN

PASO3:	MOV AX,P1F
	MOV BX,P2F
	CMP AX,BX
	JA CASO2
	MOV AX,P1C
	MOV BX,P2C
	CMP AX,BX
	JNB CASO3
CASO1:	MOV AX,P1F
	MOV FCORD1,AX
	MOV AX,P1C
	MOV CCORD1,AX
	MOV AX,P2F
	MOV FCORD2,AX
	MOV AX,P2C
	MOV CCORD2,AX
	CALL PENDIENTE_N
	JMP FIN

CASO2:	MOV AX,P1C
	MOV BX,P2C
	CMP AX,BX
	JNA CASO4
	MOV AX,P2F
	MOV FCORD1,AX
	MOV AX,P2C
	MOV CCORD1,AX
	MOV AX,P1F
	MOV FCORD2,AX
	MOV AX,P1C
	MOV CCORD2,AX
	CALL PENDIENTE_N
	JMP FIN

CASO3: 	MOV AX,P1F
	MOV FCORD1,AX
	MOV AX,P1C
	MOV CCORD1,AX
	MOV AX,P2F
	MOV FCORD2,AX
	MOV AX,P2C
	MOV CCORD2,AX
	CALL PENDIENTE_P
	JMP FIN

CASO4: 	MOV AX,P2F
	MOV FCORD1,AX
	MOV AX,P2C
	MOV CCORD1,AX
	MOV AX,P1F
	MOV FCORD2,AX
	MOV AX,P1C
	MOV CCORD2,AX
	CALL PENDIENTE_P
	JMP FIN

;AREA DE RUTINAS PARA DIBUJAR FIGURAS

PUNTO:	MOV AH,0CH
	MOV BH,00H
	MOV AL,ATRIBUTO
	MOV DX,P1F
	MOV CX,P1C
	INT 10H
	RET

HORIZONTAL:	MOV BP,CCORD2
		SUB BP,CCORD1
		INC BP
		MOV CX,CCORD1
LAZO1:		MOV AH,0CH
		MOV BH,00H
		MOV AL,ATRIBUTO
		MOV DX,FCORD1
		INT 10H
		INC CX
		DEC BP
		JNZ LAZO1
		RET

VERTICAL:       MOV BP,FCORD2	
		SUB BP,FCORD1
		INC BP
		MOV CX,FCORD1
LAZO2:		MOV AH,0CH
		MOV BH,00H
		MOV AL,ATRIBUTO
		MOV DX,CCORD1
		INT 10H
		INC DX
		DEC BP
		JNZ LAZO2
		RET

PENDIENTE_N:	MOV AX,CCORD2
		SUB AX,CCORD1
		MOV BX,FCORD2
		SUB BX,FCORD1
		CMP AX,BX
		JNAE INVIERTE2
		MOV BP,0000H
		MOV DIVISOR,BX
		MOV DX,0000H
		DIV BX
		MOV RESTO,DX
		MOV CUENTA,0000H
		MOV PENDIENTE,AX
		MOV DX,FCORD1
		MOV CX,CCORD1
LAZO30:		MOV DI,PENDIENTE
		ADD DI,BP
		MOV BP,0000H
LAZO31:		MOV AH,0CH
		MOV BH,00H
		MOV AL,ATRIBUTO
		INT 10H
		INC CX
		DEC DI
		JNZ LAZO31
		INC DX
		CMP DX,FCORD2
		JAE SIGU1
		MOV AX,RESTO
		ADD AX,CUENTA
		MOV CUENTA,AX
		CMP AX,DIVISOR
		JNAE SIGUE1
		INC BP
		MOV AX,CUENTA
		SUB AX,DIVISOR
		MOV CUENTA,AX
SIGUE1:		CMP DX,FCORD2
		JNAE LAZO30
SIGU1:		RET

INVIERTE2:   	XCHG AX,BX
		MOV BP,0000H
		MOV DIVISOR,BX
		MOV DX,0000H
		DIV BX
		MOV RESTO,DX
		MOV CUENTA,0000H
		MOV PENDIENTE,AX
		MOV DX,FCORD1
		MOV CX,CCORD1
LAZO32:		MOV DI,PENDIENTE
		ADD DI,BP
		MOV BP,0000H
LAZO33:		MOV AH,0CH
		MOV BH,00H
		MOV AL,ATRIBUTO
		INT 10H
		INC DX
		CMP DX,FCORD2
		JAE SIGU2
		DEC DI
		JNZ LAZO33
		INC CX
		MOV AX,RESTO
		ADD AX,CUENTA
		MOV CUENTA,AX
		CMP AX,DIVISOR
		JNAE SIGUE2
		INC BP
		MOV AX,CUENTA
		SUB AX,DIVISOR
		MOV CUENTA,AX
SIGUE2:		CMP DX,FCORD2
		JNAE LAZO32
SIGU2:		RET

PENDIENTE_P:	MOV AX,CCORD1
		SUB AX,CCORD2
		MOV BX,FCORD2
		SUB BX,FCORD1
		CMP AX,BX
		JNAE INVIERTE3
		MOV BP,0000H
		MOV DIVISOR,BX
		MOV DX,0000H
		DIV BX
		MOV RESTO,DX
		MOV CUENTA,0000H
		MOV PENDIENTE,AX
		MOV DX,FCORD1
		MOV CX,CCORD1
LAZO40:		MOV DI,PENDIENTE
		ADD DI,BP
		MOV BP,0000H
LAZO41:		MOV AH,0CH
		MOV BH,00H
		MOV AL,ATRIBUTO
		INT 10H
		DEC CX
		DEC DI
		JNZ LAZO41
		INC DX
		CMP DX,FCORD2
		JAE SIGU4
		MOV AX,RESTO
		ADD AX,CUENTA
		MOV CUENTA,AX
		CMP AX,DIVISOR
		JNAE SIGUE4
		INC BP
		MOV AX,CUENTA
		SUB AX,DIVISOR
		MOV CUENTA,AX
SIGUE4:		CMP DX,FCORD2
		JNAE LAZO40
SIGU4:		RET

INVIERTE3:   	XCHG AX,BX
		MOV BP,0000H
		MOV DIVISOR,BX
		MOV DX,0000H
		DIV BX
		MOV RESTO,DX
		MOV CUENTA,0000H
		MOV PENDIENTE,AX
		MOV DX,FCORD1
		MOV CX,CCORD1
LAZO42:		MOV DI,PENDIENTE
		ADD DI,BP
		MOV BP,0000H
LAZO43:		MOV AH,0CH
		MOV BH,00H
		MOV AL,ATRIBUTO
		INT 10H
		INC DX
		CMP DX,FCORD2
		JAE FIN2
		DEC DI
		JNZ LAZO43
		INC CX
		MOV AX,RESTO
		ADD AX,CUENTA
		MOV CUENTA,AX
		CMP AX,DIVISOR
		JNAE SIGUE3
		INC BP
		MOV AX,CUENTA
		SUB AX,DIVISOR
		MOV CUENTA,AX
SIGUE3:		CMP DX,FCORD2
		JNAE LAZO42
FIN2:  		CALL TECLA
       		MOV AX,4C00H
		INT 21H


		    ;********INTERRUPCIONES*********
MODO:	MOV AH,00H
	MOV AL,0FH
	INT 10H
	RET

CURSOR:	MOV AH,02H
	MOV BH,PAG
	MOV DH,FILA
	MOV DL,COLUMNA 
	INT 10H 
   	RET

IMPRIME: MOV AH,09H
	INT 21H
	RET

EDITA:	MOV AH,0AH
	INT 21H
	RET

PANT:	MOV AH,05H
	MOV AL,PAG
	INT 10H
	RET

TECLA:	MOV AH,00H
	INT 16H
	RET

BORPA:	MOV AH,00H
	MOV AL,03H
	INT 10H
	RET
	

REVISA:	MOV SI,OFFSET BUFFER
R0:	MOV AL,DS:[SI]
	
	CMP AL,30H
	JAE R1
	JMP VUELVE
R1:	CMP AL,39H
	JBE R2
	JMP VUELVE
R2:	AND AL,0FH
	JMP R5
	CMP AL,41H
	JAE R3
	JMP VUELVE
R3:	CMP AL,46H
	JBE R4
	JMP VUELVE
R4:	SUB AL,37H
R5:	INC SI
	CALL GUARDA
	DEC NREAL
	JNZ R0
RF:	RET

GUARDA:	CMP NREAL,03H
	JE GUA1
	CMP NREAL,02H
	JE GUA2
	ADD BL,AL
	JMP FG
GUA1:	MOV BH,AL
	JMP FG
GUA2:	MOV BL,AL
	ROL BL,04H
FG:	RET

ERROR:	MOV AX,4C01H
	JMP FINAL1

FIN:	MOV AX,4C00H

FINAL1:	INT 21H
	END
	
						     

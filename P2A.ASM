;	Israel Celis Campagnoli
;	twitter @israelcelis1310
;	https://ve.linkedin.com/in/israelceliscampagnoli
;	Practicas en Assembler Digitales III
;	Universidad Nacional Experimental "Antonio J�se de Sucre"
;	Vicerectorado "Luis Caballero Mej�as"		
		.Model Small
		.Stack 100h
		.Data
TEXTO  		DB 'va Actualmente, el Big Data es una de las sombras m�s '
		DB 'alargadas en la administraci�n americana tras la '
		DB 'revelaci�n de las pol�micas escuchas que realizaran la '
		DB 'NSA a ciudadanos americanos ya l�deres internacionales, Angela '
		DB 'Merkel incluida, bajo el pretexto de la seguridad del pa�s. '
		DB 'Para atenuar la pol�mica, a principios de enero, Obama '
		DB 'encomendo a su equipo de gobierno un an�lisis sobre la '
		DB 'relaci�n entre Big Data ya privacidad. La reflexi�n ' 
		DB 'incluye tres charlas en prestigiosas universidades '
		DB 'americanas que tendr�n lugar en los pr�ximos noventa d�as. '
		DB 'El MIT abord� el primer round ay el resultado no fue '
		DB 'muy prometedor. mucho business ay poca privacidad. '
		DB 'La presencia de la NSA en el evento qued� relegada '
		DB 'al ultimo panel de la conferencia con la representaci�n '
		DB 'de John DeLong, directivo de la agencia. Seg�n relata el '
		DB 'BetaBoston, la comparecencia del directivo deber�a haber '
		DB 'sido galardonado con un premio de honor a la mejor '
		DB 'mordedura de lengua. El l�der apenas habl�, no fue '
		DB 'preguntado directamente sobre la NSA ya pas� mucho rato '
		DB 'mirando al suelo, seg�n relatan otros medios. '
		DB 'En un momento dado, una representante de Libertades '
		DB 'Civiles le apunt� al mencionar el caso Snowden, pero '
		DB 'De Long no entr� al trapo y esper� que otro ' 
		DB 'conferenciante saliera a su rescate. Preguntado por un'
		DB 'periodista al acabar el debate, De Long le hizo saber que '
		DB 'viene a menudo a Cambridge con motivo de su participaci�n '
		DB 'en la Big Data Initiative del MIT. Varios medios han '
		DB 'lamentado que la cita del MIT se haya enfocado m�s al '
		DB 'business que a la privacidad. De hecho, muchos de los '
		DB 'profesores que tomaron la palabra en el evento est�n '
		DB 'directamente ligados a la industria.$'
VOCAL		DB 'AEIOUaeiou�����'
BUFFER		DB 20H DUP(?)
CONT    	DW 0000H
CONTB    	DW 0000H
CANTV		DB 00H     ;CANTIDAD DE VOCALES
V01             DB 0F0H DUP(?)
V02             DB 100H DUP(?)
V03             DB 100H DUP(?)
V04             DB 130H DUP(?)
V05             DB 100H DUP(?)
V06             DB 70H DUP(?)
V07             DB 60H DUP(?)
CONT1           DW 0000H
CONT2           DW 0000H
CONT3           DW 0000H
CONT4           DW 0000H
CONT5           DW 0000H
CONT6           DW 0000H
CONT7           DW 0000H		
		
		
		.code
		MOV AX,SEG TEXTO
		MOV DS,AX			 ;ICC

		CALL TECLA
		CMP AL,'M'
		JE DC
DC:		CALL DECRE
		CMP AL,'m'
		JE CRE
CRE:		CALL CRECE
		MOV SI,OFFSET TEXTO

		JMP INICIO
I1:		INC SI
INICIO:		CALL PALABRA
		MOV CX,CONT
		PUSH SI
		MOV CONTB,CX
		SUB SI,CX
		MOV DI,OFFSET BUFFER
GUARDA:		MOV AL,DS:[SI]			;DI ESTA AL FINAL
		MOV DS:[DI],AL			;DE LA PALABRA
		INC SI                          
		INC DI
		LOOP GUARDA
		XOR CX,CX
		MOV CANTV,0000H                 ;CUENTA LAS VOCALES
                MOV DI,OFFSET BUFFER
CVOCAL1:	MOV SI,OFFSET VOCAL
		MOV CL,0FH
CVOCAL:		MOV AL,DS:[DI]
		MOV BL,DS:[SI]
		CMP AL,BL
		JE CUENTA
		INC SI
		LOOP CVOCAL
		INC DI
CVOCAL2:	DEC CONT
		CMP CONT,0000H
		JE SIG
		JMP CVOCAL1
CUENTA:		INC CANTV
		INC DI
		JMP CVOCAL2
		 
		;SEPARA LAS PALABRAS PARA LUEGO CONTAR VOCALES		    	       
PALABRA:	MOV AL,DS:[SI]
PAL1:		CMP AL,20H  			;COMPARA ESPACIO
		JE PAL2                         ;AQUI COMA Y LUEGO ESPACIO
		CMP AL,','			;COMPARA COMAS
		JE PAL2	
		CMP AL,'.'			;COMPARA PUNTO
		JE PAL2		       		  		
		INC CONT
		INC SI
		JMP PALABRA
PAL2:		INC SI
		MOV AL,DS:[SI]
		CMP AL,'$'
		JE FIN1
		DEC SI
		RETN
FIN1:		JMP FIN

SIG:		CMP CANTV,01H  ;SIG PALABRA
		JE CAR1
		JMP SIG1
CAR1:		CALL CARGA1
		POP SI
		MOV AL,DS:[SI]
		CMP AL,20H
		JE VR1
		CMP AL,','
		JE VRb1
		CMP AL,'.'
		JE VRb1
		inc si
		JMP I1
vrb1:		inc si
VR1:		INC SI
		JMP INICIO

SIG1:		CMP CANTV,02H  ;SIG PALABRA
		JE CAR2
		JMP SIG2
CAR2:		CALL CARGA2
		POP SI
		MOV AL,DS:[SI]
		CMP AL,20H
		JE VR2
		CMP AL,','
		JE VRb2
		CMP AL,'.'
		JE VRb2
		inc si
		JMP I1
vrb2:		inc si
VR2:		INC SI
		JMP INICIO

SIG2:           CMP CANTV,03H  ;SIG PALABRA
		JE CAR3
		JMP SIG3
CAR3:		CALL CARGA3
		POP SI
		MOV AL,DS:[SI]
		CMP AL,20H
		JE VR3
		CMP AL,','
		JE VRb3
		CMP AL,'.'
		JE VRb3
		inc si
		JMP I1
vrb3:		inc si
VR3:		INC SI
		JMP INICIO

SIG3:		CMP CANTV,04H  ;SIG PALABRA
		JE CAR4
		JMP SIG4
CAR4:		CALL CARGA4
		POP SI
		MOV AL,DS:[SI]
		CMP AL,20H
		JE VR4
		CMP AL,','
		JE VRb4
		CMP AL,'.'
		JE VRb4
		inc si
		JMP I1
vrb4:		inc si
VR4:		INC SI
		JMP INICIO

SIG4:		CMP CANTV,05H  ;SIG PALABRA
		JE CAR5
		JMP SIG5
CAR5:		CALL CARGA5
		POP SI
		MOV AL,DS:[SI]
		CMP AL,20H
		JE VR5
		CMP AL,','
		JE VRb5
		CMP AL,'.'
		JE VRb5
		JMP I1
vrb5:		inc si
VR5:		INC SI
		JMP INICIO

SIG5:		CMP CANTV,06H  ;SIG PALABRA
		JE CAR6
		JMP SIG6
CAR6:		CALL CARGA6
		POP SI
		MOV AL,DS:[SI]
		CMP AL,20H
		JE VR6
		CMP AL,','
		JE VRb6
		CMP AL,'.'
		JE VRb6
		inc si
		JMP I1
vrb6:		inc si
VR6:		INC SI
		JMP INICIO

SIG6:		CMP CANTV,07H  ;SIG PALABRA
		JE CAR7
		JMP FIN1
CAR7:		CALL CARGA7
		POP SI
		MOV AL,DS:[SI]
		CMP AL,20H
		JE VR7
		CMP AL,','
		JE VRb7
		CMP AL,'.'
		JE VRb7
		inc si
		JMP I1
vrb7:		inc si
VR7:		INC SI
		JMP INICIO

CARGA1:         MOV BX,OFFSET V01
		ADD BX,CONT1
		MOV DI,OFFSET BUFFER
		MOV CX,CONTB
C1:	       	MOV AL,DS:[DI]
		MOV DS:[BX],AL
		INC DI
		INC BX
		INC CONT1         ;POSICION EN LA TABLA
		LOOP C1
		MOV AL,','
		MOV DS:[BX],AL
		INC CONT1
                RETN
CARGA2:         MOV BX,OFFSET V02
		ADD BX,CONT2
		MOV DI,OFFSET BUFFER
		MOV CX,CONTB		
C2:	       	MOV AL,DS:[DI]
	        MOV DS:[BX],AL
	        INC DI
		INC BX
		INC CONT2
		LOOP C2
		MOV AL,','
		MOV DS:[BX],AL
		INC CONT2
		RETN
CARGA3:         MOV BX,OFFSET V03
		ADD BX,CONT3
		MOV DI,OFFSET BUFFER
		MOV CX,CONTB
C3:	        MOV AL,DS:[DI]
		MOV DS:[BX],AL
	        INC DI
		INC BX
		INC CONT3
		LOOP C3
		MOV AL,','
		MOV DS:[BX],AL
		INC CONT3
		RETN
CARGA4:         MOV BX,OFFSET V04
		ADD BX,CONT4
		MOV DI,OFFSET BUFFER
		MOV CX,CONTB
C4:		MOV AL,DS:[DI]
		MOV DS:[BX],AL
		INC DI
		INC BX
		INC CONT4
		LOOP C4
		MOV AL,','
		MOV DS:[BX],AL
		INC CONT4
		RETN          
CARGA5:         MOV BX,OFFSET V05
		ADD BX,CONT5
		MOV DI,OFFSET BUFFER
		MOV CX,CONTB
C5:		MOV AL,DS:[DI]
		MOV DS:[BX],AL
		INC DI
		INC BX
		INC CONT5
		LOOP C5
		MOV AL,','
		MOV DS:[BX],AL
		INC CONT5
		RETN
CARGA6:         MOV BX,OFFSET V06
		ADD BX,CONT6
		MOV DI,OFFSET BUFFER
		MOV CX,CONTB
C6:		MOV AL,DS:[DI]
		MOV DS:[BX],AL
	        INC DI
		INC BX
		INC CONT6
		LOOP C6
		MOV AL,','
		MOV DS:[BX],AL
		INC CONT6
		RETN
CARGA7:         MOV BX,OFFSET V07
		ADD BX,CONT7
		MOV DI,OFFSET BUFFER
		MOV CX,CONTB
		MOV CONT1,0020
C7:		MOV AL,DS:[DI]
		MOV DS:[BX],AL
	       	INC DI
    		INC BX
		INC CONT7
		LOOP C7
		MOV AL,','
		MOV DS:[BX],AL
		INC CONT7
		RETN

TECLA:		MOV AH,00H
		INT 16H
		RETN
		
CRECE:		MOV DX,OFFSET V01
		CALL IMPRIME
		RETN
			
DECRE:		MOV DX,OFFSET V07
		CALL IMPRIME
		RETN
		
IMPRIME:        MOV AH,09H
		INT 21H
		RETN
				    		
FIN:		MOV AX,4C00H    
		INT 21H
		END

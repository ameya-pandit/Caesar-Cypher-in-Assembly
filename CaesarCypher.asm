	.ORIG   x3000		;START of Program

	BR	BEGIN
	INTRO	.STRINGZ "Hello, welcome to my Caesar Cipher program\n"
	QUEST1  .STRINGZ "\nDo you want to (E)ncrypt or (D)ecrypt or e(X)it?\n"
	QUEST2	.STRINGZ "\nWhat is the cipher(1-25)?\n"
	QUEST3  .STRINGZ "\nWhat is the string (up to 200 Characters)?\n"

BEGIN
	AND 	R0, R0, #0	;CLEAR Register 0
	AND 	R1, R1, #0	;CLEAR Register 1
	AND 	R2, R2, #0	;CLEAR Register 2
	AND 	R3, R3, #0	;CLEAR Register 3
	AND 	R4, R4, #0	;CLEAR Register 4
	AND 	R5, R5, #0	;CLEAR Register 5
	AND 	R6, R6, #0	;CLEAR Register 6
	
	LEA     R0, INTRO	;RO has address to INTRO string
	PUTS 			;OUTPUT "Hello, welcome to my Caesar Cipher program\n"

LOOP1
	AND 	R0, R0, #0	;CLEAR Register 0
	AND 	R1, R1, #0	;CLEAR Register 1
	AND 	R2, R2, #0	;CLEAR Register 2
	AND 	R3, R3, #0	;CLEAR Register 3
	AND 	R4, R4, #0	;CLEAR Register 4
	AND 	R5, R5, #0	;CLEAR Register 5
	AND 	R6, R6, #0	;CLEAR Register 6
	
	ST 	R1, int		;int to 0
	ST 	R1, flag	
	ST 	R1, flag2	
	ST 	R1, cipher
	
	LD	R1, shift1
	ADD	R1, R1, R1	;R1 is 400 (2x200)
		
	LEA	R3, ARRAY

CONTLOOP	
	BRz	CONT
	
	STR	R2, R3, #0
	
	ADD	R3, R3, #1
	ADD	R1, R1, #-1
	
	BR	CONTLOOP		

CONT	
	LEA	R0, QUEST1
	PUTS			;OUTPUT "\nDo you want to (E)ncrypt or (D)ecrypt or e(X)it?\n"
	
	GETC
	OUT

	LD 	R1, fillE 
	ADD	R1, R0, R1 
	
	BRnp	CONT2
	
	LD	R6, flag	
	ADD	R6, R6, #1
	ST	R6, flag		
	
	BR	NEXTQ		;IF GETC is 'E' - go to NEXTQ
	
CONT2	
	LD 	R1, D		 
	ADD	R1, R0, R1	 
	
	BRz	NEXTQ		;IF GETC is 'D' - go to NEXTQ
	
	LD 	R1, X		
	ADD	R1, R0, R1	 
	
	BRnp	LOOP1		;IF GETC is not X, go to LOOP1.

	LEA	R0, END
	PUTS			;OUTPUT "\nGoodbye!!"
			
FINISH	
	HALT			;STOP the program
				;TRAP x25	

NEXTQ	
	LEA	R0, QUEST2
		PUTS		;OUTPUT "\nWhat is the cipher(1-25)?\n"
	
LF1	
	GETC
	OUT
	
	LD 	R1, CHECKLF	;-10 value in R2 - used to check if GETC is LF
	ADD	R1, R0, R1	;Storing R0-10 in R2
	
	BRnp	SCyph		;IF GETC not LF - branch to SCyph to store the cipher
	
	LEA	R0, QUEST3
	PUTS			;OUTPUT "\nWhat is the string (up to 200 Characters)?\n"
	
	LEA	R3, ARRAY	
	
LF2
	GETC
	OUT
	
	LD 	R1, CHECKLF	;R2 has -10 which is used to check if GETC is LF
	ADD	R1, R0, R1	;Store R0-10 in R2
	
	BRnp	SStng		;IF GETC is not LF - branch to SStng - store the string portion.
	
	LD	R2, flag
	
	BRp	ENCRYPT
	BRz	DECRYPT

;===========================================CYPHER======================================================

SCyph 	
	LD	R2, CHARDIGIT	;LOAD CHARDIGIT (-48) to R2
	ADD	R1, R0, R2 	;R0 is char, R1 is DIGIT, R2 is -48: 
				;DIGIT = char - 48
	LD	R3, int		;R3 is int
	AND	R4, R4, #0	;R4 is counter
	ADD	R4, R4, #9
	

FOR	
	ADD	R5, R3, R5
	ADD 	R4, R4, #-1	;FOR loop add INT itself 10 times

	BRz	endFOR	
	BR	FOR		;MULT int by 10 - adding itself 10 times using loop

endFOR	
	ADD	R5, R5, R1	;R5 = R5  
	ST	R5, int
	ST	R5, cipher	;STORE R5 back into cipher
	
	BR	LF1

;==========================================STORAGE===============================================

SStng 	
	STR	R0, R3, #0	;STORE ARRAY (current ADDRESS) to R3
	ADD	R3, R3, #1	
	
	BR	LF2

ENCRYPT 
	LEA	R3, ARRAY	;R3 - current ARRAY ADDRESS JumpTo with the 9 bit offset 
	LD	R4, shift1	
	ADD	R4, R3, R4	;R4 points to second column 	
				;R3 points to first column

EncLOOP	
	LDR	R0, R3, #0
	BRz	PRINT

	LD	R2, A		
	ADD 	R1, R0, R2	
	
	BRp	EncUPPER		
	BR	STORENOT1	
	
EncUPPER	
	LD	R2, Z		
	ADD	R1, R0, R2	
	
	BRn	UPPER1		;CHECK IF GETC is UPPERCASE 	

STORENOT1
	LD	R2, a		
	ADD 	R1, R0, R2	
	
	BRp	EncLOWER	
	
	JSR	STOREARRAY	;STORE means NOT an A-Z or a-z 
	
	BR	EncLOOP

EncLOWER
	LD	R2, z		
	ADD	R1, R0, R2	
	
	BRn	LOWER1		;CHECK IF GETC is LOWERCASE 
	
UPPER1	
	AND 	R6, R6, #0	;GETC within 64<C<92 - UPPERCASE
	ADD	R6, R6, #1	;IF flag2 = 1, UPPERCASE
	ST	R6, flag2
	
	BR	DECISION

LOWER1	
	AND	R1, R1, #0	;GETC is within 96<C<123 - LOWERCASE
	ST	R1, flag2	;IF flag2 = 0, LOWERCASE
	
DECISION
	LD	R6, flag2	;UPPER or LOWERcase?
	BRnz	EDLoop1	
	JSR	UPPERM
	
	BR	ENC		

EDLoop1	
	JSR	LOWERM
	
	BR	ENC

ENC	
	LD	R2, cipher
	ADD	R0, R2, R0
	LD	R2, value1
	ADD	R0, R0, #0	;ENCRYPTING (CHAR + key)

ELoop1	
	BRn	EXIT
	ADD	R0, R0, R2
	
	BR	ELoop1
	 
EXIT	
	NOT 	R2, R2	
	ADD	R2, R2, #1	;2SC in R2
	ADD	R0, R2, R0	;ADD 26 back to R0
				
	LD 	R1, flag2
	BRnz	REFER1	
	JSR	UPPERA
	JSR	STOREARRAY
	BR	EncLOOP
	
REFER1	
	JSR	LOWERA
	JSR	STOREARRAY
	
	BR	EncLOOP	        ;REFER back to EncLOOP 
		
STOREARRAY	
	STR	R0, R4, #0	;COLUMN ARRAYS
	ADD	R3, R3, #1	;INCREMENT C1 array
	ADD	R4, R4, #1 	;INCREMENT C2 array

	RET

UPPERM				;THINK OF THIS AS THE BOTTOM (13-26) OF THE CAP ALPHABETS
	LD	R1, A2
	ADD	R0, R1, R0
	
	RET	

LOWERM				;THINK OF THIS AS THE BOTTOM (13-26) OF THE LOWER CASE ALPHABETS
	LD	R1, a2
	ADD	R0, R1, R0

	RET	

UPPERA				;THINK OF THIS AS THE TOP (0-13) OF THE CAP ALPHABETS
	LD	R1, A2
	NOT	R1, R1
	ADD	R1, R1, #1	;INVERTING - 2SC
	ADD	R0, R1, R0
	
	RET

LOWERA				;THINK OF THIS AS THE TOP (0-13) OF THE LOEWR CASE ALPHABETS
	LD	R1, a2
	NOT	R1, R1
	ADD	R1, R1, #1	;INVERTING - 2SC
	ADD	R0, R1, R0
	
	RET

DECRYPT 
	LEA	R3, ARRAY	;R3 has current ARRAY ADDRESS
	LD	R4, shift1	;R4 is 200
	ADD	R4, R3, R4	;R4 will be pointing to the second column 	
				;R3 will be pointing to the first column

DecLOOP	
	LDR	R0, R3, #0
	BRz	PRINT

	LD	R2, A		
	ADD 	R1, R0, R2	
	
	BRp	DecUPPER		
	BR	STORENOT2		
	
DecUPPER	
	LD	R2, Z		
	ADD	R1, R0, R2	
	
	BRn	UPPER2		;CHECK IF getC is UPPERCASE 	

STORENOT2
	LD	R2, a		
	ADD 	R1, R0, R2	
	
	BRp	DecLOWER		
	
	JSR	STOREARRAY	;STORE means not an A-Z or a-z 
	
	BR	DecLOOP

DecLOWER
	LD	R2, z		
	ADD	R1, R0, R2	

	BRn	LOWER2		;CHECK IF GETC is LOWERCASE 

UPPER2
	AND 	R6, R6, #0	;GETC is within 64<C<92 - UPPERCASE  
	ADD	R6, R6, #1	;IF flag2 = 1 - UPPERCASE
	ST	R6, flag2
	BR	DECISION2
	
	LEA	R0, NL
	PUTS
	LEA	R0, NL
	PUTS

LOWER2	
	AND	R1, R1, #0	;GETC is within 96<C<123 - LOWERCASE	
	ST	R1, flag2	;IF flag2 = 0 - LOWERCASE
	
DECISION2	
	LD	R6, flag2
	
	BRnz	EDLoop2
	
	JSR	UPPERM
	
	BR	DEC	

EDLoop2	
	JSR	LOWERM

DEC	
	LD	R2, cipher
	NOT	R2, R2
	ADD	R2, R2, #1	;DIFFERENCE in ENC vs. DEC = subtract key instead of add using 2SC
	ADD	R0, R2, R0	;ENCRYPT (char-key)
	LD	R2, value1
	ADD	R0, R0, #0

DLoop1	
	BRn	EXIT2
	
	ADD	R0, R0, R2
	
	BR	DLoop1
	 
EXIT2	
	NOT 	R2, R2	
	ADD	R2, R2, #1	;2SC
	ADD	R0, R2, R0	;ADDING back 26
				
	LD 	R1, flag2
	
	BRnz	REFER2	
	
	JSR	UPPERA
	JSR	STOREARRAY
	
	BR	DecLOOP

REFER2	
	JSR	LOWERA
	JSR	STOREARRAY
	BR	DecLOOP
		
PRINT
	LEA	R0, ARRAY
	PUTS
	LEA	R0, NL
	PUTS
	LEA	R0, ARRAY
	LD	R1, shift1
	ADD	R0, R0, R1
	PUTS
	BR	LOOP1		;Back to Start


			
;DATA DECLARATIONS BELOW:

CHECKLF	.FILL	#-10
fillE	.FILL 	#-69
X	.FILL	#-88
D	.FILL	#-68

CHARDIGIT	.FILL	#-48
int		.FILL	#0
flag		.FILL	#0
flag2		.FILL 	#0
cipher		.FILL	#0
value1		.FILL	#-26
A		.FILL	#-64
A2		.FILL	#-65	
Z		.FILL	#-91
a		.FILL 	#-96
a2		.FILL	#-97
z		.FILL	#-123
shift1		.FILL	#200
END    		.STRINGZ "\nGoodbye"

NL	.STRINGZ "\n"
ARRAY	.BLKW	400	#0   
	.END

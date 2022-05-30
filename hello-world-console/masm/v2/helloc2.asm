; Console helloworld v 2.0
; Assembler: MASM32
; Compiling: G:\masm32\bin\ml.exe /c /coff helloc2.asm
; Linking: G:\masm32\bin\link.exe helloc2.obj  /SUBSYSTEM:CONSOLE /LIBPATH:G:\masm32\lib\

.386
.model flat

extern	_ExitProcess@4:near
extern	_GetStdHandle@4:near
extern	_WriteConsoleA@20:near
extern	_ReadConsoleA@20:near

includelib kernel32.lib

.data
	message	db	'Hello, world!',0Dh,0Ah,0Dh,0Ah
	handle	dd	?
	written	dd	?	
	
	msgexit	db	'Press ENTER to exit...'
	
	hInput	dd	?
	readed	dd	?
	readbuf	db	?
		
	STD_INPUT_HANDLE	dd	-10
	STD_OUTPUT_HANDLE	dd	-11
	STD_ERROR_HANDLE	dd	-12
	
.code
_main:
	;get StdOut handle
	push	STD_OUTPUT_HANDLE
	call	_GetStdHandle@4
	cmp 	eax,0
	jle 	exiterr				; exit if error in GetStdHandle (return -1) or no console (return 0)
	mov		handle, eax
	
	push	0					;reserved
	push	offset written		;number of chars written
	push	17					;number of chars to write
	push	offset message		;output string
	push	handle				;handle StdOutput
	call	_WriteConsoleA@20	
	
	;write exit message
	push	0					;reserved
	push	offset written		;number of chars written
	push	22					;number of chars to write
	push	offset msgexit		;output string
	push	handle				;handle StdOutput
	call	_WriteConsoleA@20
	
	;read user input
	;get StdIn handle
	push	STD_INPUT_HANDLE
	call	_GetStdHandle@4
	cmp 	eax,0
	jle 	exiterr				; exit if error in GetStdHandle (return -1) or no console (return 0)
	mov		hInput, eax
	
	;ReadConsole
	push 	0					;READ_CONSOLE_CONTROL structure
	push 	offset readed		;number of readed chars
	push	0					;number of chars to read
	push	offset readbuf		;readed chars buffer
	push	hInput				;Input handle
	call	_ReadConsoleA@20
	
	jmp 	exit
	
exiterr:
	push	1
	call	_ExitProcess@4

exit:
	push	0
	call	_ExitProcess@4
end _main
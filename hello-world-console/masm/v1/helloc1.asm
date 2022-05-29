; Console helloworld v 1.0
; Assembler: MASM32
; Compiling: G:\masm32\bin\ml.exe /c /coff helloc1.asm
; Linking: G:\masm32\bin\link.exe helloc1.obj  /SUBSYSTEM:CONSOLE /LIBPATH:G:\masm32\lib\

.386
.model flat

extern	_ExitProcess@4:near
extern	_GetStdHandle@4:near
extern	_WriteConsoleA@20:near

includelib kernel32.lib

.data
	message	db	'Hello, world!',0Dh,0Ah
	handle	dd	?
	written	dd	?
	
	STD_INPUT_HANDLE	equ	-10
	STD_OUTPUT_HANDLE	equ	-11
	STD_ERROR_HANDLE	equ	-12
	
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
	push	15					;number of chars to write
	push	offset message		;output string
	push	handle				;handle StdOutput
	call	_WriteConsoleA@20
	jmp 	exit
	
exiterr:
	push	1
	call	_ExitProcess@4

exit:
	push	0
	call	_ExitProcess@4
end _main
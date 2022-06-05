; Console helloworld v 3.0
; Assembler: MASM32
; Compiling: G:\masm32\bin\ml.exe /c /coff /IG:\masm32\include\ helloc3.asm
; Linking: G:\masm32\bin\link.exe helloc3.obj  /SUBSYSTEM:CONSOLE /LIBPATH:G:\masm32\lib\

.386
.model flat, stdcall
option casemap:none

include windows.inc
include kernel32.inc
includelib kernel32.lib

.data
	message	db	'Hello, world!',0Dh,0Ah,0Dh,0Ah
	handle	dd	?
	written	dd	?	
	
	msgexit	db	'Press ENTER to exit...'
	
	hInput	dd	?
	readed	dd	?
	readbuf	db	?
	
	conshdr	db	'Hello, MASM32 World!',0

.code
_main:
	;get StdOut handle
	invoke	GetStdHandle, STD_OUTPUT_HANDLE
	cmp 	eax,0
	jle 	exiterr				; exit if error in GetStdHandle (return -1) or no console (return 0)
	mov		handle, eax
	
	invoke	SetConsoleTitleA, addr conshdr
	invoke	WriteConsoleA, handle, addr message, 17, addr written, 0
	
	;write exit message
	invoke	WriteConsoleA, handle, addr msgexit, 22, addr written, 0
	
	;read user input
	;get StdIn handle
	invoke	GetStdHandle, STD_INPUT_HANDLE
	cmp 	eax,0
	jle 	exiterr				; exit if error in GetStdHandle (return -1) or no console (return 0)
	mov		hInput, eax
	
	;ReadConsole
	invoke	ReadConsoleA, hInput, addr readbuf, 0, addr readed, 0
	
	jmp 	exit
	
exiterr:
	invoke	ExitProcess, 1

exit:
	invoke	ExitProcess, 0
end _main
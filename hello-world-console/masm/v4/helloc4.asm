; Console helloworld v 4.0
; Assembler: MASM32
; Compiling: G:\masm32\bin\ml.exe /c /coff /IG:\masm32\include\ helloc4.asm
; Linking: G:\masm32\bin\link.exe helloc4.obj  /SUBSYSTEM:CONSOLE /LIBPATH:G:\masm32\lib\

.386
.model flat, stdcall
option casemap:none

include windows.inc
include kernel32.inc
includelib kernel32.lib
include user32.inc
includelib user32.lib

.data
	message	db	'Hello, world!',0Dh,0Ah
	handle	dd	?
	written	dd	?	
	
	conshdr	db	'Hello, MASM32 World!',0
	
	mboxhdr	db	'Console call MessageBox',0
	mboxtxt	db	'Press OK to exit.',0

.code
_main:
	;get StdOut handle
	invoke	GetStdHandle, STD_OUTPUT_HANDLE
	cmp 	eax,0
	jle 	exiterr				; exit if error in GetStdHandle (return -1) or no console (return 0)
	mov		handle, eax
	
	invoke	SetConsoleTitleA, addr conshdr
	invoke	WriteConsoleA, handle, addr message, 15, addr written, 0
	
	invoke	MessageBoxA, 0, addr mboxtxt, addr mboxhdr, MB_ICONINFORMATION
		
	jmp 	exit
	
exiterr:
	invoke	ExitProcess, 1

exit:
	invoke	ExitProcess, 0
end _main
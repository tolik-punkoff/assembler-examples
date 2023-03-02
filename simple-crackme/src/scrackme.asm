.386
.model flat,stdcall
option casemap:none
includelib kernel32.lib
includelib user32.lib
include windows.inc
include kernel32.inc
include user32.inc
include InputBox.inc

IB_XPOS     equ 100
IB_YPOS     equ 100
buffersize  equ 32

.DATA

StrLen			dd	0
buffer			db	buffersize DUP (?)
message			dd	0

InputCaption    db 'Enter Password',0
OKCaption		db 'Access granted!',0
OKMessage		db 'You are connected to DarkStream System!',0
msgEnterPass	db 'Please enter password:',0
msgBadPass      db 'Sorry, password is bad!',13,10
                db 'Please try again:',0
sPassword		db 'PA$$w0rD',0
.CODE

_main:

	mov		message, OFFSET msgEnterPass ;Start dialog message

    go_start:
		invoke InputBox, message, ADDR InputCaption, ADDR buffer, buffersize, IB_XPOS, IB_YPOS, ADDR StrLen
		test   eax, eax                 				; Dialog cancelled?
		jz     finish                   				; Yes -> end the programm
    
		invoke	lstrcmp, ADDR buffer, ADDR sPassword	;check password
		test	eax,eax
		jnz		go_error
	
		invoke MessageBoxA, 0, ADDR OKMessage, ADDR OKCaption, MB_OK
		jmp finish
	
	go_error:
		mov		message, OFFSET msgBadPass 				;Bad password dialog message
		jmp    go_start                 				; Jump backward to start dialog
	
	finish:
		invoke ExitProcess, 0
	
END _main
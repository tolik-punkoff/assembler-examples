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
buffer			db	buffersize DUP(0)
message			dd	0

InputCaption    db 'InputBox',0
OutputCaption   db 'Your string is',0
msg             db 'Please enter a string',0
msg2            db 'Sorry, you did not type anything',13,10
                db 'Please try again',0
.CODE

_main:

	mov message, OFFSET msg
    go_start:
    invoke InputBox, message, ADDR InputCaption, ADDR buffer, buffersize, IB_XPOS, IB_YPOS, ADDR StrLen
    test   eax, eax                 ; Dialog cancelled?
    jz     finish                   ; Yes -> end the programm
    mov    eax, StrLen
    test   eax, eax                 ; StrLen != 0?
    jnz    go_print                 ; Yes -> jump forward to print message
    mov    message, OFFSET msg2		; Change message in dialog
    jmp    go_start                 ; Jump backward to start dialog
    go_print:
    invoke MessageBoxA, 0, ADDR buffer, ADDR OutputCaption, MB_OK
	
	finish:
    invoke ExitProcess, 0
	
END _main
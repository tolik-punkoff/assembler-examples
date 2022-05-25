;MASM32 Windows Hello world
;Compile G:\masm32\bin\ml.exe /c /coff /IG:\masm32\include\ hellom.asm
;Linking G:\masm32\bin\link.exe hellom.obj  /SUBSYSTEM:WINDOWS /LIBPATH:G:\masm32\lib\

.386
.model flat, stdcall
option casemap:none

include windows.inc

include kernel32.inc
includelib kernel32.lib

include user32.inc
includelib user32.lib

.data
	MsgBoxText	db	'Hello, MASM World!',0
	MsgBoxCaption	db	'I am running!',0
.code
_main:

	invoke	MessageBoxA, 0, addr MsgBoxText, addr MsgBoxCaption, MB_ICONINFORMATION
	
	invoke	ExitProcess, 0
end	_main
DlgProc PROTO hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD   ; Forward declaration

IDC_STATIC  equ 4001
IDC_EDIT    equ 4002
IDB_OK      equ 4003
IDB_CANCEL  equ 4004

.DATA
	
;DlgTemplateEx
ALIGN 4
DlgTemplateEx   dw 1, 0FFFFh    ; dlgVer, Signature
                dd 0, 0         ; helpID, exStyle
                dd 90C800CCh    ; style
                dw 4            ; cDlgItems
DlgBoxCoord     dw 300          ; x
                dw 250          ; y
                dw 120          ; cx
                dw 80           ; cy
                dw 0            ; menu
                dw 0            ; windowClass
                dw 0            ; title
                dw 12           ; pointsize
                dw 0            ; weight
                db 0            ; italic
                db 1            ; charset
                dw 'O','l','d',' ','E','n','g','l','i','s','h',' ','T','e','x','t',' ','M','T',0

ALIGN 4
        dd 0,0          ; helpID, exStyle
        dd 50020000h    ; style
        dw 10           ; x
        dw 5            ; y
        dw 150          ; cx
        dw 20           ; cy
        dd IDC_STATIC   ; id
        dw 0FFFFh, 82h  ; windowClass, Static
        dw 0            ; title
        dw 0            ; extraCount

ALIGN 4
        dd 0,0          ; helpID, exStyle
        dd 50810080h    ; style
        dw 10           ; x
        dw 25           ; y
        dw 100          ; cx
        dw 12           ; cy
        dd IDC_EDIT     ; id
        dw 0FFFFh, 81h  ; windowClass, Edit
        dw 0            ; title
        dw 0            ; extraCount

ALIGN 4
        dd 0,0          ; helpID, exStyle
        dd 50010000h    ; style
        dw 10           ; x
        dw 50           ; y
        dw 45           ; cx
        dw 15           ; cy
        dd IDB_OK       ; id
        dw 0FFFFh, 80h  ; windowClass, Button
        dw  'O','K',0   ; title: OK
        dw 0            ; extraCount

ALIGN 4
        dd 0,0          ; helpID, exStyle
        dd 50010000h    ; style
        dw 65           ; x
        dw 50           ; y
        dw 45           ; cx
        dw 15           ; cy
        dd IDB_CANCEL   ; id
        dw 0FFFFh, 80h  ; windowClass, Button
        dw 'C','a','n','c','e','l',0    ; title: Cancel
        dw 0            ; extraCount

;End of DlgTemplateEx
;End of .DATA

.data?

	IBparams    dd ?
	hEditBoxIB  dd ?
	StringLenIB dd ?

.code

InputBox PROC pText:DWORD,\     ; address of text to displayed in the static control
            pCaption:DWORD,\    ; address of title of input box
            pBuffer:DWORD,\     ; address of buffer receiving the input text
            pbuffersize:DWORD,\
            xpos:DWORD,\        ; x-coordinate of input box
            ypos:DWORD,\        ; y-coordinate of input box
            pStringLen:DWORD    ; pointer to number of characters received to the input box

; Return values :

;           If the user clicks the OK button, the return value is 1
;           If the user clicks the cancel button, the return value is 0
;           The number of characters received to the input box

    mov   eax, ypos
    shl   eax, 16
    or    eax, xpos
    mov   DWORD PTR [DlgBoxCoord], eax ; set the coordinates of the input box

    invoke  GetModuleHandleA, 0
    lea   edx,[pText]                       ; get the stack address pointing the parameters of InputBox

    ;int DialogBoxIndirectParam(
	;   HINSTANCE hInstance,  // handle to application instance
	;   LPCDLGTEMPLATE hDialogTemplate, // identifies dialog box template
	;   HWND hWndParent,      // handle to owner window
	;   DLGPROC lpDialogFunc, // pointer to dialog box procedure
	;   LPARAM dwInitParam    // initialization value
	;*************
	invoke  DialogBoxIndirectParamA,\       
                eax,\                       
                ADDR DlgTemplateEx,\        
                0,\                         
                ADDR DlgProc,\              
                edx                         
    ret

InputBox ENDP

DlgProc PROC USES esi hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

    .IF uMsg==WM_INITDIALOG

        mov     esi, lParam
        mov     IBparams, esi
        invoke  GetDlgItem, hWnd, IDC_STATIC
        invoke  SendMessageA, eax, WM_SETTEXT, 0, DWORD PTR [esi]       ; pText
        invoke  SendMessageA, hWnd, WM_SETTEXT, 0, DWORD PTR [esi+4]    ; pCaption
        invoke  GetDlgItem, hWnd, IDC_EDIT
        mov     hEditBoxIB, eax
        mov     edx, [esi+12]               ; buffersize
        dec edx
        invoke  SendMessageA, eax, EM_LIMITTEXT, edx, 0

        mov     StringLenIB, 0

    .ELSEIF uMsg==WM_CLOSE

        invoke  EndDialog, hWnd, 0

    .ELSEIF uMsg==WM_COMMAND

        mov  eax, wParam
        mov  edx, eax
        shr  edx, 16

        .IF dx==BN_CLICKED

            .IF ax==IDB_CANCEL

                invoke  EndDialog, hWnd, 0

            .ELSEIF ax==IDB_OK || ax==IDOK                         ; check also if RETURN \ ENTER is pressed

                mov esi, hEditBoxIB
                invoke  SendMessageA, esi, WM_GETTEXTLENGTH, 0, 0
                mov StringLenIB, eax
                test eax, eax                                  ; check the length of the input text
                jz @F                                      ; if no text is entered then quit application
                inc eax
                mov edx, IBparams
                invoke SendMessageA, esi, WM_GETTEXT, eax, DWORD PTR [edx+8]    ; DWORD PTR [edx] -> pointer to the buffer receiving keyboard input
                @@:
                mov ecx, IBparams
                mov edx, DWORD PTR [ecx+24]
                mov DWORD PTR [edx], eax
                invoke EndDialog, hWnd, 1

            .ENDIF

        .ENDIF

    .ELSE

        xor eax, eax
        ret

    .ENDIF

    mov  eax, TRUE
    ret

DlgProc ENDP

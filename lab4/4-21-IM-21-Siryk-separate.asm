.386
.model flat,stdcall
option casemap :none

include \masm32\include\masm32rt.inc
include 4-21-IM-21-Siryk-separate-macros.inc


.const
IDD_INPUT equ 1001


.data
MTitle db "Lab3", 0

my_name db "Name: Max Siryk Oleksandrovych", 0
my_birthday db "Birthday: 17.06.2005", 0 
my_number db "Number: 9056", 0

wrong_msg_fmt db "Nope, the password is wrong; You have %d attempts left", 0
prompt_msg db "Input your password: ", 0

pass db "B]^QC", 0
key db "someverystrongkey", 0
counter DWORD 3

input_buffer db 256 dup(?)
buff db 256 dup(?)


.code

wrong proc
    dec counter
    mov ebx, counter
    invoke wsprintf, ADDR buff, addr wrong_msg_fmt, ebx
    my_show buff
    ret
wrong endp


right proc
    my_show my_name
    my_show my_birthday
    my_show my_number
    ret
right endp


DlgProc PROC hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    .if uMsg == WM_COMMAND
        mov eax, wParam
        .if ax == IDOK
            invoke GetDlgItemText, hWnd, IDD_INPUT, addr input_buffer, sizeof input_buffer
            my_cypher input_buffer, key, input_buffer
            my_compare pass, input_buffer
            .if counter <= 0
                invoke EndDialog, hWnd, IDOK 
            .endif
        .elseif ax == IDCANCEL
            invoke EndDialog, hWnd, IDCANCEL
        .endif
    .elseif uMsg == WM_CLOSE
        invoke EndDialog, hWnd, IDCANCEL
    .endif
    
    xor eax, eax
    ret
DlgProc ENDP


main:
    ; dialog macro defined in C:\masm32\include\dialogs
    ; quoted_text_title,quoted_font,fsize,dstyle,ctlcnt (number of elements),tx,ty,wd,ht,bsize
    Dialog "Lab3", "Arial", 14, DS_CENTER, 4, 0, 0, 150, 70, 1024                 							      
	  DlgStatic "Enter your password:", DS_CENTER, 5, 5, 70, 10,   NULL
	  DlgEdit WS_BORDER,                           72, 5, 70, 10,  IDD_INPUT		
	  DlgButton "Confirm", WS_TABSTOP,             5, 25, 140, 10, IDOK 				
	  DlgButton "Exit", WS_TABSTOP,              5, 45, 140, 10, IDCANCEL 	

    CallModalDialog 0, 0, DlgProc, NULL

    invoke ExitProcess, 0
end main



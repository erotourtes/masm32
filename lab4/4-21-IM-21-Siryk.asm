.386
.model flat,stdcall
option casemap :none

include \masm32\include\masm32rt.inc


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


my_show macro info
    xor bx, bx ; =============== shows the $info in the messagebox =============== 
    invoke MessageBox, 0, addr info, addr MTitle, 0 ;; ------------- using default MTitle ------------- 
endm


my_cypher macro input, key, output    
    mov bx, 0 ;; -------------  making sure bx is 0 ------------- 

loop_cypher: ; =============== cyphers input with a key and writes it to the output =============== 
    .if input_buffer[bx] == 0
        jmp end_loop_cypher
    .endif

; =============== commenting empty line ===============
   
    mov al, input[bx]
    xor al, key[bx]
    mov output[bx], al
    inc bx
;; ------------- commenting empty line -------------
    jmp loop_cypher
    
end_loop_cypher:
    xor bx, bx ; =============== clearing the registers =============== 
    xor al, al
endm


my_compare macro first, second
    local loop_label2, right_label, wrong_label
    mov bx, 0 ; =============== compares the first string with the second =============== 
loop_label:

    .if first[bx] == 0 && second[bx] == 0
        jmp right_label
    .elseif first[bx] == 0 && second[bx] != 0
        jmp wrong_label
    .endif

    mov al, first[bx]
    mov ah, second[bx]
    cmp al, ah
    jne wrong_label

    inc bx
    jmp loop_label

right_label:
    call right
    jmp exit_comparison ;; ------------- hidden: making sure to exit ------------- 

wrong_label:
    call wrong
    
exit_comparison:
    xor bx, bx ;; ------------- clearing the register ------------- 
endm



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



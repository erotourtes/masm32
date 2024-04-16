.386
.model flat,stdcall
option casemap :none

include \masm32\include\masm32rt.inc



.data
MTitle db "Lab5", 0

my_formula_fmt db   "Formula: (c - d/2 + 33)/(2*a*a - 1) = ", 10, 13, 
                    "(%d - %d/2 + 33)/(2*%d*%d - 1) = %d", 10, 13, 
                    "Formatted: %d", 0

my_a dd 4, 3, -2, 7, 23
my_c dd 5, 25, 23, 1234, 1234567
my_d dd 15, 1000, 3, 8, -3332
array_length equ ($ - my_d) / 4 ; equates (cur location start pointer - my_a's start pointer) / size of array el

buff db 256 dup(?)
counter dd 0



.code
my_calc PROC par_a:DWORD, par_c:DWORD, par_d:DWORD
    LOCAL res:DWORD

    mov ebx, par_a  ; ebx is a denominator
    imul ebx, ebx   ; a*a
    imul ebx, 2     ; 2*a*a
    sub ebx, 1      ; 2*a*a - 1

    .if ebx == 0
        invoke MessageBox, 0, addr buff, addr MTitle, 0
        ret
    .endif

    mov eax, par_d  ; eax is a numerator
    cdq             ; sign extend eax into edx:eax
    mov ecx, 2
    idiv ecx        ; d/2
    neg eax         ; -d/2
    add eax, par_c  ; c - d/2
    add eax, 33     ; c - d/2 + 33

    ; eax is ready
    cdq
    mov ecx, ebx
    idiv ecx        ; (c - d/2 + 33)/(2*a*a - 1)
    
    mov res, eax
    and eax, 1
    .if eax == 0
        mov eax, res
        cdq
        mov ecx, 2
        idiv ecx    ; res / 2
    .else
        mov eax, res
        imul eax, 5 ; res * 5
    .endif
 
    invoke wsprintf, ADDR buff, addr my_formula_fmt, par_c, par_d, par_a, par_a, res, eax
    invoke MessageBox, 0, addr buff, addr MTitle, 0
    ret
my_calc ENDP


main:
    .while counter < array_length
        mov eax, counter
        invoke my_calc, my_a[eax * 4], my_c[eax * 4], my_d[eax * 4]
        inc counter
    .endw

    invoke ExitProcess, 0
end main



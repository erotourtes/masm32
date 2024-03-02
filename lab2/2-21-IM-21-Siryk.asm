.386
.model flat,stdcall
option casemap :none

include \masm32\include\masm32rt.inc


.data?
buff db 100 dup(?)

buff_D   db 32 dup(?)
buff_D_N db 32 dup(?)
buff_E   db 64 dup(?)
buff_E_N db 64 dup(?)
buff_F   db 80 dup(?)
buff_F_N db 80 dup(?)

.data
MTitle db "Lab2", 0
date db "17.06.2005", 0
form db "Date: %s", 10, 13,
        "A: %d %d", 10, 13,
        "B: %d %d", 10, 13, 
        "C: %d %d", 10, 13, 
        "D: %s %s", 10, 13,
        "E: %s %s", 10, 13,
        "F: %s %s", 10, 13, 0

; ----- Byte ----- ;
A_Byte      DB  17
A_Byte_N    DB  -17

; ----- Word ----- ;
A_Word      DW  17
A_Word_N    DW  -17

B_Word      DW 1706
B_Word_N    DW -1706

; ----- DWord ----- ;
A_Int       DD  17
A_Int_N     DD  -17

B_Int       DD  1706
B_Int_N     DD  -1706

C_Int       DD  17062005
C_Int_N     DD  -17062005

; ----- QWORD ----- ;
A_LInt      DQ  17
A_LInt_N    DQ  -17

B_LInt      DQ  1706
B_LInt_N    DQ  -1706

C_LInt      DQ  17062005
C_LInt_N    DQ  -17062005


; ----- REAL4 ----- ;
D_Float     DD   0.002
D_Float_N   DD   -0.002

; ----- REAL8 ----- ;
E_Double    DQ  0.188
E_Double_N  DQ  -0.188

D_Double    DQ  0.002
D_Double_N  DQ  -0.002

F_Double    DQ  1884.055
F_Double_N  DQ  -1884.055

; ----- REAL10 ----- ;
F_LDouble   DT  1884.055
F_LDouble_N DT  -1884.055

.code

main:
    invoke FloatToStr2, D_Double,       addr buff_D
    invoke FloatToStr2, D_Double_N,     addr buff_D_N
    invoke FloatToStr, E_Double,        addr buff_E
    invoke FloatToStr, E_Double_N,      addr buff_E_N
    invoke FloatToStr, F_Double,        addr buff_F
    invoke FloatToStr, F_Double_N,      addr buff_F_N

    invoke wsprintf, addr buff, addr form, addr date, A_Int, A_Int_N, B_Int, B_Int_N, C_Int, C_Int_N, addr buff_D, addr buff_D_N, addr buff_E, addr buff_E_N, addr buff_F, addr buff_F_N
    
    invoke MessageBox, 0, addr buff, addr MTitle, 0

    invoke ExitProcess, 0
end main



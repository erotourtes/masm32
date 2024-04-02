IFNDEF MY_MACRO
MY_MACRO equ <1>

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


ELSE
  echo -----------------------------------------
  echo WARNING duplicate include file MY_MACRO
  echo -----------------------------------------
ENDIF


include \masm32\include\masm32rt.inc

.data

info db "Max Siryk Oleksandrovych", 10, 13, "17.06.2005", 10, 13, "9056", 0
messageTitle db "Lab1", 0


.code

main:
    invoke MessageBox, 0, addr info, addr messageTitle, 0
    invoke ExitProcess, 0
end main

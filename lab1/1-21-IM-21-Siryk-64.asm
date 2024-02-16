OPTION DOTNAME
	
option casemap:none
include temphls.inc
include win64.inc
include kernel32.inc
includelib kernel32.lib
include user32.inc
includelib user32.lib
OPTION PROLOGUE:rbpFramePrologue
OPTION EPILOGUE:none

.data

info db "Max Siryk Oleksandrovych", 10, 13, "17.06.2005", 10, 13, "9056", 0
messageTitle db "Lab1x64", 0


.code

WinMain proc 
	sub rsp,28h
      invoke MessageBox, NULL, &info, &messageTitle, MB_OK
      invoke ExitProcess,NULL
WinMain endp
end

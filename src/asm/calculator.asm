call resetTextScreen

mov si, testMsg
call printString

mov ah, 0x00
int 0x16

mov ax, 0x2000
mov es, ax

xor bx, bx

mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ss, ax
jmp 0x2000:0x0000

%include "../src/print/print_string.asm"
%include "../src/screen/resetTextScreen.asm"

testMsg: db 'Program Loaded!', 0

times 512-($-$$) db 0
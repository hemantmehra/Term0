;; Print
printString:
    pusha
    mov ah, 0x0e ; 0x0e for BIOS teletype output 
    mov bh, 0x00
    mov bl, 0x07

printChar:
    lodsb   ; move byte at si into al
    cmp al, 0
    je end_string
    int 0x10
    jmp printChar

end_string:
    popa
    ret
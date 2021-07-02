resetTextScreen:
	pusha

	mov ah, 0x00 ; set video mode
    mov al, 0x03 ; 80 X 25 video mode
    int 0x10

    ;; Change color
    mov ah, 0x0B
    mov bh, 0x00
    mov bl, 0x01
    int 0x10

    popa
    ret
resetGraphicsScreen:
	pusha

	mov ah, 0x00 ; set video mode
    mov al, 0x13 ; 320 X 200 gfx mode
    int 0x10

    popa
    ret
;; Ascii
;; 'A' - 'F': 0x41-0x46
;; 'a' - 'f': 0x61-0x66
;; '0' - '9': 0x30-0x39

printHex:
	pusha
	xor cx, cx

hex_loop:
	cmp cx, 4
	je end_hexloop

	mov ax, dx
	and ax, 0x000F
	add al, 0x30
	cmp al, 0x39
	jle move_intoBX
	mov al, 0x07

move_intoBX:
	mov bx, hexString + 5
	sub bx, cx
	mov [bx], al
	ror dx, 4
	add cx, 1
	jmp hex_loop

end_hexloop:
	mov si, hexString
	call printString
	popa
	ret

hexString: db '0x0000', 0
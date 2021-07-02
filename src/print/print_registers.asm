print_registers:
	mov si, regString
	call printString
	call printHex		; dx

	mov byte [regString + 2], 'a'
	call printString
	mov dx, ax
	call printHex		; ax

	mov byte [regString + 2], 'b'
	call printString
	mov dx, bx
	call printHex		; bx

	mov byte [regString + 2], 'c'
	call printString
	mov dx, cx
	call printHex		; cx

	mov word [regString + 2], 'si'
	call printString
	mov dx, si
	call printHex		; si

	mov byte [regString + 2], 'd'
	call printString
	mov dx, di
	call printHex		; di

	mov word [regString + 2], 'cs'
	call printString
	mov dx, cs
	call printHex		; cs

	mov byte [regString + 2], 'd'
	call printString
	mov dx, ds
	call printHex		; d

	mov byte [regString + 2], 'e'
	call printString
	mov dx, es
	call printHex		; es

	ret

regString: db 0xA, 0xD, 'dx             ', 0
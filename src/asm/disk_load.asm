;;; Disk Load: Read DH sectors into ES:BX from drive DL

disk_load:
	push dx

	mov ah, 0x02 ; int 13/ah=02h, BIOS read sectors into memory.
	mov al, dh 	 ; read 1 sector
	mov ch, 0x00 ; cylinder 0
	mov dh, 0x00 ; head 0
	mov cl, 0x02 ; sector 2

	int 0x13

	jc disk_error

	pop dx
	cmp dh, al ; if dh != al disk error
	jne disk_error

disk_error:
	mov bx, DISK_ERROR_MSG
	call printString
	hlt

DISK_ERROR_MSG: db 'Disk read error', 0



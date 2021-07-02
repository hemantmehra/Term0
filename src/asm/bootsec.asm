
org 0x7c00

;; -------------------------
;; Load file Table
;; -------------------------
mov BX, 0x1000 ; load sector to mem 0x1000
mov es, bx     ; ES = 0x1000
mov bx, 0x0      ; ES:BX = 0x1000:0

mov dh, 0x0 ; no of sector
mov dl, 0x0 ; drive number
mov ch, 0x0 ; cylinder 0
mov cl, 0x02 ; starting sector

read_disk1:
    mov ah, 0x02 ; BIOS int 13/0x02 read disk sector
    mov al, 0x01 ; # of sector to read
    int 0x13

    jc read_disk1 ; retry

;; -------------------------
;; Load Kernel
;; -------------------------
mov BX, 0x2000 ; load sector to mem 0x2000
mov es, bx     ; ES = 0x1000
mov bx, 0x0      ; ES:BX = 0x1000:0

mov dh, 0x0 ; no of sector
mov dl, 0x0 ; drive number
mov ch, 0x0 ; cylinder 0
mov cl, 0x03 ; starting sector

read_disk2:
    mov ah, 0x02 ; BIOS int 13/0x02 read disk sector
    mov al, 0x02 ; # of sector to read
    int 0x13

    jc read_disk2 ; retry

;; -------------------------
;; Segmenting
;; -------------------------
mov ax, 0x2000
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ss, ax

jmp 0x2000:0x0

times 510-($-$$) db 0
dw 0xaa55
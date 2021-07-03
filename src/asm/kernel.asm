;; Kernel
;; ==============================
    ;; Print Menu
main_menu:
    call resetTextScreen

    mov si, kernel_header
    call printString

;; Get user input
get_input:
    mov di, cmdString

keyloop:
    mov ax, 0x00
    int 0x16        ; get Keystroke, character goes to al

    ;; print user input
    mov ah, 0x0e
    cmp al, 0xD
    je run_cmd
    int 0x10
    mov [di], al
    inc di
    jmp keyloop

run_cmd:
    mov byte [di], 0
    mov al, [cmdString]
    cmp al, 'F'     ; F -> success
    je fileBrowser
    cmp al, 'R'     ; R -> reboot
    je reboot
    cmp al, 'P'     ; P -> Print registers
    je register_print
    cmp al, 'G'     ; Graphics mode test
    je graphics_test
    cmp al, 'N'     ; N -> end program
    je end_prog
    mov si, failure
    call printString
    jmp get_input

        ;; ============================
        ;;  F) File Browser
        ;; ============================

fileBrowser:
    call resetTextScreen

    ;; Load file table string from memory location 0x1000
    mov si, file_header
    call printString

    xor cx, cx
    mov ax, 0x1000
    mov es, ax
    xor bx, bx
    mov ah, 0x0e

    mov al, [ES:BX]

fileName_loop:
    mov al, [ES:BX]
    cmp al, 0
    je get_prog_name

    int 0x10
    cmp cx, 9
    je file_ext
    inc cx
    inc bx

    jmp fileName_loop

file_ext:
    mov cx, 3
    call print_blanks_loop

    inc bx
    mov al, [ES:BX]
    int 0x10
    inc bx
    mov al, [ES:BX]
    int 0x10
    inc bx
    mov al, [ES:BX]
    int 0x10

dir_entry_number:
    mov cx, 9
    call print_blanks_loop

    inc bx
    mov al, [ES:BX]
    call print_hex_as_ascii

start_sector_number:
    mov cx, 9
    call print_blanks_loop

    inc bx
    mov al, [ES:BX]
    call print_hex_as_ascii

file_size:
    mov cx, 14
    call print_blanks_loop

    inc bx
    mov al, [ES:BX]
    call print_hex_as_ascii
    mov al, 0xA
    int 0x10
    mov al, 0xD
    int 0x10

    inc bx
    xor cx, cx
    jmp fileName_loop

get_prog_name:
    mov al, 0xA
    int 0x10
    mov al, 0xD
    int 0x10
    mov di, cmdString
    mov byte [cmdLength], 0

prog_name_loop:
    mov ax, 0x00
    int 0x16        ; get Keystroke, character goes to al

    mov ah, 0x0e
    cmp al, 0xD
    je start_search

    inc byte [cmdLength]
    mov [di], al
    inc di
    int 0x10
    jmp prog_name_loop

start_search:
    mov di, cmdString
    xor bx, bx

check_next_char:
    mov al, [ES:BX]
    cmp al, 0
    je prog_not_found

    cmp al, [di]
    je start_compare

    add bx, 16
    jmp check_next_char

start_compare:
    push bx
    mov byte cl, [cmdLength]

compare_loop:
    mov al, [ES:BX]
    inc bx
    cmp al, [di]
    jne restart_search

    dec cl
    jz found_program
    inc di
    jmp compare_loop

restart_search:
    mov di, cmdString
    pop bx
    inc bx
    jmp check_next_char

prog_not_found:
    mov si, notFoundString
    call printString
    mov ah, 0x00
    int 0x16
    mov ah, 0x0e
    int 0x10
    cmp al, 'Y'
    je fileBrowser
    jmp fileTable_end

found_program:
    add bx, 4
    mov cl, [ES:BX]     ; sector # to start reading from
    inc bx
    mov bl, [ES:BX]     ; # of sectors to read

    xor ax, ax
    mov dl, 0x00
    int 0x13            ; reset disk system

    mov ax, 0x8000
    mov es, ax
    mov al, bl          ; # of sectors to read
    xor bx, bx          ; ES:BX = 0x8000:0x0000

    mov ah, 0x02
    mov ch, 0x00        ; track #
    mov dh, 0x00        ; head #
    mov dl, 0x00        ; drive #

    int 0x13
    jnc prog_loaded

    mov si, notLoaded
    call printString
    mov ah, 0x00
    int 0x16
    jmp fileBrowser

prog_loaded:
    mov ax, 0x8000
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    jmp 0x8000:0x0000


fileTable_end:
    mov si, goBackMsg
    call printString

    mov ah, 0x00    ; get keystroke
    int 0x16
    jmp main_menu

        ;; ============================
        ;;  R) Reboot
        ;; ============================

reboot:
    jmp 0xFFFF:0x0000   ; Far jmp to reset vector

        ;; ============================
        ;;  P) Print registers
        ;; ============================
register_print:
    call resetTextScreen

    mov si, printReg_header
    call printString
    call print_registers
    mov si, goBackMsg
    call printString
    mov ah, 0x00
    int 0x16
    jmp main_menu

        ;; ============================
        ;;  G) Graphics Mode test
        ;; ============================
graphics_test:
    call resetGraphicsScreen
    
    ;; Test Square
    mov ah, 0x0C    ; int 10h ah 0x0C - write gfx pixel
    mov al, 0x01    ; blue
    mov bh, 0x00    ; page screen

    ;; Starting pixel
    mov cx, 100    ; column
    mov dx, 100    ; row
    int 0x10

squareColLoop:
    inc cx
    int 0x10
    cmp cx, 150
    jne squareColLoop

    inc dx
    int 0x10
    mov cx, 99
    cmp dx, 150
    jne squareColLoop

    mov ah, 0x00
    int 0x16
    jmp main_menu

        ;; ============================
        ;;  N) End Program
        ;; ============================
end_prog:
    cli
    hlt

print_hex_as_ascii:
    mov ah, 0x0e
    add al, 0x30
    cmp al, 0x39
    jle hexNum
    add al, 0x7

hexNum:
    int 0x10
    ret

print_blanks_loop:
    cmp cx, 0
    je end_blanks_loop
    mov ah, 0x0e
    mov al, ' '
    int 0x10
    dec cx
    jmp print_blanks_loop

end_blanks_loop:
    ret

%include "../src/print/print_string.asm"
%include "../src/print/print_hex.asm"
%include "../src/print/print_registers.asm"
%include "../src/screen/resetTextScreen.asm"
%include "../src/screen/resetGraphicsScreen.asm"

        ;; ============================
        ;;  Variables
        ;; ============================

kernel_header: db '        ****    TermOS    ****', 0xA, 0xD, 0xA, 0xD, 0

file_header: db '-------------------------------------------------------------', 0xA, 0xD,\
                'File Name   Extension   Entry #   Start sector   size(sector)', 0xA, 0xD,\
                '-------------------------------------------------------------', 0xA, 0xD, 0

printReg_header: db '---------------------------', 0xA, 0xD,\
                    'Register       Mem Location', 0xA, 0xD,\
                    '---------------------------', 0xA, 0xD, 0

notFoundString: db 0xA, 0xD, 'Program not found. Try Again (Y)', 0xA, 0xD, 0
cmdLength: db 0

success: db 0xA, 0xD, 'Loaded', 0xA, 0xD, 0
failure: db 0xA, 0xD, 'Command not found', 0xA, 0xD, 0
notLoaded: db 0xA, 0xD, 'Program not loaded! Try again', 0xA, 0xD, 0
secNotFound: db 0xA, 0xD, 'Sector not found! Try again (Y)', 0xA, 0xD, 0
goBackMsg: db 0xA, 0xD, 0xA, 0xD, 'Press any key to go back...', 0xA, 0xD, 0
cmdString: db ' ', 0

        ;; ============================
        ;;  Sector Padding Magic
        ;; ============================

times 1536-($-$$) db 0

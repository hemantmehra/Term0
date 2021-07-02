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
    mov ax, 0x1000
    mov es, ax
    xor cx, cx
    xor bx, bx
    mov ah, 0x0e

fileTable_loop:
    inc bx
    mov al, [ES:BX]
    cmp al, '}'
    je stop
    cmp al, '-'
    je sectorNumber_loop
    cmp al, ','
    je next_element
    inc cx
    int 0x10
    jmp fileTable_loop

sectorNumber_loop:
    cmp cx, 0x21
    je fileTable_loop
    mov al, ' '
    int 0x10
    inc cx
    jmp sectorNumber_loop

next_element:
    xor cx, cx
    mov al, 0xA
    int 0x10
    mov al, 0xD
    int 0x10
    mov al, 0xA
    int 0x10
    mov al, 0xD
    int 0x10
    jmp fileTable_loop

stop:
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
    
    mov ah, 0x0C    ; int 10h ah 0x0C - write gfx pixel
    mov al, 0x01    ; blue
    mov bh, 0x00    ; page screen
    mov cx, 0x64    ; column
    mov dx, 0x64    ; row
    int 0x10
    hlt

        ;; ============================
        ;;  N) End Program
        ;; ============================
end_prog:
    cli
    hlt

%include "../src/print/print_string.asm"
%include "../src/print/print_hex.asm"
%include "../src/print/print_registers.asm"
%include "../src/screen/resetTextScreen.asm"
%include "../src/screen/resetGraphicsScreen.asm"

        ;; ============================
        ;;  Variables
        ;; ============================

kernel_header: db '--------------------------------', 0xA, 0xD,\
            '       Welcome to TermOS        ', 0xA, 0xD,\
            '--------------------------------', 0xA, 0xD, 0xA, 0xD,\
            'F) File Loader', 0xA, 0xD,\
            'R) Reboot', 0xA, 0xD,\
            'P) Print Registers', 0xA, 0xD,\
            'G) Graphics Mode Test', 0xA, 0xD, 0

file_header: db '------------------------------------', 0xA, 0xD,\
                'File                          Sector', 0xA, 0xD,\
                '------------------------------------', 0xA, 0xD, 0

printReg_header: db '-----------------------------', 0xA, 0xD,\
                    'Register         Mem Location', 0xA, 0xD,\
                    '-----------------------------', 0xA, 0xD, 0

success: db 0xA, 0xD, 'Loaded', 0xA, 0xD, 0
failure: db 0xA, 0xD, 'Command not found', 0xA, 0xD, 0
goBackMsg: db 0xA, 0xD, 0xA, 0xD, 'Press any key to go back...', 0xA, 0xD, 0
cmdString: db '', 0

        ;; ============================
        ;;  Sector Padding Magic
        ;; ============================

times 1024-($-$$) db 0

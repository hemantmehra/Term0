;; Kernel
    mov ah, 0x00 ; set video mode
    mov al, 0x01 ; 40 X 25 video mode
    int 0x10

    ;; Change color
    mov ah, 0x0B
    mov bh, 0x00
    mov bl, 0x01
    int 0x10

    ;; Print Menu
    mov si, string1
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
    cmp al, 'N'     ; N -> end program
    je end_prog
    mov si, failure
    call printString
    jmp get_input

        ;; ============================
        ;;  F) File Browser
        ;; ============================

fileBrowser:
    mov si, success
    call printString
    jmp get_input

        ;; ============================
        ;;  R) Reboot
        ;; ============================

reboot:
    jmp 0xFFFF:0x0000   ; Far jmp to reset vector

        ;; ============================
        ;;  N) End Program
        ;; ============================
end_prog:
    cli
    hlt

printString:
    mov ah, 0x0e ; 0x0e for BIOS teletype output 
    mov bh, 0x0
    mov bl, 0x07

printChar:
    mov al, [si]
    cmp al, 0
    je end_string
    int 0x10
    add si, 1
    jmp printChar

end_string:
    ret

        ;; ============================
        ;;  Variables
        ;; ============================

string1: db '--------------------------------', 0xA, 0xD,\
            '       Welcome to TermOS        ', 0xA, 0xD,\
            '--------------------------------', 0xA, 0xD, 0xA, 0xD,\
            'F) File & Program Browser/Loader', 0xA, 0xD,\
            'R) Reboot', 0xA, 0xD, 0

success: db 0xA, 0xD, 'Loaded', 0xA, 0xD, 0
failure: db 0xA, 0xD, 'Command not found', 0xA, 0xD, 0
cmdString: db ''

        ;; ============================
        ;;  Sector Padding Magic
        ;; ============================

times 510-($-$$) db 0

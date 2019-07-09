[org 0x7c00]                        ; Set the BIOS boot sector base address

the_loop:
    mov dx, 0xbeef
    call print_hex

    mov al, 0xa                     ; New line
    call print_char
    mov al, 0xd                     ; Carriage return
    call print_char
    
    mov bx, MSG
    call print_string

    mov al, 0xa
    call print_char
    mov al, 0xd
    call print_char
    
    jmp the_loop

print_char:
    pusha
    mov ah, 0x0e                    ; When we interrupt, use "scrolling teletype routine"
    int 0x10                        ; Interrupt, print the character
    popa
    ret

print_string:
    pusha
    print_string_loop:
        mov al, [bx]                ; Move the current char into register a
        cmp al, 0                   ; If it's NULL,
        je print_string_finished    ; We're done
        call print_char             ; Otherwise, print the char
        add bx, 1                   ; Move the index
        jmp print_string_loop
    print_string_finished:
        popa
        ret

print_hex:
    pusha
    mov bx, HEX_OUT+5               ; Set index for string number insertion
    print_hex_loop:
        mov ax, HEX_OUT+1           ; Set lower bound of hex numbers
        cmp ax, bx                  ; If we've hit the lower bound
        je print_hex_finished       ; We're done, finish
        mov al, dl                  ; Otherwise, move the remainder of the number into register a
        and al, 0xf                 ; Mask everything but the last byte
        call num_to_char            ; Convert to ASCII
        mov [bx], al                ; Store ASCII rep into mem
        shr dx, 4                   ; Shift the remainder of the number
        sub bx, 1                   ; Move the index
        jmp print_hex_loop
    print_hex_finished:
        mov bx, HEX_OUT
        call print_string
        popa
        ret

num_to_char:
    push bx
    mov bl, 0xa
    cmp al, bl
    jge num_to_char_AtoF
    num_to_char_0to9:
        add al, 0x30                ; Shift to 0-9
        jmp num_to_char_finished
    num_to_char_AtoF:
        sub al, bl                  ; Shift back 0xa, to start indexing a-f at 0
        add al, 0x41                ; Shift to a-f
    num_to_char_finished:
        pop bx
        ret

HEX_OUT:
    db "0x0000", 0

MSG:
    db "Drake", 0

times 510-($-$$) db 0               ; Pad with zeroes to 510 bytes
dw 0xaa55                           ; 2 byte magic number for boot sector
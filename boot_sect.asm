[org 0x7c00]                ; Set the BIOS boot sector base address

mov ah, 0x0e                ; When we interrupt, use "scrolling teletype routine"

the_loop:
    mov bx, message         ; Set the "parameter" for print_string
    call print_string
    jmp the_loop

print_string:
    pusha                   ; Push all registers to the stack
    print_loop:
        mov al, [bx]
        cmp al, 0
        je print_finished
        int 0x10
        add bx, 1
        jmp print_loop
    print_finished:
        popa                ; Pop all registers from the stack
        ret

message:
    db "Drake", 0

times 510-($-$$) db 0       ; Pad with zeroes to 512 bytes
dw 0xaa55                   ; Magic number for boot sector
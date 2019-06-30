[org 0x7c00]                ; Set the BIOS boot sector base address

mov ah, 0x0e                ; When we interrupt, use "scrolling teletype routine"

reset:
    mov bx, message         ; Set bx to the message offset position
    jmp theloop           ; Jump into the loop

theloop:
    mov cx, [bx]            ; Temporarily store the character for cmp
    cmp cx, 0               ; Check if we've reached the null byte
    je reset                ; If we have reached the null byte, reset
    
    mov al, [bx]            ; Provide the character for the interrupt
    int 0x10                ; Do it

    add bx, 0x1             ; Increment char ptr
    jmp theloop           ; Loop again

message:
    db "Drake", 0

times 510-($-$$) db 0       ; Pad with zeroes to 512 bytes
dw 0xaa55                   ; Magic number for boot sector
mov ah, 0x0e                ; When we interrupt, use "scrolling teletype routine"

reset:
    mov bx, message         ; Set bx to the message address
    add bx, 0x7c00          ; Offset it by the BIOS boot record offset
    jmp loopLabel           ; Jump into the loop

loopLabel:
    mov cx, [bx]            ; Temporarily store the character for cmp
    cmp cx, 0               ; Check if we've reached the null byte
    je reset                ; If we have reached the null byte, reset
    
    mov al, [bx]            ; Provide the character for the interrupt
    int 0x10                ; Do it

    add bx, 0x1             ; Increment char ptr
    jmp loopLabel           ; Loop again

message:
    db "Drake", 0

times 510-($-$$) db 0       ; Pad with zeroes to 512 bytes
dw 0xaa55                   ; Magic number for boot sector
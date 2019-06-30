loopLabel:
    mov ah, 0x0e            ; When we interrupt, use "scrolling teletype routine"

    mov al, 'D'             ; Provide the character for the interrupt
    int 0x10                ; Do it

    jmp loopLabel           ; Loop forever dude

times 510-($-$$) db 0       ; Pad with zeroes to 512 bytes
dw 0xaa55                   ; Magic number for boot sector
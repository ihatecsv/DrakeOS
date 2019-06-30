loopLabel:
    jmp loopLabel           ; Loop forever dude

times 510-($-$$) db 0       ; Pad with zeroes to 512 bytes
dw 0xaa55                   ; Magic number for boot sector
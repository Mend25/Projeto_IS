org 0x7c00
jmp _start

message1 db "                        SOCCER PONG", 10, 13, 10, 13, "Press enter to start", 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, "                Instructions", 0

_start:
    xor ax, ax
    xor si, si
    xor bx, bx
    
    mov ah, 0 
    mov al, 12h
    int 10h
    
    mov bl, 0xf 
    mov ah, 0eh
    mov bh, 0
    mov bl, 2

    mov si, message1
    call print_loop

    call done
    

print_loop:
    lodsb
    cmp al, 0
    je .done
    call putchar
    jmp print_loop
    
    .done:
        ret    

endl:
    mov ah, 0x0a
    call putchar
    mov ah, 0x0d
    call putchar
    ret
    
putchar:
    mov ah, 0x0e
    int 10h
    ret
    
done:
    jmp $

times 510 - ($ - $$) db 0
dw 0xaa55



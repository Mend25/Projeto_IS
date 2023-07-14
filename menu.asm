org 0x7c00
jmp _start

message1 db "                          SOCCER PONG", 10, 13, 10, 13, 10, 13, "             Press ENTER to start", 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, "                          INSTRUCTIONS", 10, 13, 10, 13, 10, 13,  "             Player 1:                    Player 2:", 10, 13, 10, 13,"             W -> up                      O -> up", 10, 13, "             S -> down                    L -> down", 0
_start:
    xor ax, ax
    xor si, si
    xor bx, bx
    
    mov ah, 0 
    mov al, 14h
    int 10h
    
    mov bl, 0xf 
    mov ah, 0eh
    mov bh, 0
    mov bl, 2

    mov si, message1
    call print_loop
    xor ax, ax
    call waitStart
    
    xor ax, ax
    
    mov ah, 0 
    mov al, 12h
    int 10h

    call done
    

print_loop:
    lodsb
    cmp al, 0
    je .done
    call putchar
    jmp print_loop
    
    .done:
        ret    


waitStart:
    call getchar
    
    cmp al, 0x0d
    je .done
    
    jmp waitStart
    
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

getchar:
    mov ah, 0x00 
    int 16h
    ret

done:
    jmp $

times 510 - ($ - $$) db 0
dw 0xaa55

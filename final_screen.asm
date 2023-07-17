final_screen:
    mov ah, 0 
    mov al, 13h
    int 10h

    mov bl, 0xf 
    mov ah, 0eh
    mov bh, 0
    mov bl, 2
    ;entra na tela final

    xor si, si

    mov si, message3
    call print_loop
    xor ax, ax
    call final_score

    mov si, message4
    call print_loop


    xor ax, ax
    call wait_command
    
    xor ax, ax

print_loop:
    lodsb
    cmp al, 0
    je .done
    call putchar
    jmp print_loop

    .done:
        ret

wait_command:
    call getchar

    cmp al, 'f'
    je .done

    jmp wait_command

    .done:
        ret

final_score:
    mov ax, [counter]
    mov dx, 0
    mov cx, 10
    div cx
    add ax, '0'

    call put_score
    
    sub ax, '0'
    mov ax, dx
    add ax, '0'
    call put_score

    ret

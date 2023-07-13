org 0x7c00
jmp 0x0000:_start

flag db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 7, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 8, 7, 8, 8, 8, 8, 0, 0, 0, 0, 8, 8, 0, 0, 0, 0, 8, 8, 8, 8, 3, 1, 8, 8, 8, 8, 1, 8, 0, 0, 0, 0, 0, 0, 8, 8, 1, 3, 9, 9, 8, 1, 9, 8, 0, 0, 0, 0, 0, 0, 8, 8, 9, 9, 15, 15, 9, 9, 9, 8, 0, 0, 0, 0, 8, 0, 8, 9, 9, 9, 9, 3, 9, 9, 9, 1, 0, 0, 0, 0, 8, 8, 8, 9, 15, 15, 15, 3, 9, 9, 9, 1, 0, 0, 0, 0, 8, 0, 8, 9, 9, 9, 15, 15, 9, 9, 3, 8, 0, 0, 0, 0, 8, 8, 8, 8, 8, 9, 9, 9, 9, 8, 8, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 8, 1, 9, 9, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 

_start:
	xor ax, ax
    xor cx, cx
   	xor dx, dx
    mov bx, 10
	mov si, flag
	
	mov ah, 0
	mov al, 13h
	int 10h

    mov dx, bx
    add bx, 16
	call load_pixel

	jmp done
	
load_pixel:
	lodsb
	mov ah, 0ch
	int 10h
	
	jmp .travel_by_image

    .travel_by_image:
        inc cx
        cmp cx, 16
        jne load_pixel
        
        xor cx, cx
        inc dx
        cmp dx, bx
        jne load_pixel
        
        ret

read_key:
    call getchar

    cmp al, 0x0d
    je .done

    cmp al, 'w'
    je .up 
    
    cmp al, 's'
    je .down 
    
    cmp al, 'd'
    je .right
    
    cmp al, 'a'
    je .left 
    

    jmp read_key

    .done:
        ret
    .up:
        mov al, 'U'
        call putchar
        jmp read_key
    .down:
        mov al, 'D'
        call putchar
        jmp read_key
    .left:
        mov al, 'L'
        call putchar
        jmp read_key
    .right:
        mov al, 'R'
        call putchar
        jmp read_key

getchar:
    mov ah, 0x00 
    int 16h
    ret

putchar:
    mov ah, 0x0e
    int 10h 
    ret

done:
    jmp $

times 510 - ($ - $$) db 0
dw 0xaa55
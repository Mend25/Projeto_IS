org 0x7c00
jmp 0x0000:_start

flag db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 7, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 8, 7, 8, 8, 8, 8, 0, 0, 0, 0, 8, 8, 0, 0, 0, 0, 8, 8, 8, 8, 3, 1, 8, 8, 8, 8, 1, 8, 0, 0, 0, 0, 0, 0, 8, 8, 1, 3, 9, 9, 8, 1, 9, 8, 0, 0, 0, 0, 0, 0, 8, 8, 9, 9, 15, 15, 9, 9, 9, 8, 0, 0, 0, 0, 8, 0, 8, 9, 9, 9, 9, 3, 9, 9, 9, 1, 0, 0, 0, 0, 8, 8, 8, 9, 15, 15, 15, 3, 9, 9, 9, 1, 0, 0, 0, 0, 8, 0, 8, 9, 9, 9, 15, 15, 9, 9, 3, 8, 0, 0, 0, 0, 8, 8, 8, 8, 8, 9, 9, 9, 9, 8, 8, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 8, 1, 9, 9, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 


_start:
	;setup
    xor ax, ax
    xor cx, cx
   	xor dx, dx
    mov di, 100 ;posição y inicial da primeira barra
    mov bp, 100 ;posição y inicial da segunda barra
    ;mov bh, 0
    ;mov bl, 100

	call clear_screen
    call load_first_bar
    call load_second_bar
    call load_ball
    ;loop
    call game_loop

	jmp done

game_loop:
    call update_first_bar
    call update_second_bar
    call load_ball

    jmp game_loop


load_first_bar:
    mov si, flag
    mov dx, di
    add di, 16
    xor cx, cx
	call print_first_bar
    sub di, 16
    ret

load_second_bar:
    mov si, flag
    mov dx, bp
    add bp, 16
    mov cx, 300
	call print_second_bar
    sub bp, 16
    ret

print_first_bar:
	lodsb
	mov ah, 0ch
	int 10h
	
	jmp .travel_by_image

    .travel_by_image:
        inc cx
        cmp cx, 16
        jne print_first_bar
        
        xor cx, cx
        inc dx
        cmp dx, di
        jne print_first_bar
        
        ret

print_second_bar:
	lodsb
	mov ah, 0ch
	int 10h
	
	jmp .travel_by_image

    .travel_by_image:
        inc cx
        cmp cx, 316
        jne print_second_bar
        
        mov cx, 300
        inc dx
        cmp dx, bp
        jne print_second_bar
        
        ret

update_first_bar:
    call getchar

    cmp al, 0x0d
    je .done

    cmp al, 's'
    je .down
    
    cmp al, 'w'
    je .up 

    .done:
        ret
    .up:
        cmp di, 0
        je .update

        sub di, 5

        .update:
            call clear_screen
            call load_first_bar
            call load_second_bar

        jmp update_first_bar

    .down:
        cmp di, 180
        je .update_
        
        add di, 5
        
        .update_:
            call clear_screen
            call load_first_bar
            call load_second_bar

        jmp update_first_bar
    

update_second_bar:
    call getchar

    cmp al, 0x0d
    je .done_s

    cmp al, 'a'
    je .down_s
    
    cmp al, 'd'
    je .up_s

    .done_s:
        ret
    .up_s:
        cmp bp, 0
        je .update_s

        sub bp, 5

        .update_s:
            call clear_screen
            call load_first_bar
            call load_second_bar

        jmp update_second_bar

    .down_s:
        cmp bp, 180
        je .update_s_
        
        add bp, 5
        
        .update_s_:
            call clear_screen
            call load_first_bar
            call load_second_bar
        
        jmp update_second_bar

getchar:
    mov ah, 0x00 
    int 16h
    ret

clear_screen:
    mov ah, 0
	mov al, 13h
	int 10h
    ret

; update_ball:
;     cmp bl, 0
;     je .turn_right    
    
;     cmp bl, 200
;     je .turn_left

;     .movement:
;         cmp bh, 1
;         je .left

;         cmp bh, 0
;         je .right

;         .left:
;             call clear_screen
            
;             mov dx, 100
            
;             add bl, 5
            
;             mov cl, bl
;             mov ch, 0
            
;             call load_ball
;             jmp update_ball

;         .right:
;             call clear_screen
            
;             mov dx, 100
            
;             sub bl, 5
            
;             mov cl, bl
;             mov ch, 0
            
;             call load_ball
;             jmp update_ball

;     .turn_left:
;         mov bh, 1
;         jmp .movement

;     .turn_right:
;         mov bh, 0
;         jmp .movement

load_ball:
    mov al, '#'
    mov ah, 0x0e
    int 10h 
    ret

done:
    jmp $

times 510 - ($ - $$) db 0
dw 0xaa55

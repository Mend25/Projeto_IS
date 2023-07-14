game_loop:
    ;call update_first_bar
    call update_second_bar
    call update_ball

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

load_ball:
    mov si, cometa
    mov dh, 0
    mov dl, bl
    add bl, 16
    mov cx, 100
	call print_ball
    sub bl, 16
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

print_ball:
	lodsb
	mov ah, 0ch
	int 10h
	
	jmp .travel_by_image

    .travel_by_image:
        inc cx
        cmp cx, 116;alterar
        jne print_ball
        
        mov cx, 100;alterar
        inc dl
        cmp dl, bl
        jne print_ball
        
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
            call load_ball
        
        ret
        ;jmp update_first_bar

    .down:
        cmp di, 180
        je .update_
        
        add di, 5
        
        .update_:
            call clear_screen
            call load_first_bar
            call load_second_bar
            call load_ball
        ret
        ;jmp update_first_bar
    

update_second_bar:
    ; call getchar
    mov al, bl
    mov ah, 0

    cmp bp, ax
    jb .down_s
    
    cmp bp, ax
    ja .up_s

    .done_s:
        ret
    .up_s:
        ; cmp bp, 0
        ; je .update_s

        sub bp, 5

        .update_s:
            call clear_screen
            call load_first_bar
            call load_second_bar
            call load_ball

        jmp update_second_bar

    .down_s:
        ; cmp bp, 180
        ; je .update_s_
        
        add bp, 5
        
        .update_s_:
            call clear_screen
            call load_first_bar
            call load_second_bar
            call load_ball
        
        jmp update_second_bar

update_ball:
    cmp bl, 180
    ja .goup

    cmp bl, 0
    jbe .godown

    .ball_movement:
        cmp bh, 1
        je .up_ball

        cmp bh, 0
        je .down_ball

    .goup:
        mov bh, 1
        jmp .ball_movement

    .godown:
        mov bh, 0
        jmp .ball_movement

    .up_ball:
        sub bl, 5
        jmp .update_movement

    .down_ball:
        add bl, 5
        jmp .update_movement

    .update_movement:
        call clear_screen
        call load_first_bar
        call load_second_bar
        call load_ball

        call delay
        
        ret

; getchar_tout:
;     ; Configura o contador de temporização para 100ms (10 pulsos de 10ms cada)
;     mov ax, 40h         ; 40h = 64 em decimal
;     mov es, ax
;     mov ax, 10          ; Configura para 10 pulsos
;     mov bx, 0           ; Sem função específica
;     int 15h

;     ; Lê um caractere
;     call getchar

;     ; Verifica se o tempo limite foi atingido
;     cmp timeout, 1
;     je .timeout_reached

;     .timeout_reached:
;         mov al, 0x0d
    ret

getchar:
    mov ah, 0x00 
    int 16h
    ret

clear_screen:
    mov ah, 0
	mov al, 13h
	int 10h
    ret

delay:
	mov cx, 01h
    mov dx, 86a0h
    mov ah, 86h
    int 15h
    ret

done:
    jmp $


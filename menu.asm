%define blackColor 0
%define blueColor 1
%define darkGreenColor 2
%define blue 3
%define redColor 4
%define lightGrayColor 7
%define greenColor 10
%define yellowColor 14
%define whiteColor 15

%macro setText 4
	mov ah, 02h  ; Setando o cursor
	mov bh, 0    ; Pagina 0
	mov dh, %1   ; Linha
	mov dl, %2   ; Coluna
	int 10h
	mov bx, %4
	mov si, %3
	call printf_color
	
%endmacro

%macro drawer 1
	mov ah, 0ch 
	mov al, %1
	mov bh, 0
	
%endmacro

%macro drawSquare 4
	mov cx, %1
	.draw_rows:
		mov dx, %2
		int 10h
		mov dx, %4
		int 10h
		inc cx
		cmp cx, %3
		je .end_column
		jmp .draw_rows
	.end_column:
		mov dx, %2
	.draw_columns:
		mov cx, %1
		int 10h
		mov cx, %3
		int 10h
		inc dx
		cmp dx, %4
    jne .draw_columns
    
%endmacro

%macro drawCursor 4
    mov cx, %1
	.draw_seg:
		mov dx, %3-1
		int 10h
		mov dx, %3
		int 10h
		inc cx
		cmp cx, %4
		je .end_column
		jmp .draw_seg
	.end_column:
		mov dx, %2
	.draw_columns:
		mov cx, %4-2
		int 10h
		mov cx, %4-1
		int 10h
		inc dx
		cmp dx, %3
	jne .draw_columns
	
%endmacro

%macro blackBackgroundApp 4
	mov ah, 0ch 
	mov al, blackColor
	mov bh, 0
	mov cx, %1
	mov dx, %2
	.draw_seg:
		int 10h
		inc cx
		cmp cx, %3
		je .jump_row
		jne .draw_seg
	.back_column:
		mov cx, %1
		jmp .draw_seg
	.jump_row:
		inc dx
		cmp dx, %4
		jne .back_column
	mov al, blue ; Voltando a cor original
%endmacro



menu:
    call initVideo
	call draw_border ; Escreve nome de cada APP
	call draw_box_app ; Desenha os retangulos
	setText 1, 14, message1, darkGreenColor
	setText 6, 5, play, darkGreenColor
	setText 6, 27, instruction, darkGreenColor
	setText 20, 2, highest, darkGreenColor
	setText 13, 4, credits, darkGreenColor
	setText 13, 28, exit_message, darkGreenColor
	
	call first_cursor ; Inicia a aplicação
	
	mov ah, 0 
    mov al, 12h
    int 10h
	
initVideo:
	mov ah, 00h
	mov al, 13h
	int 10h
    ret

printf_color:
	loop_print_string:
		lodsb
		cmp al,0
		je end_print_string
		mov ah,0eh
		int 10h
		jmp loop_print_string
	end_print_string:
ret

draw_border:
	drawer whiteColor
	mov cx, 0
	.draw_seg:
		mov dx, 0
		int 10h
		mov dx, 199
		int 10h
		inc cx
		cmp cx, 319
		je .end_column
		jmp .draw_seg
	.end_column:
		mov dx, 0
	.draw_columns:
		mov cx, 0
		int 10h
		mov cx, 319
		int 10h
		inc dx
		cmp dx, 199
		jne .draw_columns
	ret

draw_box_app:
    drawer darkGreenColor
	call box_app1
	drawer darkGreenColor
	call box_app2
	drawer darkGreenColor
	call box_app3
	drawer darkGreenColor
	call box_app4
    ret

box_app1: 
    drawSquare 20, 35, 100, 70
	blackBackgroundApp 21, 36, 100, 70
	ret

box_app2:
	drawSquare 200, 35, 280, 70
	blackBackgroundApp 201, 36, 280, 70
	ret
	
box_app3: 
	drawSquare 200, 90, 280, 125
	blackBackgroundApp 201, 91, 280, 125
	ret
	
box_app4:
	drawSquare 20, 90, 100, 125
	blackBackgroundApp 21, 91, 100, 125
	ret

first_cursor:
	call cursor_app2
	call cursor_app3
	drawCursor 85, 54, 67, 98

    call getchar
    
    cmp al, 13
    je .done
    cmp al, 'd'
    je second_cursor
    cmp al, 's'
    je third_cursor
    
    jmp first_cursor   
    
    .done:
        ret

second_cursor:
	call cursor_app1
	call cursor_app4
	drawCursor 265, 54, 67, 278

    call getchar
    
    cmp al, 13
    je instructions
    cmp al, 'a'
    je first_cursor
    cmp al, 's'
    je fourth_cursor
 
    jmp second_cursor

    ret
    
third_cursor:
	call cursor_app1
	call cursor_app4
	drawCursor 85, 109, 122, 98

    call getchar
    
    cmp al, 13
    je instructions
    cmp al, 'w'
    je first_cursor
    cmp al, 'd'
    je fourth_cursor
 
    jmp third_cursor

    ret
fourth_cursor:
	call cursor_app3
	call cursor_app2
	drawCursor 265, 109, 122, 278

    call getchar
    
    cmp al, 13
    je instructions
    cmp al, 'w'
    je second_cursor
    cmp al, 'a'
    je third_cursor
 
    jmp fourth_cursor

    ret
    
cursor_app1: 
	drawer blackColor
	drawCursor 85, 54, 67, 98
	drawer darkGreenColor
	ret
	
cursor_app2: 
	drawer blackColor
	drawCursor 265, 54, 67, 278
	drawer darkGreenColor
	ret
cursor_app3:
	drawer blackColor
	drawCursor 85, 109, 122, 98
	drawer darkGreenColor
	ret
cursor_app4:
	drawer blackColor
	drawCursor 265, 109, 122, 278
	drawer darkGreenColor
	ret
    
instructions:
    xor ax, ax
    mov ah, 0 
    mov al, 13h
    int 10h

    xor ax, ax
    xor si, si
    mov si, message2
    jmp .print

    .print:
        lodsb
        cmp al, 0
        je .waitButton
        call putchar
        jmp .print

    .waitButton:
        xor ax, ax

        call getchar

        cmp al, " "
        je menu

        jmp .waitButton

putchar:
	mov ah, 0x0e
	int 10h
	ret

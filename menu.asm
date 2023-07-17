menu:
    call initVideo
	call draw_border ; Escreve nome de cada APP
	call draw_box_app ; Desenha os retangulos
	setText 1, 16, play, darkGreenColor
	setText 6, 4, instructions, darkGreenColor
	
	call first_cursor ; Inicia a aplicação
	
	mov ah, 0 
    mov al, 12h
    int 10h
	
initVideo:
	mov ah, 00h
	mov al, 13h
	int 10h
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
    drawer blue
	call box_app1
    ret

box_app1: 
    drawSquare 20, 145, 100, 180
	blackBackgroundApp 21, 146, 100, 180
	ret

first_cursor:
	call cursorApp
	drawCursor 85, 54, 67, 98

    call getchar
    
    cmp al, 13
    je .done
    cmp al, 'd'
    je second_cursor
  
    
    jmp first_cursor   
    
    .done:
        ret

cursorApp:
	drawer blackColor
	call cursor_app1
	drawer darkGreenColor
    ret
    
cursor_app1: 
	drawCursor 85, 54, 67, 98
	ret
	
second_cursor:
	call cursorApp
	drawCursor 85, 109, 122, 98

    call getchar
    
    cmp al, 13
    je instructions
    cmp al, 'a'
    je first_cursor
 
    jmp second_cursor

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

        call getchar_m

        cmp al, " "
        je menu

        jmp .waitButton

	ret

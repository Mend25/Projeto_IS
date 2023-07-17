org 0x7e00
jmp 0x0000:start

%include "menu.asm"
%include "game.asm"

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


data:
	;Dados do projeto...
    flag db 16, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 7, 8, 8, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 8, 7, 8, 8, 8, 8, 0, 0, 0, 0, 8, 8, 0, 0, 0, 0, 8, 8, 8, 8, 9, 1, 8, 8, 8, 8, 1, 8, 0, 0, 0, 0, 0, 0, 8, 8, 9, 9, 9, 9, 8, 9, 9, 8, 0, 0, 0, 0, 0, 0, 8, 1, 9, 9, 15, 15, 9, 9, 9, 8, 0, 0, 0, 0, 0, 0, 8, 9, 9, 9, 9, 9, 9, 9, 9, 1, 0, 0, 0, 0, 0, 0, 8, 9, 15, 15, 15, 9, 9, 9, 9, 9, 0, 0, 0, 0, 0, 0, 8, 9, 9, 9, 15, 15, 9, 9, 9, 8, 0, 0, 0, 0, 8, 8, 8, 8, 1, 9, 9, 9, 9, 8, 8, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 8, 1, 9, 9, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    cometa db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'.',0,0,0,0,6,6,6,6,6,0,6,6,6,0,0,0,'.',0,0,6,6,6,6,6,6,6,0,6,6,6,0,0,0,'.',0,6,0,6,6,6,6,6,0,6,6,6,6,6,6,0,'.',0,0,6,6,6,6,0,0,6,6,6,6,6,6,6,0,'.',0,6,0,6,6,0,6,0,6,6,0,0,0,6,6,0,'.',0,0,6,6,6,6,6,6,0,6,6,6,0,6,6,0,'.',0,6,6,6,6,6,6,6,6,6,6,6,6,0,0,0,'.',0,6,6,0,6,0,6,6,6,6,6,6,6,6,6,6,'.',0,6,6,6,0,6,6,6,6,0,6,6,6,6,6,6,'.',0,6,6,6,0,6,6,6,6,0,6,6,6,0,6,6,'.',0,6,6,6,6,0,0,0,0,6,6,6,6,0,6,6,'.',0,6,6,6,0,6,6,0,6,6,6,6,6,0,6,6,'.',0,6,6,0,6,6,6,0,6,6,6,6,6,6,0,0,'.',0,0,0,6,6,6,6,0,6,6,6,6,6,6,0,0,'.',0,0,0,0,0,0,0,6,6,6,6,6,6,0,0,0,'0'
    message1 db "               SOCCER PONG", 10, 13, 10, 13, 10, 13, 10, 13, "        Press ENTER to start", 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, "             INSTRUCTIONS", 10, 13, 10, 13, 10, 13, "        Player", 10, 13, 10, 13, 10, 13, "        W -> up", 10, 13, 10, 13, "        S -> down", 0
    message2 db "This is one of the hardest pong games inworld history!!!", 10, 13, 10, 13, 10, 13,"Try to survive the longest!!!", 10, 13, 10, 13, 10, 13, 10, 13, "How to play:", 10, 13, 10, 13, 10, 13, "    W -> up", 10, 13, 10, 13, "    S -> down", 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, "Press SPACE to return to menu",0
    first_bar_posy dw 100
    second_bar_posy dw 100
    prev_ball_pos_x dw 100
    counter dw 0
    score_name db "           SOCCER PONG | x", 0

start:
    ;setup menu
    xor ax, ax
    xor si, si
    xor bx, bx
    
    mov ah, 0 
    mov al, 13h
    int 10h
    
    mov bl, 0xf 
    mov ah, 0eh
    mov bh, 0
    mov bl, 2

    ;loop menu

    call menu
    
    ;setup game
    xor ax, ax
    xor cx, cx
   	xor dx, dx
    mov di, 1 ;flag de sentido x
    mov bp, 200;posição x da bola
    mov bh, 0  ;flag de sentido y
    mov bl, 10  ;posição y da bola

    call clear_screen
    call load_first_bar
    call load_second_bar
    call load_ball
    
    ;loop
    call game_loop

jmp $

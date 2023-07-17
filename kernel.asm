org 0x7e00
jmp 0x0000:start

%include "menu.asm"
%include "game.asm"
%include "final_screen.asm"

data:
	;Dados do projeto...
    flag db 16, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 7, 8, 8, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 8, 7, 8, 8, 8, 8, 0, 0, 0, 0, 8, 8, 0, 0, 0, 0, 8, 8, 8, 8, 9, 1, 8, 8, 8, 8, 1, 8, 0, 0, 0, 0, 0, 0, 8, 8, 9, 9, 9, 9, 8, 9, 9, 8, 0, 0, 0, 0, 0, 0, 8, 1, 9, 9, 15, 15, 9, 9, 9, 8, 0, 0, 0, 0, 0, 0, 8, 9, 9, 9, 9, 9, 9, 9, 9, 1, 0, 0, 0, 0, 0, 0, 8, 9, 15, 15, 15, 9, 9, 9, 9, 9, 0, 0, 0, 0, 0, 0, 8, 9, 9, 9, 15, 15, 9, 9, 9, 8, 0, 0, 0, 0, 8, 8, 8, 8, 1, 9, 9, 9, 9, 8, 8, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 8, 1, 9, 9, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    cometa db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'.',0,0,0,0,6,6,6,6,6,0,6,6,6,0,0,0,'.',0,0,6,6,6,6,6,6,6,0,6,6,6,0,0,0,'.',0,6,0,6,6,6,6,6,0,6,6,6,6,6,6,0,'.',0,0,6,6,6,6,0,0,6,6,6,6,6,6,6,0,'.',0,6,0,6,6,0,6,0,6,6,0,0,0,6,6,0,'.',0,0,6,6,6,6,6,6,0,6,6,6,0,6,6,0,'.',0,6,6,6,6,6,6,6,6,6,6,6,6,0,0,0,'.',0,6,6,0,6,0,6,6,6,6,6,6,6,6,6,6,'.',0,6,6,6,0,6,6,6,6,0,6,6,6,6,6,6,'.',0,6,6,6,0,6,6,6,6,0,6,6,6,0,6,6,'.',0,6,6,6,6,0,0,0,0,6,6,6,6,0,6,6,'.',0,6,6,6,0,6,6,0,6,6,6,6,6,0,6,6,'.',0,6,6,0,6,6,6,0,6,6,6,6,6,6,0,0,'.',0,0,0,6,6,6,6,0,6,6,6,6,6,6,0,0,'.',0,0,0,0,0,0,0,6,6,6,6,6,6,0,0,0,'0'
    message1 db "SOCCER PONG", 0
    message4 db 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, " Press F to pay respect", 0   
    message3 db 10, 13, "            YOU HAVE FAILED",10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, "                 SCORE",10, 13, 10, 13, "                   ", 0
    message5 db  "Devs:", 10, 13, 10, 13, " Felipe Ferreira da Silva Santos - ffss",10, 13, 10, 13, " Guilherme Montenegro de Albuquerque - gma4",10, 13, 10 ,13, " Victor Mendonça Aguiar - vma3", 10, 13, 10, 13, " Vitor Manoel de Melo Silva - vmms", 0
    message6 db  10, 13, 10, 13, 10, 13, 10, 13, " Press SPACE to return to menu", 0
    message2 db "This is one of the hardest pong games inworld history!!!", 10, 13, 10, 13, 10, 13,"Try to survive the longest!!!", 10, 13, 10, 13, 10, 13, 10, 13, "How to play:", 10, 13, 10, 13, 10, 13, "    W -> up", 10, 13, 10, 13, "    S -> down", 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, "Press SPACE to return to menu",0
    first_bar_posy dw 100
    second_bar_posy dw 100
    prev_ball_pos_x dw 100
    counter dw 0
    highest_score1 dw 0
    exit_message db "EXIT", 0
    credits db "CREDITS", 0
    play db "PLAY", 0
    instruction db "RULES", 0
    highest db "HIGHEST SCORE :", 0
    score_name db "            SOCCER PONG | x", 0
    exit db 0;flag de saida do sistema
    exit_game db 0;flag de saida do jogo
    msg_exit db "exit...", 0
    tmp db 0
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
    mov [counter], ax
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

    ; mov ax, exit
    ; cmp ax, 1
    ; jmp $
    call final_screen
jmp start

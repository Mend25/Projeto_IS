[bits 16]
org 0x07c00

offset equ 0x1000 ; posicao da kernel na memoria, 0x1000 eh padrao do linux v0.1
drive db 0 ; drive onde a kernel ta

mov [drive], dl ; aparentemente a bios inicializa o drive de boot em dl

mov bp, 0x9000 ; setando stack, 0x9000 eh padrao do linux v0.1
mov sp, bp

call kernel
call modo_prot

jmp $

[bits 16]
kernel:
   mov bx, offset ; local da memoria q vai carregar oq ta no disco
   mov dh, 2 ; numero de setores
   mov dl, [drive] ; disco a ser carregado
   call carregar_disco
   ret
   
carregar_disco:
   pusha
   push dx; vamo fazer uma verificacao de erro pelo numero do disco
   
   ;setup pra int 13h
   
   mov ah, 0x02; modo de leitura
   mov al, dh; ler um numero dh de setores do disco
   mov cl, 0x02; começar leitura do setor 2 (setor 1 eh onde ta armazenado tudo isso)
   mov ch, 0x00; cilindro 0
   mov dh, 0x00; cabeca 0
   
   ;tanto dl quanto es:bx tao setados na rotina "kernel"
   
   int 0x13
   jc erro; vaza se der erro na interrupcao
   
   pop dx
   cmp al, dh ; depois do int 13h, bios seta al como o numero de setores lidos, iniciar rotina de erro se setores lidos =\= setores a serem lidos
   jne erro;
   
   popa
   ret
   
erro:
   jmp $ ; eu tenho mais oq fazer doq rotina de erro
   
; estrutura de dados do GDT (responsavel por armazenar a forma de segmentacao de memoria)
; notacao: numero de bits - oq tem dentro - numero de bits - oq tem dentro - ...
; estrutura: 16 - comprimento do segmento [0-15] - 16 - endereco base do segmento [0-15] - 8 - endereco base do segmento [16-23] - 8 - flags - 8 - flags + comprimento do segmento [16-19] - (descer)
; 8 - endereco base do segmento [24-31]

gdt_start: ; descritor do segmento nulo
    dq 0x0

gdt_code: ; descritor do CS - code segment
    dw 0xffff    ; comprimento do segmento [0-15]
    dw 0x0       ; endereco base do segmento [0-15]
    db 0x0       ; endereco base do segmento [16-23]
    db 10011010b ; flags
    db 11001111b ; flags + comprimento do segmento [16-19]
    db 0x0       ; endereco base do segmento [24-31]

gdt_data: ; descritor do DS - data segment
    dw 0xffff    ; comprimento do segmento [0-15]
    dw 0x0       ; endereco base do segmento [0-15]
    db 0x0       ; endereco base do segmento [16-23]
    db 10010010b ; flags (unica diferenca eh o bit indicando se eh data ou codigo)
    db 11001111b ; flags + comprimento do segmento [16-19]
    db 0x0       ; endereco base do segmento [24-31]

gdt_end:
; rotina vazia pra usar de posicao

gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; tamanho do gdt (16 bit)
    dd gdt_start ; endereco do gdt (32 bit)

codeseg equ gdt_code - gdt_start
dataseg equ gdt_data - gdt_start

[bits 16]
modo_prot:
    cli                     ; desabilitar interrupcao
    lgdt [gdt_descriptor]   ; carregar descritor do gdt
    mov eax, cr0
    or eax, 0x1             ; ir para modo protegido (mudar bit 0 de cr0 para 1)
    mov cr0, eax
    jmp codeseg
    init_32bit ; 4. far jmp (limpar pipeline de possiveis instrucoes de 16 bit)

[bits 32]
init_32bit:
    mov ax, dataseg        ; atualizar registradores de segmento
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000        ; 6. setar stack do modo protegido
    mov esp, ebp

    call inicio_protegido
   
[bits 32]
inicio_protegido:
   call offset; comeca a executar oq ta na kernel (no modo protegido)
   jmp $ ; se a kernel der ret, loop infinito


times 510 - ($ - $$) db 0
dw 0x55aa

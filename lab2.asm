; ???????? ????? ????? int 15h
; ???????? A/a ?? ???????
;------------------------------- fasm-code -------
org 100h
jmp start
.data
mess0   db    'String: $'
buff    db    80,0,80 dup(0)
old15h: dw    0,0
.code
start:  mov   ax,3515h           ; ???????? ?????? 15h
        int   21h                ;
        mov   [old15h],bx        ;
        mov   [old15h+2],es      ;
 
        mov   ax,2515h           ;
        mov   dx,int15h          ;
        int   21h                ;
 
        mov   ah,0Ah             ; ???? ? ?????
        mov   dx,buff            ;
        int   21h                ;
 
remove: mov   dx,[old15h]        ; ???????????? 
        mov   ds,[old15h+2]      ;
        mov   ax,2515h           ;
        int   21h                ;
exit:   int   20h                ; 
 
;------ ?????????? 15h ---------------
int15h: pushf                    ;
        cmp   ah,4Fh             ;
        jz    keyb               ;
fuck:   call  far [cs:old15h]    ; ???? ?? fn.4Fh
        iret                     ;
 
keyb:   cmp   al,1Eh             ; ??? A ?
        jnz   fuck               ;
        push  cx                 ; ??!
        mov   cx,'1'             ; ??????? ? ????? ?????
        mov   ah,5               ;
        int   16h                ;
        xor   ax,ax              ;
        pop   cx                 ;
        popf                     ;
        clc                      ; CF = 0 (???????????)
        retf  2                  ; ?? fn.0Ah DOS
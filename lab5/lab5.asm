.model small
.stack
.data
    a dw ?
    b dw ?
    c dw ?
    d dw ?
    spaces dw ?
    mas dw 10000 dup(?)
    result db 10, 13, "RESULT(A = $"
    incorrect db 10, 13, "WAS ENTERED INCORRECT CHARACTER!$"
    bignumber db 10, 13, "NUMBER IS TOO BIG!$"
    impossible db 10, 13, "DIVIDE BE ZERO IS IMPOSSIBLE$"
    backspace db 32, 8, "$"
    nextln db 10, 13, "$"
    spaace db 32, "$"
.code

Input proc
mov bx, 0
begin:
    mov ah, 01h
    int 21h
    
    cmp al, 13
    je exit
    
    cmp al, 27
    je escape
    
    cmp al, 8
    je bkspace
    
    cmp al, '0'
    jb error
    cmp al, '9'
    ja error
    
allisok:
    sub al, 30h
    xor ah, ah
    xchg ax, bx
    mov dx, 10
    mul dx
    add bx, ax
    
    cmp bx, 6553
    jae check
    
    jmp begin
error:
    mov dx, offset incorrect
    mov ah, 09h
    int 21h
    mov bx, 0
    jmp nextline
check:
    cmp bx, 6553
    ja numberok
    
    mov ah, 01h
    int 21h
    
    cmp al, 13
    je exit
    
    cmp al, '0'
    jb error
    cmp al, '9'
    ja error
    cmp al, '6'
    jb allisok
    
    mov dx, offset bignumber
    mov ah, 09h
    int 21h
    mov bx, 0
    jmp nextline
nextline:
    mov dx, offset nextln
    mov ah, 09h
    int 21h
    jmp begin
exit:
    ret
numberok:
    mov dx, offset nextln
    mov ah, 09h
    int 21h
    ret
escape:
    mov bx, 0
    mov dx, offset nextln
    mov ah, 09h
    int 21h
    jmp begin
bkspace:
    mov dx, offset backspace
    mov ah, 09h
    int 21h
    mov ax, bx
    xor dx, dx
    mov cx, 10
    div cx
    mov bx, ax
    jmp begin
Input endp

Output proc
    xor cx, cx
    mov bx, 10
l1:
    xor dx,dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz l1
    mov ah, 02h
    mov spaces, cx
l2:
    pop dx
    add dl, '0'
    int 21h
    loop l2
    ret
Output endp

space proc
    mov dx, offset spaace
    mov ah, 09h
    int 21h
    ret
space endp

nxtln proc
    mov dx, offset nextln
    mov ah, 09h
    int 21h
    ret
nxtln endp

main:
    mov ax, @data
    mov ds, ax

    call Input
    mov a, bx
    call Input
    mov b, bx
    call Input
    mov c, bx
    mov si, 0
    mov cx, a
again_1:
    push cx
    mov cx, b
again_2:
    call Input
    mov mas[si], bx
    inc si
    inc si
    loop again_2
    
    pop cx
    call nxtln
    loop again_1
    
    mov cx, a
    mov si, 0
    call nxtln
andagain_1:
    push cx
    mov cx, b
andagain_2:
    mov ax, mas[si]
    inc si
    inc si
    mov d, cx
    call Output
    mov ax, 7
    sub ax, spaces
    mov spaces, ax
aggain:
    mov ah, 02h
    mov dl, 32
    int 21h
    sub spaces, 1
    cmp spaces, 0
    jne aggain
    mov cx, d
    call space
    loop andagain_2
    
    pop cx
    call nxtln
    loop andagain_1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov dx, offset nextln
    mov ah, 09h
    int 21h
    mov dx, offset result
    mov ah, 09h
    int 21h
    mov ax, c
    call Output
    mov dl, ')'
    mov ah, 02h
    int 21h
    mov dl, ':'
    mov ah, 02h
    int 21h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov si, 0
    mov cx, a
againn_1:
    push cx
    mov cx, b
againn_2:
    mov bx, mas[si]
    cmp bx, c
    jae all_okay
    mov bx, 0
    mov mas[si], bx
all_okay:
    inc si
    inc si
    loop againn_2
    
    pop cx
    call nxtln
    loop againn_1
    
    mov cx, a
    mov si, 0
    call nxtln
andagainn_1:
    push cx
    mov cx, b
andagainn_2:
    mov ax, mas[si]
    inc si
    inc si
    mov d, cx
    call Output
    mov ax, 7
    sub ax, spaces
    mov spaces, ax
agggain:
    mov ah, 02h
    mov dl, 32
    int 21h
    sub spaces, 1
    cmp spaces, 0
    jne agggain
    mov cx, d
    call space
    loop andagainn_2
    
    pop cx
    call nxtln
    loop andagainn_1
    
    mov ax, 4c00h
    int 21h
end main
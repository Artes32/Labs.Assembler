.model small
.stack
.data
    a dw ?
    b dw ?
    c dw ?
    d dw ?
    negt db ?
    negtv db ?
    ch3276 db ?
    br db ?
    final db ?
    incorrect db 10, 13, "WAS ENTERED INCORRECT CHARACTER!$"
    bignumber db 10, 13, "NUMBER IS TOO BIG!$"
    impossible db 10, 13, "DIVIDE BY ZERO IS IMPOSSIBLE$"
    nextln db 10, 13, "$"
    backspace db 32, 8, "$"
.code
 
Input proc
mov bx, 0
mov negt, 0
mov ch3276, 0
begin:
    mov ah, 01h
    int 21h
    
    cmp al, '-'
    jne endnegtv
    cmp negt, 0
    jne endnegtv
    cmp bx, 0
    ja endnegtv
    mov negt, 1
    jmp begin
endnegtv:
    cmp al, 13
    je checkneg
    
    cmp al, 27
    je escape
    
    cmp al, 8
    je bkspace
    
    cmp al, '0'
    jb error
    cmp al, '9'
    ja error
    
    cmp ch3276, 1
    jne allisok
    cmp al, '8'
    jb allisok
    cmp negt, 1
    jne bign
    cmp al, '9'
    jb allisok
bign:
    mov dx, offset bignumber
    mov ah, 09h
    int 21h
    mov bx, 0
    mov negt, 0
    mov ch3276, 0
    jmp nextline 
allisok:
    sub al, 30h
    xor ah, ah
    xchg ax, bx
    mov dx, 10
    mul dx
    add bx, ax
    
    cmp bx, 3276
    jb begin
    
    cmp bx, 3276
    ja numberok
    
    mov ch3276, 1
    jmp begin
checkneg:
    cmp negt, 1
    jne exit
    neg bx 
exit:
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
error:
    mov dx, offset incorrect
    mov ah, 09h
    int 21h
    mov bx, 0
    mov negt, 0
    jmp nextline
numberok:
    mov dx, offset nextln
    mov ah, 09h
    int 21h
    jmp checkneg
nextline:
    mov dx, offset nextln
    mov ah, 09h
    int 21h
    jmp begin
Input endp

Output proc
    mov br, 0
    test ax, ax
    jns l1
    mov cx, ax
    cmp final, 1
    je finaln
    mov br, 1
    mov dl, '('
    mov ah, 02h
    int 21h
finaln:
    mov dl, '-'
    mov ah, 02h
    int 21h
    mov ax, cx
    neg ax
l1:
    xor cx, cx
    mov bx, 10
l2:
    xor dx,dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz l2
    mov ah, 02h
l3:
    pop dx
    add dl, '0'
    int 21h
    loop l3
    cmp br, 1
    jne notbr
    mov dl, ')'
    mov ah, 02h
    int 21h
notbr:
    ret
Output endp

Negcheck proc
    test ax, ax
    jns notneg
    neg ax
    cmp negtv, 1
    je killneg
    mov negtv, 1
    jmp notneg
killneg:
    mov negtv, 0
notneg:
    ret
Negcheck endp

main:
    mov ax, @data
    mov ds, ax
    
    mov final, 0
    
    call Input
    mov a, bx
    call Input
    mov b, bx
    call Input
    mov c, bx
    call Input
    mov d, bx
    
    mov dl, '('
    mov ah, 02h
    int 21h
    mov ax, a
    call Output
    mov dl, '/'
    mov ah, 02h
    int 21h
    mov ax, b
    call Output
    mov dl, ')'
    mov ah, 02h
    int 21h
    mov dl, '/'
    mov ah, 02h
    int 21h
    mov dl, '('
    mov ah, 02h
    int 21h
    mov ax, c
    call Output
    mov dl, '-'
    mov ah, 02h
    int 21h
    mov ax, d
    call Output
    mov dl, ')'
    mov ah, 02h
    int 21h
    mov dl, ' '
    mov ah, 02h
    int 21h
    mov dl, '+'
    mov ah, 02h
    int 21h
    mov dl, ' '
    mov ah, 02h
    int 21h
    mov dl, '('
    mov ah, 02h
    int 21h
    mov ax, b
    call Output
    mov dl, '^'
    mov ah, 02h
    int 21h
    mov dl, '2'
    mov ah, 02h
    int 21h
    mov dl, '-'
    mov ah, 02h
    int 21h
    mov ax, c
    call Output
    mov dl, '^'
    mov ah, 02h
    int 21h
    mov dl, '2'
    mov ah, 02h
    int 21h
    mov dl, ')'
    mov ah, 02h
    int 21h
    mov dl, '/'
    mov ah, 02h
    int 21h
    mov ax, d
    call Output
    mov dl, ' '
    mov ah, 02h
    int 21h
    mov dl, '='
    mov ah, 02h
    int 21h
    mov dl, ' '
    mov ah, 02h
    int 21h
    
    cmp b, 0
    je dbzero
    cmp d, 0
    je dbzero
    
    mov negtv, 0
    mov ax, a
    call Negcheck
    mov a, ax
    
    mov ax, b
    call Negcheck
    mov b, ax
    
    xor dx, dx
    mov ax, a
    div b
    mov a, ax
    mov bx, c
    sub bx, d
    
    cmp bx, 0
    je dbzero
    
    mov ax, bx
    call Negcheck
    mov bx, ax
    
    xor dx, dx
    mov ax, a
    div bx
    
    jmp justjmp
dbzero:
    mov dx, offset impossible
    mov ah, 09h
    int 21h
    jmp jumpagain
justjmp:
    cmp negtv, 0
    je isnotneg
    neg ax
isnotneg:
    mov a, ax
    mov negtv, 0
    mov ax, b
    mul b
    mov b, ax
    mov ax, c
    mul c
    sub b, ax 
    
    cmp b, 0
    je dbzero 

    mov ax, b
    call Negcheck
    mov b, ax
    
    mov ax, d
    call Negcheck
    mov d, ax
    
    xor dx, dx
    mov ax, b
    div d
    
    cmp negtv, 0
    je isnotnegg
    neg ax
isnotnegg:
    add ax, a
    mov final, 1
    call Output
    
    mov ax, 4c00h
    int 21h
    int 20h
jumpagain:
end main
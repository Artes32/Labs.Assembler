.model small
.stack
.data
    a dw ?
    b dw ?
    vows dw ?
    twovows dw ?
    emptystring db 255 dup(?), '$'
    newstring db 255 dup(?), '$'
    vowelsstring db "AEIOUaeiou", '$'
.code
    assume ds:@data, es:@data
input proc
    cld
    mov vows, 0
    mov twovows, 0
    mov cx, 255
    mov bx, 0
cycle:
    mov ah, 01h
    int 21h
    cmp al, 13
    je checknull
    cmp al, 32
    je check 
    stos emptystring
    inc bx
    push di
    push cx
    mov cx, 10
    lea di, vowelsstring
repne scas vowelsstring
    je found
    mov vows, 0
    pop cx
    pop di
    loop cycle
found:
    add vows, 1
    cmp vows, 2
    jne nottwo
    mov twovows, 1
nottwo:
    pop cx
    pop di
    loop cycle
exit:
    ret
checknull:
    cmp bx, 0
    je exit
check:
    cmp twovows, 1
    jne addword
    add a, bx
    mov bx, 0
    mov twovows, 0
    mov vows, 0
    cmp al, 13
    je exit
    jmp cycle
addword:
    mov dx, cx
    mov cx, bx
    lea si, emptystring
    lea di, newstring
    add si, a
    add di, b
rep movs newstring, emptystring
    inc bx
    add a, bx
    add b, bx
    lea di, emptystring
    add di, a
    mov bx, 0
    mov cx, dx
    mov twovows, 0
    mov vows, 0
    cmp al, 13
    je exit
    jmp cycle
input endp

main:
    mov ax, @data
    mov ds, ax
    mov es, ax

    mov a, 0
    mov b, 0
    lea di, emptystring
    call input
    
    mov dx, offset newstring
    mov ah, 09h
    int 21h
    
    mov ax, 4c00h
    int 21h
end main
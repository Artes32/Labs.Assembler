.model small
.stack
.data

    a dw 1
    b dw 25
    c dw 5
    d dw 50

.code
main:
    mov ax, @data
    mov ds, ax

    mov ax, a
    and ax, b
    mov bx, ax
    mov ax, c
    mul c
    mul c
    mul c
    cmp ax, bx
    jne l1

    div d
    div b
    add ax, a
    jmp l3

l1: mov ax, a
    mul a
    mul a
    mov bx, ax
    mov ax, b
    mul b
    mul b
    add bx, ax
    mov cx, c
    add cx, b
    cmp cx, bx
    jne l2

    mov ax, a
    or ax, cx
    jmp l3

l2: mov ax, 1
    cmp a, 25
    jb r1
    cmp a, 50
    ja r1
    mul a
r1: cmp b, 25
    jb r2
    cmp b, 50
    ja r2
    mul b
r2: cmp c, 25
    jb r3
    cmp c, 50
    ja r3
    mul c
r3: cmp d, 25
    jb l3
    cmp d, 50
    ja l3
    mul d

l3: mov ax, 4c00h
    int 21h
end main
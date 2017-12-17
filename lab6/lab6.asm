page 255
.model tiny
.data
    string db 100,100 dup ('$')
    .code
bs=8
tab=9
cr=0Dh
lf=0ah
spc=20h
    org 100h
    
vOldInt label word
Begin proc near
    jmp Init
Begin endp
    org 104h
        
IntRout proc far
    cmp ah, 0Ah
    je  labeel
    jmp dword ptr cs:[vOldInt]
labeel:
    push es
    push di
    push bx
    push cx
    mov bx, dx
    push si
    push dx
    mov si, 1
    xor ch, ch
    mov cl, [bx]
    inc bx
    jcxz exit
    mov ax, 0d00h
    mov [bx], ax
    dec cx
    jz  exit
    cld
    push cs
    pop es
@@loop:
    call NoEchoInp
    cmp al, cr
    je exiit
    cmp al, bs
    je checkbs
    call Save2Buff
    jb @@loop
    call Output
    call IsVowel
    jnz @@loop
    call Save2Buff
    jb @@loop
    call Output
    jmp @@loop
checkbs:
    cmp si, 1
    je @@loop
    mov [bx+si], byte ptr cr
    dec si
    dec byte ptr [bx]
    call Output
    mov al, spc
    call Output
    mov al, bs
    call Output
    jmp @@loop
exiit:
    mov [bx+si], al
    call Output
exit:
    pop dx
    pop si
    pop cx
    pop bx
    pop di
    pop es
    iret
IntRout endp

Save2Buff proc near
    cmp si, cx
    jb label1
    stc
    ret
label1:
    inc byte ptr [bx]
    mov [bx+si], al
    mov byte ptr [bx+si+1], cr
    inc si
    clc
    ret
Save2Buff endp
        
Output proc near
    push ax
    push dx
    mov dl, al
    mov ah, 2
    int 21h
    pop dx
    pop ax
    ret
Output endp

NoEchoInp proc near
    mov ah, 8
    int 21h
    ret
NoEchoInp endp

IsVowel proc near
    push cx
    mov di, offset Vowels
    mov cx, SIZEOF_Vowels
    repne scasb
    pop cx
    ret
IsVowel endp
Vowels db 'AEIOUaeiou????????????????????'
SIZEOF_Vowels=$-Vowels

Init proc near
    mov ax, 3521h
    int 21h
    mov [vOldInt], bx
    mov [vOldInt+2], es
 
    mov dx, offset IntRout
    mov ax, 2521h
    int 21h
        
    lea dx, string
    mov ah, 0ah
    int 21h
 
    mov dx, offset Init
    int 27h
Init endp

    end Begin
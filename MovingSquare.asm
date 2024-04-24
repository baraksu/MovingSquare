; version 101
.MODEL small 
.STACK 100h 
.DATA 3
msg1 db 13,10,'Enter edge length (1-199): $' 
msg2 db 13,10,'Enter game mode (1/2) $'
msg3 db 13,10,'You win!!! $'
msg4 db 13,10,'You lose $' 
length dw 0; how big the user wants the square to be
mode dw ?;which game mode the user chose
clock equ 40h:6ch ;random

rndwidthnum dw ?
rndhightnum dw ?

.CODE


start:
    mov AX, @data 
    mov DS, AX 
     
    mov ah, 0   ; set display mode function.
	mov al, 13h ; mode 13h = 320x200 pixels, 256 colors.
	int 10h     ; set it!
input:	 
    xor ax,ax
    lea DX,msg1 ;Show msg1 
    mov AH,09h 
    int 21h 
    mov AH, 01h ;Read a character 
    int 21h   
    sub al,'0' 
    mov bx,100
    mul bx   
    mov ah,0
    add length,ax   
    mov AH, 01h ;Read a character 
    int 21h   
    sub al,'0' 
    mov bx,10
    mul bx  
    mov ah,0  
    add length,ax 
    mov AH, 01h ;Read a character 
    int 21h   
    sub al,'0'  
    mov ah,0 
    add length,ax
    cmp length,200
    ja  input
    
    
    lea DX,msg2 
    mov AH,09h 
    int 21h 
    mov AH, 01h ;Read a character 
    int 21h 
    mov mode,AX 
    cmp mode,2
    je mode2 
    
    
    
    
mode1: 
mov ah, 0   ; set display mode function.
mov al, 13h ; mode 13h = 320x200 pixels, 256 colors.
int 10h     ; set it!  
call rndhight
call rndwidth 
mov bx,0fh
push bx
mov ax,rndhightnum
mov cx,rndwidthnum
push ax
push cx 
call square     
mov bx,0h
push bx
mov ax,rndhightnum
mov cx,rndwidthnum
push ax
push cx 
call square
mouse: 
    xor ax,ax
    int 33h
    mov ax,1h
    int 33h
    click: 
    mov ax,3h 
    int 33h
    cmp bx,1
    jne click 
    cmp dx,rndhightnum
    ja lose
    mov ax,rndhightnum
    sub ax,length
    cmp dx,ax
    jb lose
    mov ax,cx
    mov bl,2h
    div bl 
    mov ah,0
    cmp ax,rndwidthnum
    ja lose
    mov dx,rndhightnum
    sub dx,length
    cmp ax,dx
    jb lose
    jmp win
    
    
    
    
    
 
 
 
 
 
 
mode2:  






win:
    lea DX,msg3 ;Show msg3 
    mov AH,09h 
    int 21h 
    jmp exit


lose:
     lea DX,msg4 ;Show msg4 
    mov AH,09h 
    int 21h

 
exit: 
 mov AH, 4Ch ;End program 
 int 21h  

 

rndwidth proc
   rnd:
    xor bx,bx
    mov ah,2ch ; get system timeout.
    int 21h
   
    and dx,111111111b
    mov bx,320
    cmp dx,bx
    ja rnd    
    mov rndwidthnum,dx   
    ret 2
rndwidth endp


rndhight proc
   rnd2:
    xor bx,bx 
    xor dx,dx
    mov ah,2ch ; get system timeout.
    int 21h   
    and dx,111111111b
    mov bx,200
    
    cmp dx,bx
    ja rnd2    
    mov rndhightnum,dx   
    ret 2
rndhight endp

 square proc        
    push bp
    mov bp,sp
    mov cx,[bp+4] ;rndwidthnum  
	add cx,length	
	mov dx,[bp+6] ;rndhightnum
	add dx,length
	
    draw: 
    mov cx,[bp+4]
	add cx,length	
    Drawrow: 	
	mov al, [bp+8]  ; white  (color)
	mov ah, 0ch ; put pixel
	int 10h	
	dec cx 
	cmp cx,[bp+4]
	je drawcolums
	jmp Drawrow
	
    Drawcolums:      
      
    dec dx
    cmp dx,[bp+6]
    ja draw
    pop bp
    ret  
     
    square endp



 
END 
; version 102

.MODEL small 
.STACK 100h 
.DATA 3
msg1 db 13,10,'Enter edge length (1-199): $' 
msg2 db 13,10,'Enter game mode (1/2) $'
msg3 db 13,10,'You win!!! $'
msg4 db 13,10,'You lose $' 
length dw 0; how big the user wants the square to be
mode db ?;which game mode the user chose
clock equ 40h:6ch ;random
rndwidthnum dw ?;stores the random num from the proc
rndhightnum dw ?

.CODE


start:
    mov AX, @data 
    mov DS, AX 
     
    mov ah, 0   ; set display mode function.
	mov al, 13h ; mode 13h = 320x200 pixels, 256 colors.
	int 10h     ; set it!
input:	 
    xor ax,ax
    lea DX,msg1 ;Show msg1 
    mov AH,09h 
    int 21h 
    call input3dignum
    cmp length,200
    ja  input
    
    
    lea DX,msg2 
    mov AH,09h 
    int 21h 
    mov AH, 01h ;Read a character 
    int 21h 
    mov mode,AL
    sub mode,'0' 
    cmp mode,2
    je mode2 
    
    
    
    
mode1: 
mov ah, 0   ; set display mode function.
mov al, 13h ; mode 13h = 320x200 pixels, 256 colors.
int 10h     ; set it!  
call rndhight
call rndwidth 
mov bx,0fh
push bx
mov ax,rndhightnum
mov cx,rndwidthnum
push ax
push cx 
call square     
mov bx,0h
push bx
mov ax,rndhightnum
mov cx,rndwidthnum
push ax
push cx 
call square
mouse:  
    mov ax,length
    add rndhightnum,ax 
    add rndwidthnum,ax
    xor ax,ax
    int 33h
    mov ax,1h
    int 33h
    click: 
    mov ax,3h 
    int 33h
    cmp bx,1
    jne click 
    cmp dx,rndhightnum
    ja lose
    mov ax,rndhightnum
    sub ax,length
    cmp dx,ax
    jb lose
    mov ax,cx
    mov bl,2h
    div bl 
    mov ah,0
    cmp ax,rndwidthnum
    ja lose
    mov dx,rndhightnum
    sub dx,length
    cmp ax,dx
    jb lose
    jmp win
    
    
    
 
mode2:

 
    mov ah, 0   ; set display mode function.
    mov al, 13h ; mode 13h = 320x200 pixels, 256 colors.
    int 10h     ; set it!
    white:          
    call rndhight
    call rndwidth 
    mov bx,0fh
    push bx
    mov ax,rndhightnum
    mov cx,rndwidthnum
    push ax
    push cx 
    call square 
    xor ax,ax
    int 33h
    mov ax,1h
    lop:    
    mov ax,3h 
    int 33h
    cmp bx,1
    jne lop
    mov ax,length
    add rndhightnum,ax 
    add rndwidthnum,ax
    cmp dx,rndhightnum
    ja black
    mov ax,rndhightnum
    sub ax,length
    cmp dx,ax
    jb black
    mov ax,cx
    mov bl,2h
    div bl 
    mov ah,0
    cmp ax,rndwidthnum
    ja black
    mov dx,rndhightnum
    sub dx,length
    cmp ax,dx
    jb black
    jmp win
    
    
    black:
    mov ax,length
    sub rndhightnum,ax 
    sub rndwidthnum,ax     
    mov bx,0h
    push bx
    mov ax,rndhightnum
    mov cx,rndwidthnum
    push ax
    push cx 
    call square
    jmp white 
    





win:
    mov ah, 0   ; set display mode function.
    mov al, 13h ; mode 13h = 320x200 pixels, 256 colors.
    int 10h     ; set it!
    lea DX,msg3 ;Show msg3 
    mov AH,09h 
    int 21h 
    jmp exit


lose:
     lea DX,msg4 ;Show msg4 
    mov AH,09h 
    int 21h

 
exit: 
 mov AH, 4Ch ;End program 
 int 21h  

 

rndwidth proc
   rnd:
    xor bx,bx
    mov ah,2ch ; get system timeout.
    int 21h
   
    and dx,111111111b
    mov bx,320
    add dx,length
    cmp dx,bx
    ja rnd    
    mov rndwidthnum,dx   
    ret 2
rndwidth endp


rndhight proc
   rnd2:
    xor bx,bx 
    xor dx,dx
    mov ah,2ch ; get system timeout.
    int 21h   
    and dx,111111111b
    mov bx,200
    add dx,length    
    cmp dx,bx
    ja rnd2    
    mov rndhightnum,dx   
    ret 2
rndhight endp

 square proc        
    push bp
    mov bp,sp
    mov cx,[bp+4] ;rndwidthnum  
	add cx,length	
	mov dx,[bp+6] ;rndhightnum
	add dx,length
	
    draw: 
    mov cx,[bp+4]
	add cx,length	
    Drawrow: 	
	mov al, [bp+8]  ; white  (color)
	mov ah, 0ch ; put pixel
	int 10h	
	dec cx 
	cmp cx,[bp+4]
	je drawcolums
	jmp Drawrow
	
    Drawcolums:      
      
    dec dx
    cmp dx,[bp+6]
    ja draw
    pop bp
    ret  
     
    square endp
    
input3dignum proc
    mov AH, 01h ;Read a character 
    int 21h   
    sub al,'0' 
    mov bx,100
    mul bx   
    mov ah,0
    add length,ax   
    mov AH, 01h ;Read a character 
    int 21h   
    sub al,'0' 
    mov bx,10
    mul bx  
    mov ah,0  
    add length,ax 
    mov AH, 01h ;Read a character 
    int 21h   
    sub al,'0'  
    mov ah,0 
    add length,ax 
    ret   
input3dignum endp

 
END 






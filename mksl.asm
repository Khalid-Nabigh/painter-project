bits 16
org 0x7C00

	cli
	
	

	 mov ah , 0x02
 mov al ,6
 mov dl , 0x80
 mov ch ,0
 mov dh , 0
 mov cl , 2
 mov bx , StartingTheCode
 int 0x13
 jmp StartingTheCode
 
  
  

	
	
times (510 - ($ - $$)) db 0
db 0x55, 0xAA
StartingTheCode:
        
        mov al,13h 
        int 10h 	
          
biglop:
    call writecheck

    mov al,0xf4;0xf4 means
    call writetomouse ;;;;;;;;;; enable
    xor eax,eax
    xor ecx,ecx
    
    
    
    nokey:
     L:
        in al,0x64;XXXXXXXA
        and al,0x01
        jz L
    
    in al, 0x64
    and al, 0x20 ;;;;;;;;;;check if it's a mouse not a keyboard
    jz shape
    
    call readfrommouse;;;; status

    
    and al,03h
    cmp al,0
    je nothing
    cmp al,01h 
    je _draw
    jmp delete
    
delete:
    mov ah,0Ch 	; function 0Ch
    mov al,0 	; color 4 - black
    mov cx,[x] 	; x position 
    mov dx,[y] 	; y position 
    int 10h 	;    call BIOS service
    
    
    
   
    _draw:
    call readfrommouse ;;;;;; delta x
    movsx dx,al
    mov [deltax],dx
    call readfrommouse ;;;;;; delta y
    movsx ax,al
    mov [deltay],ax
    
    mov ax,[deltax]
    add ax,[x]
    mov [x],ax
    
    mov ax,[deltay]
    
    sub [y],ax
    
   
            
    
    mov al,15
    mov ah,0ch
    mov cx,[x]
    mov dx,[y]
    int 10h
    
    
    call readfrommouse ;;;; scroll
    jmp nokey
    
nothing:
   
    call readfrommouse ;;;;;; delta x
    movsx dx,al
    mov [deltax],dx
    call readfrommouse ;;;;;; delta y
    movsx ax,al
    mov [deltay],ax
    
    mov ax,[deltax]
    add [x],ax
    
    mov ax,[deltay]
    
    sub [y],ax
    mov al,0h
    mov ah,0ch
    mov cx,[x]
    mov dx,[y]
    int 10h
    
    call readfrommouse ;;;; scroll
    jmp nokey

    
writecheck:
    mov ecx,1000
    one:    
    in al,0x64
    and al,02h ;;;;;;;;is there a something that can write to
    jz nxt
    loop one
    
nxt:
    ret
readcheck:
    mov ecx,1000
    two:
    in al,0x64
    and al,01h ;;;;;;;;is theresomething can read from
    jnz nxxt
    loop two
    
nxxt:
    ret
;need some explains why do we use the writecheck three times

writetomouse:
    mov dh,al
    call writecheck ;;;;can you w
    mov al,0xd4;0xd4 means
    out 0x64,al
    call writecheck
    mov al,dh
    out 0x60,al
    call readcheck
    in al,0x60
    ret
readfrommouse:
call readcheck
in al,0x60
ret

shape:
   in al,0x60
   mov cl,al
   cmp al,0x02;1
   je line
   mov al,cl
   cmp al,0x03
   je square
   cmp cl,0x04
   je triang
        
line:
mov esi,0
;mov ecx,1000

L4:
cmp esi,2
je _drawline

call readfrommouse
mov dh,al
cmp al,0x01
jne L4

_drawing:

call readfrommouse
movsx dx,al
mov [deltax],dx
add dx,[x]
mov [tempx+esi*2],dx

call readfrommouse
movsx dx,al
sub dx,[y]
neg dx
mov [tempy+esi*2],dx
inc esi 
call readfrommouse;scroll althought i dont give a shit about

jmp L4

_drawline:
call lineequ
mov cx,[tempx]
AA: cmp cx,[tempx+2]
jg end
inc cx
mov ax,[slope]
mul cx
add ax,[const]
mov dx,ax
mov ah,0ch
mov al,15
int 10h
jmp AA

end:
jmp nokey
; i need the new two positions of the x and the y

triang:
; i need the three new position of the x and y
squre:

lineequ:
mov cx,[tempx]
cmp cx,[tempx+2]
jg swap

A: 
mov ax,[tempy+2]
sub ax,[tempy]
mov dx,[tempx+2]
sub dx,[tempx]
div dx
mov bx,ax
mul word[tempx]
neg ax
add ax,[tempy]
mov di,ax
mov [const],di
mov [slope],bx
ret
swap:
mov ecx,[tempx]
mov edx,[tempx+2]
mov [tempx],edx
mov [tempx+2],ecx
mov ecx,[tempy]
mov edx,[tempy+2]
mov [tempy],edx
mov [tempy+2],ecx
jmp A





square:
;you need only two reads from the mouse to calclate the lenght of the square branch
;so you will use the same read code used above for the line method
;note here we modify the position of the x and y to be the first point
L5:
cmp esi,2
je _drawline

call readfrommouse
mov dh,al
cmp al,0x01
jne L5

_drawing1:

call readfrommouse
movsx dx,al
mov [deltax],dx
add dx,[x]

mov [tempx+esi*2],dx

call readfrommouse
movsx dx,al
sub dx,[y]
neg dx
mov [tempy+esi*2],dx
inc esi 
call readfrommouse;scroll althought i dont give a shit about

jmp L5
;
mov ax,[tempx]
sub ax,[tempx+2]
cmp ax,0
jl negg
_AAA:
mov [branchlength],ax
mov ah,0ch
mov cx,[tempx]
mov dx,[tempy]
square1:
int 10h
inc cx
cmp cx,[branchlength]
jle square1
mov cx,[tempx]
inc dx
cmp dx,[branchlength]
jle square1
jmp nokey


negg:
neg ax
jmp _AAA


branchlength:dw 0
const:dw 0
mainl:dw 0
slope:dw 0
tempx:dw 0,0
tempy:dw 0,0
deltax: dw 0
deltay: dw 0
x: dw 0
y: dw 0

times (0x400000 - 512) db 0

db 	0x63, 0x6F, 0x6E, 0x65, 0x63, 0x74, 0x69, 0x78, 0x00, 0x00, 0x00, 0x02
db	0x00, 0x01, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
db	0x20, 0x72, 0x5D, 0x33, 0x76, 0x62, 0x6F, 0x78, 0x00, 0x05, 0x00, 0x00
db	0x57, 0x69, 0x32, 0x6B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x78, 0x04, 0x11
db	0x00, 0x00, 0x00, 0x02, 0xFF, 0xFF, 0xE6, 0xB9, 0x49, 0x44, 0x4E, 0x1C
db	0x50, 0xC9, 0xBD, 0x45, 0x83, 0xC5, 0xCE, 0xC1, 0xB7, 0x2A, 0xE0, 0xF2
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
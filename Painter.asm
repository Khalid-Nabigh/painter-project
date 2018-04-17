bits 16
org 0x7C00

cli
	
	

	 mov ah , 0x02
 mov al ,16
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

section .data
ScanCodeTable: db "//1234567890-=//QWERTYUIOP[]//ASDFGHJKL;//'/ZXCVBNM,.//// /"

x_mouse: dw 0      
y_mouse: dw 0
xchange: dw 0
ychange: dw 0
z: dw 0
k: dw 0
LEFTbutton: db 0
stat: db 0
color: db 0
operand1: dd 0
operand2: dd 0
operand3: dd 0
operand4: dd 0
operand5: db 0 ;color
operand6: dw 0
operand7: dw 0
operand8: db 0
color2: db 15
color3: db 0
color4: db 0
keyboard_status: dw 0
;/////////////line variables
stat2: db 0
x: dw 0
y: dw 0
r: dw 0
p: dw 0
xc: dw 150
yc: dw 120
xr: dw 180
yr: dw 90
ddx: dd 0
ddy: dd 0
xx: dd 0
yy: dd 0
addx: dd 0
addy: dd 0

step: dd 0
xinc: dd 0
yinc: dd 0
xborder: dw 319
colork: db 0
;///////////////triangle var
x0: dd 0
y0: dd 0
x1: dd 44
y1: dd 100
tempx0:dd 0
tempy0:dd 0
tempx1:dd 0
tempy1:dd 0
tempx2:dd 0
tempy2:dd 0
tempy3:dd 0
tempx3:dd 0
branchlength:dd 0
xmouse: dw 0      
ymouse: dw 0
;////////////bakhakh var
x01: dd 0
y01: dd 0
random1: dd 0
xrandom: dd 0
yrandom: dd 0


	cli
	xor ax,ax
	mov ds,ax
	mov es,ax
	mov edi, 0xB8000;
   mov bx,ScanCodeTable	
	;WRITE YOUR CODE HERE
      mov ax,13h
      int 10h

      mov      al, 0xf6;the default of the mouse and the graphics
      call     MouseWrite
;the above is just reset the mouse setting
 ;enable mouse
      mov         al, 0xf4 
      call        MouseWrite
	   ; to intialize the mouse
	 ;sends package streams to the mouse and the registers
 





    xor edi,edi
    xor esi,esi
    mov [xmouse],edi
    mov [ymouse],esi
    
    call logo
    ;//////////WHITE////////
    mov dword[operand1],0
    mov dword[operand2],0
    mov dword[operand3],320
    mov dword[operand4],200
    mov byte[operand5],15
    call ColorTheScreen 
    
    ;/////////////GRAY
    mov dword[operand1],260
    mov dword[operand2],0
    mov dword[operand3],320
    mov dword[operand4],200
    mov byte[operand5],7
    call ColorTheScreen 
    ;/////////////RED
    mov dword[operand1],267
    mov dword[operand2],20
    mov dword[operand3],287
    mov dword[operand4],40
    mov byte[operand5],4
    call ColorTheScreen
    
   
    ;///////////////blue
    mov dword[operand1],292
    mov dword[operand2],20
    mov dword[operand3],312
    mov dword[operand4],40
    mov byte[operand5],1
    call ColorTheScreen
    
    
    ;///////////////green
    mov dword[operand1],267
    mov dword[operand2],50
    mov dword[operand3],287
    mov dword[operand4],70
    mov byte[operand5],2
    call ColorTheScreen
   
    
    ;///////////////yellow
    mov dword[operand1],292
    mov dword[operand2],50
    mov dword[operand3],312
    mov dword[operand4],70
    mov byte[operand5],14
    call ColorTheScreen
  
    
    ;///////////////cyan
    mov dword[operand1],267
    mov dword[operand2],80
    mov dword[operand3],287
    mov dword[operand4],100
    mov byte[operand5],3
    call ColorTheScreen
    
    
    ;///////////////magenta
    mov dword[operand1],292
    mov dword[operand2],80
    mov dword[operand3],312
    mov dword[operand4],100
   mov byte[operand5],5
   call ColorTheScreen
    
  
   ;///////////////brown
    mov dword[operand1],267
    mov dword[operand2],110
    mov dword[operand3],287
    mov dword[operand4],130
    mov byte[operand5],6
    call ColorTheScreen
    
    ;///////////////black
    mov dword[operand1],292
    mov dword[operand2],110
    mov dword[operand3],312
    mov dword[operand4],130
    mov byte[operand5],0
    call ColorTheScreen
    
   
waitformouse:
;cmp byte[stat2],0
;jne continue103
;mov word[keyboard_status],0
;continue103:

;///////////////
xor ah,ah
xor al,al
mov ah,01h
int 16h
jz continue101
jmp keyboard_clicked
continue101:
;
in al,0x64
and al,0x20
jz waitformouse

maincode:
cmp word[xmouse],259
jg change_color2

cmp word[xmouse],260
jl dont_change_color2

continue2:
cmp byte[stat],1
je next
cmp byte[stat],2
je erase

mov al,[colork]
mov cx,[xmouse]
mov dx,[ymouse]
mov ah,0ch
int 10h
jmp next

erase:
mov al,[color2]
mov cx,[xmouse]
mov dx,[ymouse]
mov ah,0ch
int 10h

next:

;xor al,al
;mov ah,01h
;int 16h
;jz continue101
;jmp keyboard_clicked
;continue101:



call MouseRead ;status byte
and al,3
mov byte[stat],al

call MouseRead ;xbyte
xor dx,dx
movsx dx,al
add [xmouse], dx

;x_borders 
cmp word[xmouse],0  
jg case0
mov word[xmouse],0
	  
case0:
xor dx,dx
mov dx,word[xborder]
cmp word[xmouse],dx
jl case1
mov word[xmouse],dx
case1:

call MouseRead ;ybyte
xor dx,dx
movsx dx,al
sub [ymouse], dx

;y_borders
cmp word [ymouse],199
jl case2
mov word[ymouse],199
       
case2:
cmp word [ymouse],0
jg case3
mov word [ymouse],0
case3:

call MouseRead ;zaxis byte (not used)

mov cx,[xmouse]
mov dx,[ymouse]
mov ah,0dh
int 10h
mov [colork],al

cmp byte[stat],1
je mouse_clicked
mov al,[color4]
jmp print1
mouse_clicked:
;/////////////circle
cmp word[keyboard_status],1
jne continue102
call draw_circle
cmp byte[stat2],0
jne continue102
mov word[keyboard_status],1
mov word[xborder],259

continue102:

;/////////////line
cmp word[keyboard_status],2
jne continue103
call draw_line
cmp byte[stat2],0
jne continue103
mov word[keyboard_status],2
mov word[xborder],259

continue103:

;/////////////trinagle
cmp word[keyboard_status],3
jne continue104
call draw_triangle
cmp byte[stat2],0
jne continue104
mov word[keyboard_status],3
mov word[xborder],259

continue104:

;/////////////trinagle
cmp word[keyboard_status],4
jne continue105
call draw_square
cmp byte[stat2],0
jne continue105
mov word[keyboard_status],4
mov word[xborder],259

continue105:

;/////////////quad
cmp word[keyboard_status],5
jne continue106
call draw_quad
cmp byte[stat2],0
jne continue106
mov word[keyboard_status],5
mov word[xborder],259

continue106:

;/////////////bakhakh
cmp word[keyboard_status],6
jne continue107
call draw_bakhakh
cmp byte[stat2],0
jne continue107
mov word[keyboard_status],6
mov word[xborder],259

continue107:

mov al,[color4]
cmp dword[xmouse],260
jg change_color
jl dont_change_color
continue:
mov al,[color]

print1:
mov cx,[xmouse]
mov dx,[ymouse]
mov ah,0ch
int 10h
jmp waitformouse


jmp next5
WriteMouseWait:
mov ecx,1000
check1:  
in         al, 0x64
and        al, 0x02
jz         fin1  
cmp ecx,0
dec ecx  
jne check1
fin1:
ret
	  
ReadMouseWait:
mov ecx,1000
check2:  
in  al, 0x64
and al, 0x01
jnz fin2    
cmp ecx,0
dec ecx
jne check2 
fin2:
ret
	
MouseRead:
call ReadMouseWait
in al, 0x60
ret
	
MouseWrite:
mov ah, al
call WriteMouseWait
mov al, 0xd4
out 0x64, al
call WriteMouseWait
mov al, ah
out 0x60, al
call ReadMouseWait
in al,0x60
ret

change_color:
 ;mov byte[color4],15
 cmp word[xmouse],292
 jg right_colors_2
 jl left_colors_2
 
 continue3_2:
 xor al,al
 mov al,byte[color3]
 mov byte[color],al
 mov byte[color2],7
 
 continue4_2:
 jmp continue
 
 
 dont_change_color:
 xor al,al
 
 mov byte[color],7
 mov byte[color2],15
 jmp continue
 
 change_color2:
 
 cmp word[xmouse],291
 jg right_colors
 jl left_colors
 
 continue3:
 mov byte[color],7
 mov byte[color2],7
 
 continue4:
 jmp continue2
 
 
 dont_change_color2:
 xor al,al
 ;mov al,byte[color3]
 mov byte[color],7
 mov byte[color2],15
 
 
 jmp continue2
 
 right_colors:
 cmp word[xmouse],311
 jg continue3
 
 cmp word[xmouse],292
 jl continue6
 mov word[operand6],20
 mov word[operand7],40
 mov byte[operand8],1
 call to_compare_color
 
 mov word[operand6],50
 mov word[operand7],70
 mov byte[operand8],14
 call to_compare_color
 
 mov word[operand6],80
 mov word[operand7],100
 mov byte[operand8],5
 call to_compare_color
 
 mov word[operand6],110
 mov word[operand7],130
 mov byte[operand8],0
 call to_compare_color
 
 continue6:
 mov byte[color],7
 mov byte[color2],7
 
 jmp continue4
 
 
 
 
   
 
 
 
 left_colors:
 cmp word[xmouse],267
 jl continue3
 
 cmp word[xmouse],286
 jg continue5
  mov word[operand6],20
 mov word[operand7],40
 mov byte[operand8],4
 call to_compare_color
 
 mov word[operand6],50
 mov word[operand7],70
 mov byte[operand8],2
 call to_compare_color
 
 mov word[operand6],80
 mov word[operand7],100
 mov byte[operand8],3
 call to_compare_color
 
 mov word[operand6],110
 mov word[operand7],130
 mov byte[operand8],6
 call to_compare_color
 
 continue5:
 mov byte[color],7
 mov byte[color2],7
 
 jmp continue4
 
 
 ;///////////////////////////////////////////////
 
 right_colors_2:
 cmp word[xmouse],312
 jg continue10_2
 
 cmp word[xmouse],291
 jl continue6_2
 mov word[operand6],20
 mov word[operand7],40
 mov byte[operand8],1
 call to_compare_color_2
 
 mov word[operand6],50
 mov word[operand7],70
 mov byte[operand8],14
 call to_compare_color_2
 
 mov word[operand6],80
 mov word[operand7],100
 mov byte[operand8],5
 call to_compare_color_2
 
 mov word[operand6],110
 mov word[operand7],130
 mov byte[operand8],0
 call to_compare_color_2
 
 
 continue6_2:
 mov byte[color],7
 mov byte[color2],7
 
 continue10_2:
 mov byte[color],7
 mov byte[color2],7
 
 jmp continue4_2
 
 
 
 
   
 
 
 
 left_colors_2:
 cmp word[xmouse],267
 jl continue3_2
 
 cmp word[xmouse],287
 jg continue5_2
  mov word[operand6],20
 mov word[operand7],40
 mov byte[operand8],4
 call to_compare_color_2
 
 mov word[operand6],50
 mov word[operand7],70
 mov byte[operand8],2
 call to_compare_color_2
 
 mov word[operand6],80
 mov word[operand7],100
 mov byte[operand8],3
 call to_compare_color_2
 
 mov word[operand6],110
 mov word[operand7],130
 mov byte[operand8],6
 call to_compare_color_2
 
 continue5_2:
 mov byte[color],7
 mov byte[color2],7
 
 jmp continue4_2
 ;////////////////////////////////////////////////////////
 
 
 
 
 
 
 
   
  

to_compare_color:
    mov si,word[operand6]
    loopj101:
    cmp si,word[operand7]
    je endloopj101
    
    cmp si,word[ymouse]
    jne notfound
    
    mov al,[operand8]
    mov byte[color],al
    mov byte[color2],al
    jmp continue4
    
    notfound:
    inc esi
    jmp loopj101
    endloopj101:
    ret
    
    
    to_compare_color_2:
    mov si,word[operand6]
    loopj101_2:
    cmp si,word[operand7]
    je endloopj101_2
    
    cmp si,word[ymouse]
    jne notfound_2
    
    mov al,[operand8]
    mov byte[color],al
    mov byte[color2],al
    mov byte[color3],al
    mov byte[color4],al
    jmp continue4_2
    
    notfound_2:
    inc esi
    jmp loopj101_2
    endloopj101_2:
    ret

  ;;/////////////////////Color func
 ColorTheScreen:
    mov edi,[operand1]  
    loopi:
    cmp edi,[operand3]
    je endloopi
    mov [x_mouse],edi
    
    mov esi,[operand2]
    loopj:
    cmp esi,[operand4]
    je endloopj
    mov [y_mouse],esi
    mov ah , 0ch
    mov al,[operand5]
    mov cx,[x_mouse]
    mov dx,[y_mouse]
    mov bh,1
    int 10h
    inc esi
    jmp loopj
    endloopj:
    inc edi
    jmp loopi
    endloopi: 
    xor edi,edi
    xor esi,esi
    mov [x_mouse],edi
    mov [y_mouse],esi
    ret
    
    
        ;//////////////////////////////////LOGO
    logo:
    ;//////////WHITE////////
    mov dword[operand1],0
    mov dword[operand2],0
    mov dword[operand3],320
    mov dword[operand4],200
    mov byte[operand5],15
    call ColorTheScreen 
    
    call lag_long
    
    
     ;//////////light blue////////
    mov dword[operand1],110
    mov dword[operand2],50
    mov dword[operand3],210
    mov dword[operand4],80
    mov byte[operand5],9
    call ColorTheScreen 
    
    call lag_long
    ;//////////light magenta////////
    mov dword[operand1],180
    mov dword[operand2],80
    mov dword[operand3],210
    mov dword[operand4],150
    mov byte[operand5],13
    call ColorTheScreen 
    
    call lag_long
    
    
    ;//////////light cyan////////
    mov dword[operand1],110
    mov dword[operand2],120
    mov dword[operand3],180
    mov dword[operand4],150
    mov byte[operand5],11
    call ColorTheScreen 
    
    call lag_long
    
    
    
    ;//////////light red////////
    mov dword[operand1],110
    mov dword[operand2],50
    mov dword[operand3],140
    mov dword[operand4],120
    mov byte[operand5],12
    call ColorTheScreen 
    
    call lag_very_long
    
    ret


lag_short:
    mov esi,0
    loopj101_3:
    cmp esi,1000
    je endloopj101_3
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc esi
    jmp loopj101_3
    endloopj101_3:
    ret

  lag_very_long:
    mov esi,0
    loopj101_4:
    cmp esi,100000000
    je endloopj101_4
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc esi
    jmp loopj101_4
    endloopj101_4:
    ret
    
    lag_long:
    mov esi,0
    loopj101_5:
    cmp esi,20000000
    je endloopj101_5
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc esi
    jmp loopj101_5
    endloopj101_5:
    ret
  ;///////////////////////keyboard clicked
  keyboard_clicked:
    xor ah,ah
    xor al,al
    mov ah,00h
    int 16h
    
    
    
   ; xor dl,dl
;    mov dl,al
    cmp al,0x63;c
    je circle_wanted
    
    cmp al,0x20;space
    je pen_wanted
    
    cmp al,0x6c;l
    je line_wanted
    
    cmp al,0x65;e
    je erase_the_screen
    
    cmp al,0x73;s
    je square_wanted
    
    cmp al,0x74;t
    je triangle_wanted
    
    cmp al,0x71;q
    je quad_wanted
    
    cmp al,0x52;R
    je reset_wanted
    
      
    cmp al,0x62;b
    je bakhakh_wanted           
   
    jmp continue101
    
    
    circle_wanted:
    
    xor ah,ah
    xor al,al
    mov word[xborder],259
    mov word[keyboard_status],1 
    jmp continue101
    
    square_wanted:
    
    xor ah,ah
    xor al,al
    mov word[xborder],259
    mov word[keyboard_status],4 
    jmp continue101

    
    pen_wanted:
    xor ah,ah
    xor al,al
    mov word[xborder],319
    mov word[keyboard_status],0 
    jmp continue101
    
    triangle_wanted:
    xor ah,ah
    xor al,al
    mov word[xborder],259
    mov word[keyboard_status],3 
    jmp continue101
    
    line_wanted:
    xor ah,ah
    xor al,al
    mov word[xborder],259
    mov word[keyboard_status],2
    jmp continue101
    
    quad_wanted:
    xor ah,ah
    xor al,al
    mov word[xborder],259
    mov word[keyboard_status],5
    jmp continue101
    
    bakhakh_wanted:
    xor ah,ah
    xor al,al
    mov word[xborder],259
    mov word[keyboard_status],6
    jmp continue101
    
    erase_the_screen:
    xor ah,ah
    xor al,al
     ;//////////WHITE////////
    mov dword[operand1],0
    mov dword[operand2],0
    mov dword[operand3],260
    mov dword[operand4],200
    mov byte[operand5],15
    call ColorTheScreen 
    jmp continue101
    
    
    reset_wanted:
    xor ah,ah
    xor al,al
    
     ;/////////////GRAY
    mov dword[operand1],260
    mov dword[operand2],0
    mov dword[operand3],320
    mov dword[operand4],200
    mov byte[operand5],7
    call ColorTheScreen 
    ;/////////////RED
    mov dword[operand1],267
    mov dword[operand2],20
    mov dword[operand3],287
    mov dword[operand4],40
    mov byte[operand5],4
    call ColorTheScreen
    
   
    ;///////////////blue
    mov dword[operand1],292
    mov dword[operand2],20
    mov dword[operand3],312
    mov dword[operand4],40
    mov byte[operand5],1
    call ColorTheScreen
    
    
    ;///////////////green
    mov dword[operand1],267
    mov dword[operand2],50
    mov dword[operand3],287
    mov dword[operand4],70
    mov byte[operand5],2
    call ColorTheScreen
   
    
    ;///////////////yellow
    mov dword[operand1],292
    mov dword[operand2],50
    mov dword[operand3],312
    mov dword[operand4],70
    mov byte[operand5],14
    call ColorTheScreen
  
    
    ;///////////////cyan
    mov dword[operand1],267
    mov dword[operand2],80
    mov dword[operand3],287
    mov dword[operand4],100
    mov byte[operand5],3
    call ColorTheScreen
    
    
    ;///////////////magenta
    mov dword[operand1],292
    mov dword[operand2],80
    mov dword[operand3],312
    mov dword[operand4],100
   mov byte[operand5],5
   call ColorTheScreen
    
  
   ;///////////////brown
    mov dword[operand1],267
    mov dword[operand2],110
    mov dword[operand3],287
    mov dword[operand4],130
    mov byte[operand5],6
    call ColorTheScreen
    
    ;///////////////black
    mov dword[operand1],292
    mov dword[operand2],110
    mov dword[operand3],312
    mov dword[operand4],130
    mov byte[operand5],0
    call ColorTheScreen
     
    
    
    
    ;//////////////////////////////line code
draw_line:
cmp byte[stat2],0
je zero
xor ecx,ecx
xor edx,edx
mov cx,[xmouse]
mov dx,[ymouse]
;sub ecx,160
mov [x1],ecx
;sub edx,100
;neg edx
mov [y1],edx
inc byte[stat2]
jmp nexty
zero:

xor edx,edx
xor ecx,ecx
mov cx,[xmouse]
mov dx,[ymouse]
;sub ecx,160
mov [x0],ecx
;sub edx,100
;neg edx
mov [y0],edx
inc byte[stat2]

nexty:
cmp byte[stat2],2
jne print
pusha
call paint
popa
mov byte[stat2],0

print:
ret


paint:
mov eax,[x1]
sub eax,[x0]
mov[ddx],eax

cmp eax,0
jge notnegx
neg eax
notnegx:
mov [addx],eax

mov eax,[y1]
sub eax,[y0]
mov[ddy],eax


cmp eax,0
jge notnegy
neg eax
notnegy:
mov [addy],eax

cmp eax,[addx]
ja yabove
mov edx,[addx]
mov [step],edx
jmp xyinc
yabove:
mov [step],eax

xyinc:
fild dword[ddx]
fidiv dword[step]
fstp dword [xinc]

fild dword[ddy]
fidiv dword[step]
fstp dword [yinc]

fild dword[x0]
fstp dword[xx]
fild dword[y0]
fstp dword[yy]

mov ecx,0
nextgg:
cmp ecx,[step]
jg next5
pushad

fld dword[xx]
fadd dword [xinc]
fst dword [xx]
fistp dword [x0]

fld dword[yy]
fadd dword [yinc]
fst dword [yy]
fistp dword[y0]

call paint2
popad

inc ecx
jmp nextgg

paint2:
mov al,[color3]
mov ecx,[x0]
mov edx,[y0]
mov ah,0ch
int 10h
ret
next5:
ret

;///////////////////////////circle code
draw_circle:
cmp byte[stat2],0
je zero_c
xor ecx,ecx
xor edx,edx
mov cx,[xmouse]
mov dx,[ymouse]
;sub ecx,160
mov [xr],ecx
;sub edx,100
;neg edx
mov [yr],edx
inc byte[stat2]
jmp nexty_c
zero_c:
xor edx,edx
xor ecx,ecx
mov cx,[xmouse]
mov dx,[ymouse]
;sub ecx,160
mov [xc],ecx
;sub edx,100
;neg edx
mov [yc],edx
inc byte[stat2]

nexty_c:
cmp byte[stat2],2
jne print_c
pusha
call paint_c
popa
mov byte[stat2],0

print_c:
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(xc,yc) = the value of the center;
;(xr,yr) =  point at the circumference;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;the value of the radius
paint_c:
fild word[xc]
fisub word[xr]
fmul st0
fild word[yc]
fisub word[yr]
fmul st0
fadd
fsqrt
fistp word[r]

mov ax,[xc]
add ax,[r]
cmp ax,259
jg done
mov ax,[xc]
sub ax,[r]
cmp ax,0
jl done

mov ax,[yc]
add ax,[r]
cmp ax,199
jg done
mov ax,[yc]
sub ax,[r]
cmp ax,0
jl done


;;your code
;;;x=r y=0
mov cx,[r]
mov [x],cx
;////////////////////ta3dee;////////
xor bx,bx
mov [y],bx
;////////////////////////////ta3deeel
jmp l4
;;;;
begining:

mov dx,[p]
neg dx
add dx,1
mov [p],dx

;;;while (x>y)
circle:
mov cx,[x]
cmp cx ,[y]
jle done
;;;y++
inc word[y]
;;;;if (p<=0)
;P = P + 2*y + 1;
mov bx,[p]
cmp bx,0
jg l2
mov dx,[y]
add dx,dx
inc dx
add dx,[p]
mov [p],dx
jmp if3
;;;;
;;else
;P = P + 2*y - 2*x + 1;
;x--;
l2:
dec word[x]
mov dx,[x]
add dx,dx
neg dx
mov bx,[y]
add bx,bx
add bx ,dx
inc bx
add bx,[p]
mov [p],bx
;;;;;;;;
;;if3
if3:
mov dx,[x]
cmp dx,[y]
jge l4
jmp done
;;;;l4
l4:
;;;(x+xc,y+yc)
mov ah,0Ch 	
mov al,[color3]
mov cx,[x]
mov dx,[y]
add cx,[xc]
add dx,[yc]
int 10h
;;;(-x + x_centre, y + y_centre)
mov ah,0Ch 	
mov al,[color3]
mov cx,[x]
neg cx
mov dx,[y]
add cx,[xc]
add dx,[yc]
int 10h
;;;(x + x_centre, -y + y_centre)
mov ah,0Ch 	
mov al,[color3]
mov cx,[x]
mov dx,[y]
neg dx
add cx,[xc]
add dx,[yc]
int 10h
;;;( -x + x_centre, -y + y_centre)
mov ah,0Ch 	
mov al,[color3]
mov cx,[x]
neg cx
mov dx,[y]
neg dx
add cx,[xc]
add dx,[yc]
int 10h

mov ax,[y]
cmp ax,0
je begining
;;;;;;
;;if(x!=y)
mov bx,[x]
cmp bx,[y]
je l5
;;;;(y+xc,x+yc)
mov ah,0Ch 	
mov al,[color3]
mov cx,[y]
mov dx,[x]
add cx,[xc]
add dx,[yc]
int 10h
;;;(-y + x_centre, x + y_centre)
mov ah,0Ch 	
mov al,[color3]
mov cx,[y]
neg cx
mov dx,[x]
add cx,[xc]
add dx,[yc]
int 10h
;;;(y + x_centre, -x + y_centre)
mov ah,0Ch 	
mov al,[color3]
mov cx,[y]
mov dx,[x]
neg dx
add cx,[xc]
add dx,[yc]
int 10h
;;;(-y + x_centre, -x + y_centre)
mov ah,0Ch 	
mov al,[color3]
mov cx,[y]
neg cx
mov dx,[x]
neg dx
add cx,[xc]
add dx,[yc]
int 10h

l5:
jmp circle
;;end of the while loop
done:
;mov byte[keyboard_status],0
ret
;/////////////////triangle code
draw_triangle:
cmp byte[stat2],0
je zerotri
cmp byte[stat2],1
je onetri
xor ecx,ecx
xor edx,edx
mov cx,[xmouse]
mov dx,[ymouse]
;sub ecx,160
mov [tempx2],ecx
;sub edx,100
;neg edx
mov [tempy2],edx
inc byte[stat2]
jmp nextytri

onetri:
xor ecx,ecx
xor edx,edx
mov cx,[xmouse]
mov dx,[ymouse]
;sub ecx,160
mov [tempx1],ecx
;sub edx,100
;neg edx
mov [tempy1],edx
inc byte[stat2]
jmp nextytri
zerotri:
xor edx,edx
xor ecx,ecx
mov cx,[xmouse]
mov dx,[ymouse]
;sub ecx,160
mov [tempx0],ecx
;sub edx,100
;neg edx
mov [tempy0],edx
inc byte[stat2]
mov al,0
mov cx,100
mov dx,100
mov ah,0ch
int 10h

nextytri:
cmp byte[stat2],3
jne printtri
pusha
mov esi,[tempx0]
mov edi,[tempx1]
mov [x0],esi
mov [x1],edi
mov esi,[tempy0]
mov edi,[tempy1]
mov [y0],esi
mov [y1],edi
call paint
popa


pusha
mov esi,[tempx1]
mov edi,[tempx2]
mov [x0],esi
mov [x1],edi
mov esi,[tempy1]
mov edi,[tempy2]
mov [y0],esi
mov [y1],edi
call paint
popa

pusha
mov esi,[tempx2]
mov edi,[tempx0]
mov [x0],esi
mov [x1],edi
mov esi,[tempy2]
mov edi,[tempy0]
mov [y0],esi
mov [y1],edi
call paint
popa


mov byte[stat2],0

printtri:
ret

;///////////////////sqr
draw_square:
cmp byte[stat2],0
je zerosqu
xor ecx,ecx
xor edx,edx
mov cx,[xmouse]
mov dx,[ymouse]
;sub ecx,160
mov [tempx1],ecx
;sub edx,100
;neg edx
mov [tempy1],edx
inc byte[stat2]
jmp nextysqu



zerosqu:
xor edx,edx
xor ecx,ecx
mov cx,[xmouse]
mov dx,[ymouse]
;sub ecx,160
mov [tempx0],ecx
;sub edx,100
;neg edx
mov [tempy0],edx
inc byte[stat2]

nextysqu:
cmp byte[stat2],2
jne printsqu
;////////////////draw the first line
pusha
mov esi,[tempx0]
mov edi,[tempx1]
mov [x0],esi
mov [x1],edi
mov esi,[tempy0]
mov edi,[tempy1]
mov [y0],esi
mov [y1],edi
call paint
popa
mov esi,[tempx1]
sub esi,[tempx0]
cmp esi,0
jg _AAA2
neg esi
_AAA2:
;draw to point two which have the same x0 axis
;note tempy2=tempy3
;also tempx0=tempx2
;tempx1=tempx3
mov [branchlength],esi
add esi,[tempy0]
mov [tempy2],esi
mov esi,[tempx0]
mov [tempx2],esi
pusha

mov esi,[tempx0]
mov edi,[tempx2]
mov [x0],esi
mov [x1],edi
mov esi,[tempy0]
mov edi,[tempy2]
mov [y0],esi
mov [y1],edi
call paint
popa
;draw to the two points with the same tempy2 value
;mov esi,[branchlength]
mov esi,[tempy1]
add esi,[branchlength]
mov [tempy3],esi
mov esi,[tempx1]
mov [tempx3],esi

pusha
mov esi,[tempx2]
mov edi,[tempx3]
mov [x0],esi
mov [x1],edi
mov esi,[tempy2]
mov edi,[tempy3]
mov [y0],esi
mov [y1],edi
call paint
popa
;the last branch from x3,y3 to x1,y1
;mov esi,[branchlength]
;movesi,[tempy0]
;mov [tempy2],esi
;mov esi,[tempx1]
;mov [tempx2],esi

pusha
mov esi,[tempx3]
mov edi,[tempx1]
mov [x0],esi
mov [x1],edi
mov esi,[tempy3]
mov edi,[tempy1]
mov [y0],esi
mov [y1],edi
call paint
popa


mov byte[stat2],0

printsqu:
ret

;/////////////////////////quad
draw_quad:
cmp byte[stat2],0
je zeroqu
cmp byte[stat2],1
je onequ
cmp byte[stat2],2
je twoqu
xor ecx,ecx
xor edx,edx
mov cx,[xmouse]
mov dx,[ymouse]
;sub ecx,160
mov [tempx3],ecx
;sub edx,100
;neg edx
mov [tempy3],edx
inc byte[stat2]
jmp nextyqu

twoqu:
xor ecx,ecx
xor edx,edx
mov cx,[xmouse]
mov dx,[ymouse]
;sub ecx,160
mov [tempx2],ecx
;sub edx,100
;neg edx
mov [tempy2],edx
inc byte[stat2]
jmp nextyqu

onequ:
xor ecx,ecx
xor edx,edx
mov cx,[xmouse]
mov dx,[ymouse]
;sub ecx,160
mov [tempx1],ecx
;sub edx,100
;neg edx
mov [tempy1],edx
inc byte[stat2]
jmp nextyqu

zeroqu:
xor edx,edx
xor ecx,ecx
mov cx,[xmouse]
mov dx,[ymouse]
;sub ecx,160
mov [tempx0],ecx
;sub edx,100
;neg edx
mov [tempy0],edx
inc byte[stat2]

nextyqu:
cmp byte[stat2],4
jne printsqu
pusha
mov esi,[tempx0]
mov edi,[tempx1]
mov [x0],esi
mov [x1],edi
mov esi,[tempy0]
mov edi,[tempy1]
mov [y0],esi
mov [y1],edi
call paint
popa


pusha
mov esi,[tempx1]
mov edi,[tempx2]
mov [x0],esi
mov [x1],edi
mov esi,[tempy1]
mov edi,[tempy2]
mov [y0],esi
mov [y1],edi
call paint
popa

pusha
mov esi,[tempx2]
mov edi,[tempx3]
mov [x0],esi
mov [x1],edi
mov esi,[tempy2]
mov edi,[tempy3]
mov [y0],esi
mov [y1],edi
call paint
popa

pusha
mov esi,[tempx3]
mov edi,[tempx0]
mov [x0],esi
mov [x1],edi
mov esi,[tempy3]
mov edi,[tempy0]
mov [y0],esi
mov [y1],edi
call paint
popa

mov byte[stat2],0

printqu:
ret

;//////////////////////////bakhakh
draw_bakhakh:
xor edx,edx
xor ecx,ecx
xor esi,esi
mov cx,[xmouse]
mov dx,[ymouse]
mov [x01],ecx
mov [y01],edx
;the first quarter from the (x0,y0)
loop1:
cmp esi,3
jg continue_sp1
fild dword[x01]
call random
fiadd dword[random1]
fistp dword[xrandom]
fild dword[y01]
call random
fisub dword[random1]
fistp dword[yrandom]
call checker1
call printer_sp
inc esi
jmp loop1

continue_sp1:
xor esi,esi

;for the second quarter
loop2:
cmp esi,3
jg continue_sp2
fild dword[x01]
call random
fisub dword[random1]
fistp dword[xrandom]
fild dword[y01]
call random
fisub dword[random1]
fistp dword[yrandom]
call checker1
call printer_sp
inc esi
jmp loop2

continue_sp2:
xor esi,esi

;for the third quarter
loop3:
cmp esi,3
jg continue_sp3
fild dword[x01]
call random
fisub dword[random1]
fistp dword[xrandom]
fild dword[y01]
call random
fiadd dword[random1]
fistp dword[yrandom]
call checker1
call printer_sp
inc esi
jmp loop3

continue_sp3:
xor esi,esi
;for the fourth quarter
loop4:
cmp esi,3
jg Next10
fild dword[x01]
call random
fiadd dword[random1]
fistp dword[xrandom]
fild dword[y01]
call random
fiadd dword[random1]
fistp dword[yrandom]
call checker1
call printer_sp
inc esi
jmp loop4
Next10:
jmp waitformouse
;ret

checker1:
;xrandom borders
cmp dword[xrandom],0  
jg case_1
mov dword[xrandom],0
	  
case_1:
xor edx,edx
movsx edx,word[xborder]
cmp dword[xrandom],edx
jl case_2
mov dword[xrandom],edx

case_2:
; yrandom borders
cmp dword [yrandom],199
jl case_3
mov dword[yrandom],199
       
case_3:
cmp dword [yrandom],0
jg case_4
mov dword [yrandom],0

case_4:
ret

random:
rdtsc
xor edx,edx
xor ebx,ebx
mov ebx,5
div ebx
mov dword[random1],edx
ret

printer_sp:
mov al,byte[color3]
mov ecx,[xrandom]
mov edx,[yrandom]
mov ah,0ch
int 10h
ret













this:
    

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
















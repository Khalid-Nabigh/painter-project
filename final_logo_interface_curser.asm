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

section .data
ScanCodeTable: db "//1234567890-=//QWERTYUIOP[]//ASDFGHJKL;//'/ZXCVBNM,.//// /"
xmouse: dw 0      
ymouse: dw 0
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




mov al,[color2]
mov cx,[xmouse]
mov dx,[ymouse]
mov ah,0ch
int 10h

next:
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
cmp word[xmouse],319
jl case1
mov word[xmouse],319
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
cmp byte[stat],1
je mouse_clicked
mov al,[color4]
jmp print
mouse_clicked:
mov al,[color4]
cmp dword[xmouse],260
jg change_color
jl dont_change_color
continue:
mov al,[color]

print:
mov cx,[xmouse]
mov dx,[ymouse]
mov ah,0ch
int 10h
jmp waitformouse


jmp done
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
    mov [xmouse],edi
    
    mov esi,[operand2]
    loopj:
    cmp esi,[operand4]
    je endloopj
    mov [ymouse],esi
    mov ah , 0ch
    mov al,[operand5]
    mov cx,[xmouse]
    mov dx,[ymouse]
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
    mov [xmouse],edi
    mov [ymouse],esi
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

done:


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
















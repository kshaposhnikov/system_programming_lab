;макрос вывода символа в графическом режиме (char - ASCII код символа)
;OutCharG macro x,y,color,char
;pusha
;mov ah,02h
;mov bh,0h
;mov dh,y
;mov dl,x
;int 10h
;mov ah,09h
;mov al,char
;mov bh,0h
;mov bl,color
;mov cx,01h
;int 10h
;popa
;endm
;---------------------------------------------------------
;макрос вывода пиксела на экран с коорд. x,y и цветом color
PrintPixel macro x,y,color 
pusha
mov ah,0ch
mov al,color
mov bh,0h
mov cx,x
mov dx,y
int 10h
popa
endm
;---------------------------------------------------------
;макрос вывода горизонтальной линии в середине экрана 
axisX macro
local iter
pusha
;OutCharG 4eh,0fh,03h,78h ;X
mov cx,640
iter:
 PrintPixel cx,240,3h
loop iter
PrintPixel 637,241,3h ;рисование стрелки стрелки на оси X
PrintPixel 637,239,3h
PrintPixel 636,241,3h
PrintPixel 636,239,3h
PrintPixel 635,241,3h
PrintPixel 635,239,3h
PrintPixel 634,241,3h
PrintPixel 634,239,3h
PrintPixel 633,241,3h
PrintPixel 633,239,3h
PrintPixel 632,242,3h
PrintPixel 632,238,3h
PrintPixel 633,242,3h
PrintPixel 633,238,3h
PrintPixel 632,241,3h
PrintPixel 632,239,3h
PrintPixel 634,242,3h
PrintPixel 634,238,3h
popa
endm
;---------------------------------------------------------
;макрос вывода вертикальной линии в середине экрана
axisY macro
local iter
pusha
mov cx,480
iter:
 mov dx,cx
 PrintPixel 320,dx,3h
 dec cx
 cmp cx,19
jge iter
PrintPixel 319,22,3h ;рисование стрелки на оси Y
PrintPixel 321,22,3h
PrintPixel 319,23,3h
PrintPixel 321,23,3h
PrintPixel 319,24,3h
PrintPixel 321,24,3h
PrintPixel 318,25,3h
PrintPixel 322,25,3h
PrintPixel 318,26,3h
PrintPixel 322,26,3h
PrintPixel 318,27,3h
PrintPixel 322,27,3h
PrintPixel 319,26,3h
PrintPixel 321,26,3h
PrintPixel 319,27,3h
PrintPixel 321,27,3h
PrintPixel 319,25,3h
PrintPixel 321,25,3h
;OutCharG 29h,01h,03h,79h ;Y
popa
endm
;---------------------------------------------------------


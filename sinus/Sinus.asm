;��������� ������� ������ ������

;������ ������ ������� �� ����� � �����. x,y � ������ color
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
;---------------------------------------------------
;������ ������ �������������� ����� � �������� ������ 
axisX macro
local iter
pusha
mov cx,640
iter:
 mov dx, cx 
 PrintPixel dx,240,3h
loop iter
PrintPixel 637,241,3h ;��������� ������� ������� �� ��� X
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
;-----------------------------------------------------------------
;������ ������ ������������ ����� � �������� ������
axisY macro
local iter, iter1, len, start
pusha
mov cx,480
iter:
 mov dx, cx
 PrintPixel 320,dx,3h
loop iter

PrintPixel 319,3,3h ;��������� ������� �� ��� Y
PrintPixel 321,3,3h
PrintPixel 319,4,3h
PrintPixel 321,4,3h
PrintPixel 319,5,3h
PrintPixel 321,5,3h
PrintPixel 318,6,3h
PrintPixel 322,6,3h
PrintPixel 318,7,3h
PrintPixel 322,7,3h
PrintPixel 318,8,3h
PrintPixel 322,8,3h
PrintPixel 319,7,3h
PrintPixel 321,7,3h
PrintPixel 319,8,3h
PrintPixel 321,8,3h
PrintPixel 319,6,3h
PrintPixel 321,6,3h
popa
endm
;---------------------------------------------------------
.model small
.stack 100h
.data

x       dd -15.0    ;������� 
step    dd 0.1      ;���

xdiv2   dd 320.0    ;�������� �� X � Y
ydiv2   dd 240.0

tmp     dd 0 

resultX dw 0        ;���������� �������������� �����
resultY dw 0

scaleX  dd 21.0     ;���������� ������������
scaleY  dd 160.0 

.code
.486
start:
mov ax, @DATA       ;������ ����� �������� ������ � ax
mov ds, ax          ; ���������� ax � ds
;xor ax, ax
;------------------------------------------------------------------
mov ah, 0h          ;�������������� ����������� �����
mov al, 12h
int 10h
;-----------------------------------------------------------------
axisX               ;����� ���� ���������
axisY

mov cx, 12ch        ;7530h ;����� � �� ���������� �������� �����
finit               ;�������������� �������������� �����������

iter:
 fld x              ; x
 fld scaleX         ; scaleX
 fmul               ; scaleX*x
 frndint            ; round(scaleX*x)
 fld xdiv2          ; xdiv2
 fadd               ; xdiv2+round(scaleX*x)
 fistp word ptr resultX ;������� X � ���������� ��� ������ �� �����

 fld x              ; x
 fsin               ; sin(x)
 fdiv x             ; sin(x) / x
 fld scaleY         ; scaleY
 fmul               ; scaleY*sin(x)
 frndint            ; round(scaleY*sin(x))
 fstp tmp           ; tmp=round(scaleY*sin(x))
 fld ydiv2          ; ydiv2
 fsub tmp           ; ydiv2-round(scaleY*sin(x))
 fistp word ptr resultY ;������� Y � ���������� ��� ������ �� �����

 PrintPixel resultX, resultY, 0ah ;������� ����� ������� ������

 fld step           ;��������� ����� �������� x
 fld x
 fadd
 fstp x
loop iter             ;���� �� cx
;--------------------------------------------------------------------
mov ah, 1h          ;�������� ������� ������� 
int 21h
;--------------------------------------------------------------------
mov ah, 0h          ;������� ������� � ��������� �����
mov al, 03h
int 10h
;--------------------------------------------------------------------
exit:
mov ax, 4C00h       ;����������� �����
int 21h

END start

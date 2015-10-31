;��������� ������� ������ ������

;include util.inc ;�������� ������� ������ �����, ���� � �������

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
;OutCharG 4eh,0fh,03h,78h ;X
mov cx,640
iter:
 PrintPixel cx,240,3h
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
local iter
pusha
mov cx,480
iter:
 ;mov dx,cx
 lea dx, iter
 sub dx. 480
 PrintPixel 320,dx,3h
 ;dec cx
 ;cmp cx,19
;jge iter
loop iter
PrintPixel 319,22,3h ;��������� ������� �� ��� Y
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
 fld x              ;st(0)=x
 fld scaleX         ;st(0)=scaleX st(1)=x
 fmul               ;st(0)=scaleX*x
 frndint            ;st(0)=round(scaleX*x)
 fld xdiv2          ;st(0)=xdiv2 st(1)=round(scaleX*x)
 fadd               ;st(0)=xdiv2+round(scaleX*x) - ���������� X �������!!!
 fistp word ptr resultX ;������� X � ���������� ��� ������ �� �����

 fld x              ;st(0)=x
 fsin               ;st(0)=sin(x)
 fdiv x             ;st(0)=sin(x) / cyscleX
 fld scaleY         ;st(0)=scaleY st(1)=sin(x)
 fmul               ;st(0)=scaleY*sin(x)
 frndint            ;st(0)=round(scaleY*sin(x))
 fstp tmp           ;tmp=round(scaleY*sin(x))
 fld ydiv2          ;st(0)=ydiv2
 fsub tmp           ;st(0)=ydiv2-round(scaleY*sin(x)) - ���������� Y �������!!!
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

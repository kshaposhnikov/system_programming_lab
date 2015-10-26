;����� ������� ������ ������

include util.inc ;�������� ������� ������ �����, ���� � �������

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

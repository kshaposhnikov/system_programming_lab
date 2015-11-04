;��������� ������� ������ ������

;������ ������ ������� �� �����
PrintPixel macro x,y,color 
pusha
mov ah, 0ch
mov bh, 0h

mov cx, x
mov dx, y
mov al, color

int 10h
popa
endm
;---------------------------------------------------
;������ ������ ��� X 
axisX macro
local iter
pusha
mov cx, 640
iter:
 mov dx, cx 
 PrintPixel dx, 240, 3h
loop iter

PrintPixel 637, 241, 3h ;��������� ������� ������� �� ��� X
PrintPixel 637, 239, 3h
PrintPixel 636, 238, 3h
PrintPixel 636, 242, 3h
PrintPixel 635, 237, 3h
PrintPixel 635, 243, 3h
popa
endm
;-----------------------------------------------------------------
;������ ������ ��� Y
axisY macro
local iter
pusha
mov cx, 480
iter:
 mov dx, cx
 PrintPixel 320, dx, 3h
loop iter

PrintPixel 319, 3, 3h ;��������� ������� �� ��� Y
PrintPixel 321, 3, 3h
PrintPixel 318, 4, 3h
PrintPixel 322, 4, 3h
PrintPixel 317, 5, 3h
PrintPixel 323, 5, 3h
popa
endm
;---------------------------------------------------------
.model small
.stack 100h
.data

x       dd -15.0    ; ���������� X 
step    dd 0.1      ; ���

middleX   dd 320.0    ; �������� �� ��� X
middleY   dd 240.0    ; �������� �� ��� Y

tmp     dd 0 

resultX dw 0        ;���������� �������������� �����
resultY dw 0

scaleX  dd 21.0     ;���������� ������������
scaleY  dd 160.0 

.code
.486
start:
mov ax, @DATA       ; ������ ����� �������� ������ � ax
mov ds, ax          ; ���������� ax � ds
;------------------------------------------------------------------
mov ah, 0h          ; �������������� ����������� �����
mov al, 12h
int 10h
;-----------------------------------------------------------------
axisX               ;������� ��� X
axisY

mov cx, 12ch        ; 12ch ����� � �� ���������� �������� �����
finit               ; ���������� �������������� �����������

iter:
 fld x              ; ������ � ���� x
 fld scaleX         ; ������ � ���� scaleX
 fmul               ; scaleX * x
 frndint            ; round(scaleX*x)
 fld middleX        ; ������ � ���� middleX
 fadd               ; middleX + round(scaleX * x)
 fistp word ptr resultX ;������� X � ���������� ��� ������ �� �����

 fld x              ; ������ � ���� x
 fsin               ; sin(x)
 fdiv x             ; sin(x) / x
 fld scaleY         ; ������ � ���� scaleY
 fmul               ; scaleY * (sin(x) / x)
 frndint            ; round(scaleY * (sin(x) / x))
 fstp tmp           ; tmp = round(scaleY * (sin(x) / x))
 fld middleY        ; ������ � ���� middleY
 fsub tmp           ; middleY - round(scaleY * (sin(x) / x))
 fistp word ptr resultY ;������� Y � ���������� ��� ������ �� �����

 PrintPixel resultX, resultY, 0ah ;������� ����� ������� ������

 fld step           ; ��������� ����� �������� ��� x
 fld x
 fadd
 fstp x
loop iter             ; ����� ��������
;--------------------------------------------------------------------
mov ah, 1h          ; press any key 
int 21h
;--------------------------------------------------------------------
mov ah, 0h          ; ������� � ��������� �����
mov al, 03h
int 10h
;--------------------------------------------------------------------
exit:
mov ax, 4C00h       ; �����
int 21h

END start

;----------------------------------------
;������ ��������� ��� ������� �� �������� ��������
CalculateCodeOfChar macro code  
local digital ,letter, iter
push cx             ; ��������� cx � ����    
mov cx, 2           ; ����������� 2 ��� �����
mov bh, code        ; ��������� code � bh
mov al, bh          ; �������� bh � al
shr al, 04          ; �������� �������� al �� 4 �������� ������

iter:
cmp al, 09h          ; ���������� al � 9
jbe digital          ; ���� ������ ���� �����, ��������� �� digital
add al, 37h          ; ���������� 55 ��� ��������� ���� �����
jmp letter           ; ��������� �� letter

digital:
add al,30h          ; ���������� 48 ��� ��������� ���� �����

letter:
OutSymbol al        ; ������� ������

mov al, bh          ; ����� �������� bh � al
and al,00001111b    ; �������� ������� ��������, ����� ������� ������ ������
loop iter           ; ��������� ����

OutSymbol ' '       ; ������� ������

add di,01h          ; ����������� di �� 1
pop cx              ; ��������������� cx �� �����
endm

;-----------------------------------------------------------
;������ ������ �������
OutSymbol macro code
push ax
mov al, code
mov es:[si],al
add si, 2
pop ax
endm
;------------------------------------------------------------
.model small
.stack 100h
.data
    row dd 01h
    column dd 01h
.code
start:
.486
mov ax,@DATA
mov ds,ax

; ������������� ������������ ������
mov ax, 0B900h
mov es, ax
mov ah, 0fh
int 10h
mov ax, 0003h
int 10h
mov ax, 0501h
int 10h

;��������� ��������
mov si,0
mov di,0

mov cx,offset exit      ; ���������� � cx ����� ������ ���������
sub cx,offset start     ; �������� �� cx ����� ����� ���������

CXne0:
;lea bx, row
;mov ax, 0a0h
;mul bx
;mov si, ax
lea bx, column
mov ax, 2h
mul bx
mov si, ax
;add ax, si
;mov si, ax


mov al,cs:[di]
;mov si, 160 * 2 + 0 * 2
CalculateCodeOfChar al
add column, 01h
loop Cxne0

exit:
mov ax,4C00h
int 21h
END start

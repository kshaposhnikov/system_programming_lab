;----------------------------------------
;ћакрос вычисл€ет код символа по значению регистра
CalculateCodeOfChar macro code  
local digital ,letter, iter
push cx             ; сохран€ем cx в стек    
mov cx, 2           ; присваиваем 2 дл€ цикла
mov bh, code        ; сохран€ем code в bh
mov al, bh          ; копируем bh в al
shr al, 04          ; сдвигаем занчение al на 4 разра€да вправо

iter:
cmp al, 09h          ; сравниваем al с 9
jbe digital          ; если меньше либо равно, переходим по digital
add al, 37h          ; прибавл€ем 55 дл€ получени€ кода буквы
jmp letter           ; переходим по letter

digital:
add al,30h          ; прибавл€ем 48 дл€ получени€ кода цифры

letter:
OutSymbol al        ; выводим символ

mov al, bh          ; снова копируем bh в al
and al,00001111b    ; обнул€ем старшие разра€ды, чтобы вывести второй символ
loop iter           ; повтор€ем цикл

OutSymbol ' '       ; выводим пробел

add di,01h          ; увеличиваем di на 1
pop cx              ; восстанавливаем cx из стека
endm

;-----------------------------------------------------------
;ћакрос вывода символа
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

; »нициализаци€ графического режима
mov ax, 0B900h
mov es, ax
mov ah, 0fh
int 10h
mov ax, 0003h
int 10h
mov ax, 0501h
int 10h

;Ќачальные значени€
mov si,0
mov di,0

mov cx,offset exit      ; записываем в cx алрес начала программы
sub cx,offset start     ; вычитаем из cx адрес конца программы

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

;----------------------------------------
;Макрос вычисляет код символа по значению регистра
CalculateCodeOfChar macro code  
local digital ,letter, iter
push cx             ; сохраняем cx в стек    
mov cx, 2           ; присваиваем 2 для цикла
mov bh, code        ; сохраняем code в bh
mov al, bh          ; копируем bh в al
shr al, 04          ; сдвигаем занчение al на 4 разраяда вправо

iter:
cmp al, 09h          ; сравниваем al с 9
jbe digital          ; если меньше либо равно, переходим по digital
add al, 37h          ; прибавляем 55 для получения кода буквы
jmp letter           ; переходим по letter

digital:
add al,30h          ; прибавляем 48 для получения кода цифры

letter:
OutSymbol al        ; выводим символ

mov al, bh          ; снова копируем bh в al
and al,00001111b    ; обнуляем старшие разраяды, чтобы вывести второй символ
loop iter           ; повторяем цикл

OutSymbol ' '       ; выводим пробел

add di,01h          ; увеличиваем di на 1
pop cx              ; восстанавливаем cx из стека
endm

;-----------------------------------------------------------
;Макрос вывода символа
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
    dischargesInLine dd 01h
.code
start:
.486
mov ax,@DATA
mov ds,ax

; Инициализация графического режима
mov ax, 0B900h
mov es, ax
mov ah, 0fh
int 10h
mov ax, 0003h
int 10h
mov ax, 0501h
int 10h

;Начальные значения
mov si,0
mov di,0

mov cx,offset exit      ; записываем в cx алрес начала программы
sub cx,offset start     ; вычитаем из cx адрес конца программы

CXne0:
mov al,cs:[di]				; записываем в al вдрес сдвига относительно cs
add dischargesInLine, 01h	; увеличиваем число байт в строке
CalculateCodeOfChar al		; dвысиляем и выводим символ
cmp dischargesInLine, 8h	; сравниваем число байт и 8
jle m1						; если меньше либо равно переходим по m1 и проболжаем цикл
sub dischargesInLine, 8h  	; в противном случае обнуляем переменную
add si, 112
m1:
loop Cxne0

exit:
mov ax,4C00h
int 21h
END start

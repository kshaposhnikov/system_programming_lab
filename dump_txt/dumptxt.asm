; Программа выводит свой дамп

CalculateCodeOfChar macro code
local digital,letter,iter
push cx         		; сохраняем cx
mov cx, 2       		; кладем 2 в cx для цикла по разрядам
mov bh,code     		; сохраняем переменнную code в bh
mov al,bh       		; копируем регистр bh в al
shr al,04       		; сдвигаем значение al на 4 разраяда вправо для получения первого символа

iter:
cmp al,09h      		; сравниваем al с 9
jbe digital          	; если меньше либо равно переходим по digital
add al,37h      		; прибавляем 55 для получения кода буквы
jmp letter          	; переходим по letter

digital:
add al,30h      		; прибавляем 48 к al для получеения кода цифры

letter:
OutChar ax      		; выводим ax

mov al, bh      		; снова копируем bh в al
and al, 00001111b   	; обнуляем старшие разряды, чтобы вывести второй символ
loop iter	         	; повторяем цикл

OutChar ' '         	; вывоидим пробел

add di,01h          	; увеличиваем di на 1  
pop cx              	; восстанавливаем cх из стека
endm

;----------------------------------------------
OutChar macro char ; макрос вывода символа
push ax
mov ah,06h
mov dx,char

;---------fix error with ASCII on DosBOX-------
sub dx, 30h
;----------------------------------------------

add dx,30h
int 21h
pop ax
endm
;---------------------------------------------------

.model small
.stack 100h
.data
    dischargesInLine dd 01h

.code
.486
start:
mov ax,@DATA
mov ds,ax

mov cx,offset exit			; записываем в cx адрес начала программы
sub cx,offset start 		; вычитаем их cх адрес конца программы

iter:
mov al,cs:[di]				; записываем в al вдрес сдвига относительно cs
add dischargesInLine, 01h	; увеличиваем число байт в строке
CalculateCodeOfChar al		; dвысиляем и выводим символ
cmp dischargesInLine, 8h	; сравниваем число байт и 8
jle m1						; если меньше либо равно переходим по m1 и проболжаем цикл
sub dischargesInLine, 8h  	; в противном случае обнуляем переменную
OutChar 0dh					; возврат коретки
OutChar 0ah					; перенос строки
m1:
loop iter

exit:
mov ax,4C00h
int 21h
END start
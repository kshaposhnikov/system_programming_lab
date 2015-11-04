;Программа выводит график синуса

;макрос вывода пикселя на экран
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
;макрос вывода оси X 
axisX macro
local iter
pusha
mov cx, 640
iter:
 mov dx, cx 
 PrintPixel dx, 240, 3h
loop iter

PrintPixel 637, 241, 3h ;рисование стрелки стрелки на оси X
PrintPixel 637, 239, 3h
PrintPixel 636, 238, 3h
PrintPixel 636, 242, 3h
PrintPixel 635, 237, 3h
PrintPixel 635, 243, 3h
popa
endm
;-----------------------------------------------------------------
;макрос вывода оси Y
axisY macro
local iter
pusha
mov cx, 480
iter:
 mov dx, cx
 PrintPixel 320, dx, 3h
loop iter

PrintPixel 319, 3, 3h ;рисование стрелки на оси Y
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

x       dd -15.0    ; переменная X 
step    dd 0.1      ; шаг

middleX   dd 320.0    ; середина по оси X
middleY   dd 240.0    ; середина по оси Y

tmp     dd 0 

resultX dw 0        ;координаты результирующей точки
resultY dw 0

scaleX  dd 21.0     ;масштабные коэффициенты
scaleY  dd 160.0 

.code
.486
start:
mov ax, @DATA       ; кладем адрес сегмента данных в ax
mov ds, ax          ; перемещаем ax в ds
;------------------------------------------------------------------
mov ah, 0h          ; инициализируем графический режим
mov al, 12h
int 10h
;-----------------------------------------------------------------
axisX               ;выводим ось X
axisY

mov cx, 12ch        ; 12ch клаем в СХ количество итераций цикла
finit               ; подключаем математический сопроцессор

iter:
 fld x              ; кладем в стек x
 fld scaleX         ; кладем в стек scaleX
 fmul               ; scaleX * x
 frndint            ; round(scaleX*x)
 fld middleX        ; кладем в стек middleX
 fadd               ; middleX + round(scaleX * x)
 fistp word ptr resultX ;заносим X в переменную дл€ вывода на экран

 fld x              ; кладем в стек x
 fsin               ; sin(x)
 fdiv x             ; sin(x) / x
 fld scaleY         ; кладем в стек scaleY
 fmul               ; scaleY * (sin(x) / x)
 frndint            ; round(scaleY * (sin(x) / x))
 fstp tmp           ; tmp = round(scaleY * (sin(x) / x))
 fld middleY        ; кладем в стек middleY
 fsub tmp           ; middleY - round(scaleY * (sin(x) / x))
 fistp word ptr resultY ;заносим Y в переменную дл€ вывода на экран

 PrintPixel resultX, resultY, 0ah ;выводим точку зеленым цветом

 fld step           ; вычисл€ем новое значение для x
 fld x
 fadd
 fstp x
loop iter             ; новая итерация
;--------------------------------------------------------------------
mov ah, 1h          ; press any key 
int 21h
;--------------------------------------------------------------------
mov ah, 0h          ; перевод в текстовый режим
mov al, 03h
int 10h
;--------------------------------------------------------------------
exit:
mov ax, 4C00h       ; выход
int 21h

END start

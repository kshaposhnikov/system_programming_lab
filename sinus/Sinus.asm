;прога выводит график синуса

include util.inc ;содержит макросы вывода точки, осей и символа

.model small
.stack 100h
.data

x       dd -15.0    ;счетчик 
step    dd 0.1      ;шаг

xdiv2   dd 320.0    ;середина по X и Y
ydiv2   dd 240.0

tmp     dd 0 

resultX dw 0        ;координаты результирующей точки
resultY dw 0

scaleX  dd 21.0     ;масштабные коэффициенты
scaleY  dd 160.0 

.code
.486
start:
mov ax, @DATA       ;кладем адрес сегмента данных в ax
mov ds, ax          ; перемещаем ax в ds
;xor ax, ax
;------------------------------------------------------------------
mov ah, 0h          ;инициализируем графический режим
mov al, 12h
int 10h
;-----------------------------------------------------------------
axisX               ;вывод осей координат
axisY

mov cx, 12ch        ;7530h ;клаем в СХ количество итераций цикла
finit               ;инициализируем математический сопроцессор

iter:
 fld x              ;st(0)=x
 fld scaleX         ;st(0)=scaleX st(1)=x
 fmul               ;st(0)=scaleX*x
 frndint            ;st(0)=round(scaleX*x)
 fld xdiv2          ;st(0)=xdiv2 st(1)=round(scaleX*x)
 fadd               ;st(0)=xdiv2+round(scaleX*x) - координата X найдена!!!
 fistp word ptr resultX ;заносим X в переменную дл€ вывода на экран

 fld x              ;st(0)=x
 fsin               ;st(0)=sin(x)
 fdiv x             ;st(0)=sin(x) / cyscleX
 fld scaleY         ;st(0)=scaleY st(1)=sin(x)
 fmul               ;st(0)=scaleY*sin(x)
 frndint            ;st(0)=round(scaleY*sin(x))
 fstp tmp           ;tmp=round(scaleY*sin(x))
 fld ydiv2          ;st(0)=ydiv2
 fsub tmp           ;st(0)=ydiv2-round(scaleY*sin(x)) - координата Y найдена!!!
 fistp word ptr resultY ;заносим Y в переменную дл€ вывода на экран

 PrintPixel resultX, resultY, 0ah ;выводим точку зеленым цветом

 fld step           ;вычисл€ем новое значение x
 fld x
 fadd
 fstp x
loop iter             ;цикл по cx
;--------------------------------------------------------------------
mov ah, 1h          ;ожидание нажати€ клавиши 
int 21h
;--------------------------------------------------------------------
mov ah, 0h          ;перевод обратно в текстовый режим
mov al, 03h
int 10h
;--------------------------------------------------------------------
exit:
mov ax, 4C00h       ;стандартный выход
int 21h

END start

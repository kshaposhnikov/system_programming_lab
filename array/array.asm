; Программа вычисляет сумму элементов массива

CalculateCodeOfChar macro code
local digital,letter,iter
push ax
push bx

mov bx,code     		; сохраняем переменнную code в bh
mov ax,bx       		; копируем регистр bh в al
add ax,30h      		; прибавляем 48 к al для получеения кода цифры

OutChar ax      		; выводим ax

pop ax
pop bx
endm

;----------------------------------------------
OutputNymberbydigital macro number, base
	local outdigit, iter, for

	push ax
	push bx
	push cx

	mov ax, 0h
	mov cx, 0h
	mov ax, number
    mov bx, base

	iter:
		inc cx
        
        xor dx, dx ; для расширения ax (чтобы можно было произвести деление без division by zero)
		div bx

		push dx
		cmp ax, bx
	 jbe outdigit
	 jmp iter

	 outdigit:
	 CalculateCodeOfChar ax
	for:
		pop dx   ;вытаскиваем число из цикла
        CalculateCodeOfChar dx
	loop for

	pop cx
	pop bx
	pop ax
endm
;----------------------------------------------
OutChar macro char ; макрос вывода символа
push ax
mov ah,02h
mov dx, char
int 21h
pop ax
endm
;---------------------------------------------------

.model small
.stack 1000h
.data
    dischargesInLine dd 01h
    ;array dw 1000 dup (?)
    ;array dw 4096, 2567, 4287, 1748, 5548, 133, 4840, 3481, 3547, 2047     ;      1 choice     result  32294
    ;array dw 962, 2548, 2312, 1297, 2584, 31, 2101, 5325, 4418, 3964        ;      2 choice     result  25542
    ;array dw 6281, 4465, 5002, 831, 3856, 5590, 1905, 3682, 1024, 4053     ;      3 choice     result  36689
    ;array dw 4440, 3168, 4100, 1428, 5150, 466, 654, 4602, 5945, 728        ;      4 choice     result  30681
    ;array dw 4840, 4925, 2939, 5407, 2625, 4053, 4214, 2581, 5318, 717     ;      5 choice     result 37619
    ;array dw 4972, 3153, 5701, 1721, 4615, 4810, 1511, 4907, 1951, 5167    ;     6 choice     result 38508
    ;array dw 300, 6220, 3610, 6190, 5993, 3991, 4319, 4785, 5029, 5398     ;      7 choice     result 45835
    ;array dw 66, 986, 1317, 4654, 1052, 4644, 4145, 1872, 2593, 4181        ;      8 choice     result 25510
    ;array dw 3604, 3350, 2772, 5894, 5057, 6307, 2795, 716, 911, 175        ;      9 choice     resut 31581
    array dw 2786, 1964, 543, 5367, 3729, 968, 6188, 5090, 242, 3431         ;      10 choice   result 30308
    result dw 0h
.code
.486
start:
    mov ax,@DATA
    mov ds,ax
    xor ax, ax
     
    mov cx, 10
    mov si, 0
    
    iter:
        add ax, [array + si]
        add si, 2
    loop iter
    
    mov result, ax
    OutputNymberbydigital result, 10
   
    exit:
    mov ax,4C00h
    int 21h
END start
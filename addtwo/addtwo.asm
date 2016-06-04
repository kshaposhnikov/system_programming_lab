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
    const1 dw 12h
    const2 dw 1369h
    
    var1 dw 57h
    var2 dw 0FFh
    
    result dw 0h
.code
.486
start:
    mov ax,@DATA
    mov ds,ax
    xor ax, ax
    
     mov ax, const2
    add ax, var1
    sub ax, var2
    mov bx, const1
    add bx, ax
    
    mov result, bx
    OutputNymberbydigital bx, 10
   
    exit:
    mov ax,4C00h
    int 21h
END start
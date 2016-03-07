; Программа вычисляет сумму элементов массива

CalculateCodeOfChar macro code
local digital,letter,iter
push cx         		; сохраняем cx
push ax
push bx

mov bh,code     		; сохраняем переменнную code в bh
mov al,bh       		; копируем регистр bh в al
cmp al,09h      		; сравниваем al с 9
add al,30h      		; прибавляем 48 к al для получеения кода цифры

OutChar ax      		; выводим ax

pop cx              	; восстанавливаем cх из стека
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
	mov al, number

	iter:
		inc cx
		mov bl, base
		div bl

		mov dx, ax  ; сохраняем в стек
		push dx
	
		mov ah, 0h
		cmp al, bl
	jbe outdigit
	jmp iter

	outdigit:
	CalculateCodeOfChar al
	for:
		pop dx   ;вытаскиваем число из цикла
		CalculateCodeOfChar dh
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
    array db 1000 dup (?)
    a db 0h
    b dw 0a07h
.code
.486
start:
     mov ax,@DATA
     mov ds,ax
     mov ax, 0h

     mov cx, 1000
     mov si, 0

     iter:
         mov array[si], 04h
         add al, array[si]
         inc si
     loop iter
    
	mov a, al
    OutputNymberbydigital a, 10
   
    exit:
    mov ax,4C00h
    int 21h
END start
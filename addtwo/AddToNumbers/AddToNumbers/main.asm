; http://www.masmforum.com/board/index.php?PHPSESSID=786dd40408172108b65a5a36b09c88c0&topic=8896.0

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
    include \masm32\include\masm32rt.inc
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

.data
	buf db 10 dup(?)

    const1 DWORD 12h
    const2 DWORD 1369h
    
    var1 DWORD 57h
    var2 DWORD 0FFh
    
    result DWORD 0h

.code

start:

    xor ax, ax
    
    mov eax, const2
    add eax, var1
    sub eax, var2
    mov ebx, const1
    add ebx, eax

	invoke dwtoa, ebx, ADDR buf  ;шч eax яхЁхтюфшь т dec ш яюьх∙рхь т сєЇхЁ
	invoke StdOut, ADDR buf
	;invoke MessageBox,0,addr buf,addr mes,0
	inkey
    exit

end start
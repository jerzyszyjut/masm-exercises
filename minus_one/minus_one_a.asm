.686
.model flat
public _minus_jeden
.code
_minus_jeden PROC
	push ebp			; zapisanie zawarto�ci EBP na stosie
	mov ebp, esp		; kopiowanie zawarto�ci ESP do EBP
	push ebx			; przechowanie zawarto�ci rejestru EBX
						; wpisanie do rejestru EBX adresu zmiennej zdefiniowanej
						; w kodzie w j�zyku C
	push eax
	mov ebx, [ebp+8]
	mov eax, [ebx]		; odczytanie warto�ci zmiennej

	mov ebx, [eax]
	dec ebx
	mov [eax], ebx
	pop eax
	pop ebx
	pop ebp
	ret
_minus_jeden ENDP
 END

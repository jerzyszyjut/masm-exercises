.686
.model flat
public _minus_jeden
.code
_minus_jeden PROC
	push ebp			; zapisanie zawartoœci EBP na stosie
	mov ebp, esp		; kopiowanie zawartoœci ESP do EBP
	push ebx			; przechowanie zawartoœci rejestru EBX
						; wpisanie do rejestru EBX adresu zmiennej zdefiniowanej
						; w kodzie w jêzyku C
	push eax
	mov ebx, [ebp+8]
	mov eax, [ebx]		; odczytanie wartoœci zmiennej

	mov ebx, [eax]
	dec ebx
	mov [eax], ebx
	pop eax
	pop ebx
	pop ebp
	ret
_minus_jeden ENDP
 END

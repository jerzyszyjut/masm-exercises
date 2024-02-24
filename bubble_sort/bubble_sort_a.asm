.686
.model flat
public _bubblesort
.code
_bubblesort PROC
	push ebp			; zapisanie zawartoœci EBP na stosie
	mov ebp, esp		; kopiowanie zawartoœci ESP do EBP
	push ebx			; przechowanie zawartoœci rejestru EBX
	mov edx, [ebp+12]	; liczba elementów tablicy
	dec edx

mainptl:
	mov ebx, [ebp+8]	; adres tablicy tablicy
	mov ecx, edx
						; wpisanie kolejnego elementu tablicy do rejestru EAX
ptl: 
	mov eax, [ebx]
						; porównanie elementu tablicy wpisanego do EAX z nastêpnym
	cmp eax, [ebx+4]
	jle koniec_ptl			; skok, gdy nie ma przestawiania
						; zamiana s¹siednich elementów tablicy
	mov esi, [ebx+4]
	mov [ebx], esi
	mov [ebx+4], eax
koniec_ptl:
	add ebx, 4			; wyznaczenie adresu kolejnego elementu
	loop ptl			; organizacja pêtli

	dec edx
	jnz mainptl

	pop ebx				; odtworzenie zawartoœci rejestrów
	pop ebp
	ret					; powrót do programu g³ównego
_bubblesort ENDP
 END
.686
.model flat
public _bubblesort
.code
_bubblesort PROC
	push ebp			; zapisanie zawarto�ci EBP na stosie
	mov ebp, esp		; kopiowanie zawarto�ci ESP do EBP
	push ebx			; przechowanie zawarto�ci rejestru EBX
	mov edx, [ebp+12]	; liczba element�w tablicy
	dec edx

mainptl:
	mov ebx, [ebp+8]	; adres tablicy tablicy
	mov ecx, edx
						; wpisanie kolejnego elementu tablicy do rejestru EAX
ptl: 
	mov eax, [ebx]
						; por�wnanie elementu tablicy wpisanego do EAX z nast�pnym
	cmp eax, [ebx+4]
	jle koniec_ptl			; skok, gdy nie ma przestawiania
						; zamiana s�siednich element�w tablicy
	mov esi, [ebx+4]
	mov [ebx], esi
	mov [ebx+4], eax
koniec_ptl:
	add ebx, 4			; wyznaczenie adresu kolejnego elementu
	loop ptl			; organizacja p�tli

	dec edx
	jnz mainptl

	pop ebx				; odtworzenie zawarto�ci rejestr�w
	pop ebp
	ret					; powr�t do programu g��wnego
_bubblesort ENDP
 END
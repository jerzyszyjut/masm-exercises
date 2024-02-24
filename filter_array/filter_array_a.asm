.686
.model flat
extern _malloc : PROC

public _tablica_nieparzystych

.data
	cztery	dd 4

.code
_tablica_nieparzystych PROC
	push ebp				; zapisanie zawartoœci EBP na stosie
	mov ebp, esp			; kopiowanie zawartoœci ESP do EBP
	push ebx				; przechowanie zawartoœci rejestru EBX
	mov esi, [ebp+8]		
	mov eax, [ebp+12]
	mov ecx, [eax]
	mov ebx, [eax]
	xor eax, eax			; eax - licznik nieparzystych, esi - adres obecnie sprawdzanego znaku, ecx - iterator
ptl1:
	mov edx, [esi]
	test edx, 1
	jz nastepny_obieg_ptl1
	inc eax
nastepny_obieg_ptl1:
	add esi, 4
	loop ptl1

	mov ecx, [ebp+12]
	mov [ecx], eax
	
	mul cztery
	push eax
	call _malloc
	add esp, 4

	; wpisywanie do nowej tablicy

	mov edi, eax
	mov ecx, ebx
	mov esi, [ebp+8]
ptl2:
	mov edx, [esi]
	test edx, 1
	jz nastepny_obieg_ptl2
	mov [edi], edx
	add edi, 4
nastepny_obieg_ptl2:
	add esi, 4
	loop ptl2


	pop ebx
	pop ebp
	ret
_tablica_nieparzystych ENDP
 END

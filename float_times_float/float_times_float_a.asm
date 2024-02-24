.686
.model flat

public _float_razy_float

.code 
_float_razy_float PROC
	push ebp
	mov ebp, esp
	sub esp, 1
	pushad

	mov eax, [ebp+8]
	mov edx, eax
	and edx, 80000000h
	rol edx, 1

	mov ebx, [ebp+12]
	mov ecx, ebx
	and ecx, 80000000h
	rol ecx, 1
	xor edx, ecx
	mov [ebp-4], dl

	and eax, 007FFFFFh
	and ebx, 007FFFFFh
	bts eax, 23
	bts ebx, 23

	xor edx, edx

	mul ebx
	mov ecx, 23

petla:
	shr edx, 1
	rcr eax, 1
	loop petla

	bsr edx, eax
	sub edx, 23
	mov ecx, edx
	cmp ecx, 0
	jle dalej
	shr eax, cl
	jmp dalej_2

dalej:
	xor edx, edx

dalej_2:
	btr eax, 23

	mov ebx, [ebp+8]
	and ebx, 7F800000h
	shr ebx, 23
	sub ebx, 127
	add edx, ebx

	mov ebx, [ebp+12]
	and ebx, 7F800000h
	shr ebx, 23
	add edx, ebx
	
	shl edx, 23

	or eax, edx
	mov dl, [ebp-4]
	cmp dl, 0
	je dalej_3
	bts eax, 31

dalej_3:
	push eax
	fld dword ptr [esp]
	pop eax

	popad
	add esp, 1
	pop ebp
	ret
_float_razy_float ENDP

END

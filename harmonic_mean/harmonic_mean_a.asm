.686
.model flat
.data

.code
_srednia_harm PROC
	push ebp
	mov ebp, esp
	mov esi, [ebp+8]
	mov ecx, [ebp+12]

	finit
	fldz
ptl:
	fld1
	fld dword ptr [esi]
	fdiv
	fadd
	add esi, 4
	loop ptl

	fild dword ptr [ebp+12]
	fdiv st(0), st(1)
	sub esp, 4
	fist dword ptr [esp]
	mov eax, [esp]
	add esp, 4

	pop ebp
	ret
_srednia_harm ENDP
END

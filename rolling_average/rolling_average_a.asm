.686
.model flat
.xmm

.code
_progowanie_sredniej_kroczacej PROC
	push ebp
	mov ebp, esp
	sub esp, 4
	push ebx
	push esi
	push edi
	finit

	mov esi, [ebp+8]
	mov ebx, [ebp+12]
	
	push 6
	fild dword ptr [esp]
	push 10
	fild dword ptr [esp]
	add esp, 8
	fdivp

	; ST(0) obecna srednia, ST(1) poprzednia srednia, ST(2) 6/10
	xor edx, edx
	
ptl:
	fldz
	mov ecx, [ebp+16]
	xor eax, eax
	add eax, edx

ptl2:
	fld dword ptr [esi+eax*4]
	faddp
	inc eax
	loop ptl2
	fild dword ptr [ebp+16]
	fdivp

	inc edx
	cmp edx, 1
	ja sprawdz_czy_przekroczylo_prog
	jmp dalej

sprawdz_czy_przekroczylo_prog:
	fld st(1)
	fsub st(0), st(1)
	fabs
	fld st(3)
	fcomi st(0), st(1)
	fstp st(0)
	fstp st(0)
	ja koniec
	fxch st(1)
	fstp st(0)

dalej:
	dec ebx
	jnz ptl

koniec:
	fxch st(1)
	fstp st(0)
	pop edi
	pop esi
	pop ebx
	add esp, 4
	pop ebp
	ret
_progowanie_sredniej_kroczacej ENDP

END

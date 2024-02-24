# Harmonic mean
## x86 MASM with FPU

The goal of this exercise was to calculate the harmonic mean of an array of floating point numbers to get a better understanding of the FPU.

```c
#include <stdio.h>

extern float srednia_harm(float* tablica, unsigned int n);

int main()
{
	float tablica[] = { 0.5f, 0.25f, 0.125f };
	unsigned int n = 3;

	float wynik = srednia_harm(tablica, n);
	printf("%f", wynik);

	return 0;
}
```

```c
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
```


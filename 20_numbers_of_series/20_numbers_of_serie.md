# 20 numbers of a serie
## x86 MASM

The goal of a exercise was to calcualate sum of first 20 numbers of a serie `1 + x/1! + x^2/2! + x^3/3! + ....`

```c
#include <stdio.h>

extern float nowy_exp(float x);

int main()
{
	float wynik = nowy_exp(3.0);
	printf("%f", wynik);
	return 0;
}
```

```asm
.686
.model flat

.code
_nowy_exp PROC
	push ebp
	mov ebp, esp
	mov ecx, 19

	finit
	fld1
	fld1
	fld1
	fld dword ptr [ebp+8]
	; ST(0) = licznik, ST(1) = mianownik, ST(2) = suma, ST(3) = 1 (nastepna liczba przez jaka trzeba przemnozyc mianownik)
ptl:
	fld st(0)
	fdiv st(0), st(2)
	fld st(3)
	faddp
	fstp st(3)
	fld st(3)
	fld1
	faddp
	fst st(4)
	fmul st(0), st(2)
	fstp st(2)
	fld dword ptr [ebp+8]
	fmulp
	loop ptl

	fstp st(0)
	fstp st(0)
	fstp st(1)

	pop ebp
	ret
_nowy_exp ENDP

END
```

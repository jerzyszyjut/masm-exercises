# Divide using XMM
## x86 MASM

The goal of this exercise was to divide arrays of 4 single precision floating point numbers by single presisicion floating number using XMM registers and instructions.

```c
#include <stdio.h>
#include <xmmintrin.h>

void dziel(__m128* tablica1, unsigned int n, float dzielnik);

int main()
{
	__m128 tablica[2];
	tablica[0].m128_f32[0] = 5.0;
	tablica[0].m128_f32[1] = 10.0;
	tablica[0].m128_f32[2] = 15.0;
	tablica[0].m128_f32[3] = 20.0;
	
	tablica[1].m128_f32[0] = 50.0;
	tablica[1].m128_f32[1] = 100.0;
	tablica[1].m128_f32[2] = 150.0;
	tablica[1].m128_f32[3] = 200.0;
	unsigned int n = 2;
	float dzielnik = 5.0;
	
	dziel(&tablica, n, dzielnik);

	for (int i = 0; i < n; i++)
	{
		for (int j = 0; j < 4; j++)
		{
			printf("%f\n", tablica[i].m128_f32[j]);
		}
	}

	return 0;
}
```

```asm
.686
.model flat
.xmm

.data
zmienne dw ?, ?, ?, ?

.code
_dziel PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi

	mov ecx, 4
	mov edx, [ebp+16]
	xor ebx, ebx
ptl1:
	mov [ebx*4+OFFSET zmienne], edx
	inc ebx
	loop ptl1

	mov esi, [ebp+8]
	mov ecx, [ebp+12]

ptl2:
	movups xmm5, [esi]
	divps xmm5, xmmword ptr zmienne
	movups [esi], xmm5
	add esi, 16
	loop ptl2


	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_dziel ENDP

END
```

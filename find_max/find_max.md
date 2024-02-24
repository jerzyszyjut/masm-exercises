# Find maximum value in a list
## x64 MASM

The goal of this exercise was to find the maximum value in a list of 64-bit integers.

```c
#include <stdio.h>

extern __int64 szukaj64_max(__int64* tablica, __int64 n);

int main()
{
	__int64 wyniki[12] =
	{ -15, 4000000, -345679, 88046592,
	-1, 2297645, 7867023, -19000444, 31,
	456000000000000,
	444444444444444,
	-123456789098765 };
	__int64 wartosc_max;
	wartosc_max = szukaj64_max(wyniki, 12);
	printf("\nNajwiekszy element tablicy wynosi %I64d\n", wartosc_max);

	return 0;
}
```

```asm
public szukaj64_max
.code
szukaj64_max PROC
	push rbx				
	push rsi
	mov rbx, rcx			
	mov rcx, rdx			
	mov rsi, 0				
	mov rax, [rbx + rsi*8]
	dec rcx
ptl: 
	inc rsi					
	cmp rax, [rbx + rsi*8]
	jge dalej			
	mov rax, [rbx+rsi*8]
dalej: 
	loop ptl	
	pop rsi
	pop rbx
	ret
szukaj64_max ENDP
END
```

# Fixed-point to floating-point conversion
## x86 MASM

The goal of this exercise was to convert a fixed-point number to a floating-point number.

```c
#include <stdio.h>

typedef long long int UINT48;

float uint48_float(UINT48 p);

int main()
{
	UINT48 p = 0x38000;
	float wynik = uint48_float(p);
	printf("%f", wynik);
	return 0;
};
```
    
```asm
.686
.model flat
.xmm

.data
dzielnik dd 10000h

.code
_uint48_float PROC
	push ebp
	mov ebp, esp
	finit

	fild qword ptr [ebp+8]
	fidiv dword ptr dzielnik

	pop ebp
	ret
_uint48_float ENDP

END
```

# Sum of seven numbers
## x64 MASM

The goal of this exercise was to create a program that would calculate the sum of seven 64-bit integers and print the result to the console.

```c
#include <stdio.h>

extern __int64 suma_siedmiu_liczb(__int64 v1, __int64 v2, __int64
	v3, __int64 v4, __int64 v5, __int64 v6, __int64 v7);

int main()
{
	__int64 wynik = suma_siedmiu_liczb(1, 1, 1, 5, 1, 1, 1);
	printf("\nSuma wynosi %I64d\n", wynik);

	return 0;
}
```

```asm
public suma_siedmiu_liczb
.code
suma_siedmiu_liczb PROC
	push rbp
	mov rbp, rsp

	xor rax, rax
	mov [rbp+16], rcx
	mov [rbp+24], rdx
	mov [rbp+32], r8
	mov [rbp+40], r9
	mov rcx, 7
	mov rdx, 16

ptl:
	add rax, [rbp+rdx]
	add rdx, 8
	loop ptl

	pop rbp
	ret
suma_siedmiu_liczb ENDP
END
```

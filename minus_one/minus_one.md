# Minus one
## x86 MASM

The goal of this exercise was to one from one of a integers. Variables where handled using pointers.

```cpp
#include <stdio.h>

extern "C" void minus_jeden(int** a);

int main()
{
	int k;
	int* wsk;
	wsk = &k;
	printf("\nProsze napisac liczbe: ");
	scanf_s("%d", &k);
	minus_jeden(&wsk);
	printf("\nWynik = %d\n", k);
	return 0;
}
```

```asm
.686
.model flat
public _minus_jeden
.code
_minus_jeden PROC
	push ebp			; zapisanie zawarto�ci EBP na stosie
	mov ebp, esp		; kopiowanie zawarto�ci ESP do EBP
	push ebx			; przechowanie zawarto�ci rejestru EBX
						; wpisanie do rejestru EBX adresu zmiennej zdefiniowanej
						; w kodzie w j�zyku C
	push eax
	mov ebx, [ebp+8]
	mov eax, [ebx]		; odczytanie warto�ci zmiennej

	mov ebx, [eax]
	dec ebx
	mov [eax], ebx
	pop eax
	pop ebx
	pop ebp
	ret
_minus_jeden ENDP
 END
```

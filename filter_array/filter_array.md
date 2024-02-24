# Filter array
## x86 MASM

The goal of this exercise was to filter an array of integers, leaving only uneven numbers.

```c
#include <stdio.h>

extern int* tablica_nieparzystych(int tablica[], unsigned int* n);

int main()
{
	int tab[] = { 2, 2, 4, 2, 6, 8, 2 };
	int znalezione_nieparzyste = 7;
	int* tab2 = tablica_nieparzystych(tab, &znalezione_nieparzyste);

	printf_s("Znalezione liczby nieparzyste: %d\nTe liczby to:\n", znalezione_nieparzyste);
	for (int i = 0; i < znalezione_nieparzyste; i++)
	{
		printf_s("%d, ", tab2[i]);
	}
	return 0;
}
```

```asm
.686
.model flat
extern _malloc : PROC

public _tablica_nieparzystych

.data
	cztery	dd 4

.code
_tablica_nieparzystych PROC
	push ebp				; zapisanie zawarto�ci EBP na stosie
	mov ebp, esp			; kopiowanie zawarto�ci ESP do EBP
	push ebx				; przechowanie zawarto�ci rejestru EBX
	mov esi, [ebp+8]		
	mov eax, [ebp+12]
	mov ecx, [eax]
	mov ebx, [eax]
	xor eax, eax			; eax - licznik nieparzystych, esi - adres obecnie sprawdzanego znaku, ecx - iterator
ptl1:
	mov edx, [esi]
	test edx, 1
	jz nastepny_obieg_ptl1
	inc eax
nastepny_obieg_ptl1:
	add esi, 4
	loop ptl1

	mov ecx, [ebp+12]
	mov [ecx], eax
	
	mul cztery
	push eax
	call _malloc
	add esp, 4

	; wpisywanie do nowej tablicy

	mov edi, eax
	mov ecx, ebx
	mov esi, [ebp+8]
ptl2:
	mov edx, [esi]
	test edx, 1
	jz nastepny_obieg_ptl2
	mov [edi], edx
	add edi, 4
nastepny_obieg_ptl2:
	add esi, 4
	loop ptl2


	pop ebx
	pop ebp
	ret
_tablica_nieparzystych ENDP
 END
```

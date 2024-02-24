# Add ASCII numbers
## x86 MASM

The goal of this exercise was to add two ASCII numbers, which the first one is a wide char, output also has to be in wide char

```c
#include <stdio.h>

short int dodaj(wchar_t liczba_we[], char cyfra, wchar_t** liczba_wy);

int main()
{
	wchar_t liczba[] = L"15";
	wchar_t* wynik;
	short int a;

	a = dodaj(liczba, '1', &wynik);
	if (a != -1) printf("\nwynik = %ls\n", wynik);
	free(wynik);

	return 0;
}
```
    
```asm
.686
.model flat

extern _malloc: PROC
public _dodaj

.data
	dwa dd 2

.code

dodaj_ebx_do_eax_w_ascii PROC	; Dodaje do eax, ebx, zwraca w ASCII, w eax liczb�, w ebx przeniesienie
	add eax, ebx
	sub eax, '0'
	cmp eax, '9'
	jbe wieksze

	sub eax, 10
	mov ebx, '1'
	jmp koniec


wieksze:
	mov ebx, '0'

koniec:
	ret
dodaj_ebx_do_eax_w_ascii ENDP

_dodaj PROC
	push ebp
	mov ebp, esp
	push ebx

	mov esi, [ebp+8]
	xor ecx, ecx

ptl1:
	mov dx, [esi]
	add esi, 2
	cmp dx, '0'
	jb koniec_ptl1
	cmp dx, '9'
	ja koniec_ptl1
	inc ecx
	jmp ptl1

koniec_ptl1:
	sub esi, 4
	add ecx, 2
	mov edx, ecx

	mov eax, edx
	mul dwa
	mov edx, eax
	push edx
	call _malloc
	pop edx
	cmp eax, 0
	je bad_alloc
	mov edi, eax
	mov ebx, [ebp+16]
	mov [ebx], eax
	mov esi, [ebp+8]
	add edi, edx
	add esi, edx
	
	mov ebx, [ebp+12]
	mov ecx, edx
	sub edi, 2
	sub ecx, 2
	mov word ptr [edi], 0
	sub esi, 4

ptl3:
	sub esi, 2
	sub edi, 2
	xor eax, eax
	mov dx, '9'
	cmp [esi], dx
	ja popetli
	mov ax, [esi]
	call dodaj_ebx_do_eax_w_ascii
	mov [edi], ax
	dec ecx
	loop ptl3
popetli:
	cmp ebx, '0'
	je koniec2
	mov [edi], bx
	jmp koniec

bad_alloc:
	mov eax, -1
	jmp koniec

koniec2:
	mov ebx, [ebp+16]
	mov edx, 2
	add [ebx], edx
	jmp koniec

koniec:
	pop ebx
	pop ebp
	ret
_dodaj ENDP

END
```

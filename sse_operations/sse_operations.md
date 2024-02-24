# SSE Operations
## x86 MASM with SSE

The goal of this exercise was to create a program that would calculate addition, square root, reciprocal and sum of chars using SSE instructions.

```c
/* Program przyk�adowy ilustruj�cy operacje SSE procesora
 Program jest przystosowany do wsp�pracy z podprogramem
 zakodowanym w asemblerze (plik arytm_SSE.asm)
*/
#include <stdio.h>

void dodaj_SSE(float*, float*, float*);
void pierwiastek_SSE(float*, float*);
void odwrotnosc_SSE(float*, float*);
void sumy_char_SSE(char*, char*);

int main()
{
	/*float p[4] = {1.0, 1.5, 2.0, 2.5};
	float q[4] = { 0.25, -0.5, 1.0, -1.75 };
	float r[4];
	dodaj_SSE(p, q, r);
	printf("\n%f %f %f %f", p[0], p[1], p[2], p[3]);
	printf("\n%f %f %f %f", q[0], q[1], q[2], q[3]);
	printf("\n%f %f %f %f", r[0], r[1], r[2], r[3]);
	printf("\n\nObliczanie pierwiastka");
	pierwiastek_SSE(p, r);
	printf("\n%f %f %f %f", p[0], p[1], p[2], p[3]);
	printf("\n%f %f %f %f", r[0], r[1], r[2], r[3]);
	printf("\n\nObliczanie odwrotno�ci - ze wzgl�du na \
stosowanie");
	printf("\n12-bitowej mantysy obliczenia s� ma�o dok�adne");
	odwrotnosc_SSE(p, r);
	printf("\n%f %f %f %f", p[0], p[1], p[2], p[3]);
	printf("\n%f %f %f %f", r[0], r[1], r[2], r[3]);
	*/

	char liczby_A[16] = { -128, -127, -126, -125, -124, -123, -122, -121, 120, 121, 122, 123, 124, 125, 126, 127 };
	char liczby_B[16] = { -3, -3, -3, -3, -3, -3, -3, -3, 3, 3, 3, 3, 3, 3, 3, 3 };
	for (int i = 0; i < 16; i++)
	{
		printf("%d\t", liczby_A[i]);
	}
	printf("\n");
	for (int i = 0; i < 16; i++)
	{
		printf("%d\t", liczby_B[i]);
	}
	printf("\n");
	sumy_char_SSE(liczby_A, liczby_B);
	printf("\n");
	for (int i = 0; i < 16; i++)
	{
		printf("%d\t", liczby_B[i]);
	}
	printf("\n");

	return 0;
}
```

```asm
										; Program przyk�adowy ilustruj�cy operacje SSE procesora
										; Poni�szy podprogram jest przystosowany do wywo�ywania
										; z poziomu j�zyka C (program arytmc_SSE.c)
.686
.XMM									; zezwolenie na asemblacj� rozkaz�w grupy SSE
.model flat

public _dodaj_SSE, _pierwiastek_SSE, _odwrotnosc_SSE

.code

_dodaj_SSE PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi
	mov esi, [ebp+8]					; adres pierwszej tablicy
	mov edi, [ebp+12]					; adres drugiej tablicy
	mov ebx, [ebp+16]					; adres tablicy wynikowej
										; �adowanie do rejestru xmm5 czterech liczb zmiennoprzecin-
										; kowych 32-bitowych - liczby zostaj� pobrane z tablicy,
										; kt�rej adres poczatkowy podany jest w rejestrze ESI
										; interpretacja mnemonika "movups" :
										; mov - operacja przes�ania,
										; u - unaligned (adres obszaru nie jest podzielny przez 16),
										; p - packed (do rejestru �adowane s� od razu cztery liczby),
										; s - short (inaczej float, liczby zmiennoprzecinkowe
										; 32-bitowe)
	movups xmm5, [esi]
	movups xmm6, [edi]
										; sumowanie czterech liczb zmiennoprzecinkowych zawartych
										; w rejestrach xmm5 i xmm6
	addps xmm5, xmm6

										; zapisanie wyniku sumowania w tablicy w pami�ci
	movups [ebx], xmm5
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_dodaj_SSE ENDP

_pierwiastek_SSE PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	mov esi, [ebp+8]					; adres pierwszej tablicy
	mov ebx, [ebp+12]					; adres tablicy wynikowej
										; �adowanie do rejestru xmm5 czterech liczb zmiennoprzecin-
										; kowych 32-bitowych - liczby zostaj� pobrane z tablicy,
										; kt�rej adres pocz�tkowy podany jest w rejestrze ESI
										; mnemonik "movups": zob. komentarz podany w funkcji dodaj_SSE
	movups xmm6, [esi]
										; obliczanie pierwiastka z czterech liczb zmiennoprzecinkowych
										; znajduj�cych sie w rejestrze xmm6
										; - wynik wpisywany jest do xmm5
	sqrtps xmm5, xmm6

										; zapisanie wyniku sumowania w tablicy w pami�ci
	movups [ebx], xmm5
	pop esi
	pop ebx
	pop ebp
	ret
_pierwiastek_SSE ENDP

										; rozkaz RCPPS wykonuje obliczenia na 12-bitowej mantysie
										; (a nie na typowej 24-bitowej) - obliczenia wykonywane s�
										; szybciej, ale s� mniej dok�adne

_odwrotnosc_SSE PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	mov esi, [ebp+8]					; adres pierwszej tablicy
	mov ebx, [ebp+12]					; adres tablicy wynikowej
										; ladowanie do rejestru xmm5 czterech liczb zmiennoprzecin-
										; kowych 32-bitowych - liczby zostaj� pobrane z tablicy,
										; kt�rej adres poczatkowy podany jest w rejestrze ESI
										; mnemonik "movups": zob. komentarz podany w funkcji dodaj_SSE
	movups xmm5, [esi]
										; obliczanie odwrotno�ci czterech liczb zmiennoprzecinkowych
										; znajduj�cych si� w rejestrze xmm6
										; - wynik wpisywany jest do xmm5
	rcpps xmm5, xmm6
										; zapisanie wyniku sumowania w tablicy w pamieci
	movups [ebx], xmm5
	pop esi
	pop ebx
	pop ebp
	ret
_odwrotnosc_SSE ENDP

_sumy_char_SSE PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	mov esi, [ebp+8]					; adres pierwszej tablicy
	mov ebx, [ebp+12]					; adres tablicy wynikowej

	movups xmm5, [esi]
	movups xmm6, [ebx]

	paddsb xmm6, xmm5

	movups [ebx], xmm6

	pop esi
	pop ebx
	pop ebp
	ret
_sumy_char_SSE ENDP

END
```

# Write from EAX
## x86 MASM

The goal of this exercise was to create a program that would write a number to the console in many different number systems.

```asm
.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC
public _main

.data
									; deklaracja tablicy do przechowywania wprowadzanych cyfr
									; (w obszarze danych)
obszar		db 12 dup (?)
dziesiec	dd 10					; mno�nik
znaki		db 12 dup (?)			; deklaracja tablicy 11-bajtowej do przechowywania
									; tworzonych cyfr
dekoder db '0123456789ABCDEF'

.code
wyswietl_EAX_dec PROC
	pusha


	mov esi, 10						; indeks w tablicy 'znaki'
	mov ebx, 10						; dzielnik r�wny 10

konwersja:
	xor edx, edx					; zerowanie starszej cz�ci dzielnej
	div ebx							; dzielenie przez 10, reszta w EDX,
									; iloraz w EAX
	add dl, 30H						; zamiana reszty z dzielenia na kod
									; ASCII
	mov znaki [esi], dl				; zapisanie cyfry w kodzie ASCII
	dec esi							; zmniejszenie indeksu
	or eax, eax						; sprawdzenie czy iloraz = 0
	jne konwersja					; skok, gdy iloraz niezerowy

									; wype�nienie pozosta�ych bajt�w spacjami i wpisanie
									; znak�w nowego wiersza
wypeln:
	or esi, esi
	jz wyswietl						; skok, gdy ESI = 0
	mov byte PTR znaki[esi], 20H	; kod spacji
	dec esi							; zmniejszenie indeksu
	jmp wypeln

wyswietl:
	mov byte PTR znaki[11], 0AH	; kod nowego wiersza
									; wy�wietlenie cyfr na ekranie
	push dword PTR 12				; liczba wy�wietlanych znak�w
	push dword PTR OFFSET znaki		; adres wy�w. obszaru
	push dword PTR 1				; numer urz�dzenia (ekran ma numer 1)
	call __write					; wy�wietlenie liczby na ekranie
	add esp, 12						; usuni�cie parametr�w ze stosu


	popa
	ret
wyswietl_EAX_dec ENDP


wczytaj_dec_do_EAX PROC
	pushfd
	push ecx	
	push ebx
									; wczytywanie liczby dziesi�tnej z klawiatury � po
									; wprowadzeniu cyfr nale�y nacisn�� klawisz Enter
									; liczba po konwersji na posta� binarn� zostaje wpisana
									; do rejestru EAX
									; max ilo�� znak�w wczytywanej liczby
	push dword PTR 12
	push dword PTR OFFSET obszar	; adres obszaru pami�ci
	push dword PTR 0				; numer urz�dzenia (0 dla klawiatury)
	call __read						; odczytywanie znak�w z klawiatury
									; (dwa znaki podkre�lenia przed read)
	add esp, 12						; usuni�cie parametr�w ze stosu
									; bie��ca warto�� przekszta�canej liczby przechowywana jest
									; w rejestrze EAX; przyjmujemy 0 jako warto�� pocz�tkow�
	mov eax, 0
	mov ebx, OFFSET obszar			; adres obszaru ze znakami
pobieraj_znaki:
	mov cl, [ebx]					; pobranie kolejnej cyfry w kodzie
									; ASCII
	inc ebx							; zwi�kszenie indeksu
	cmp cl,10						; sprawdzenie czy naci�ni�to Enter
	je byl_enter					; skok, gdy naci�ni�to Enter
	sub cl, 30H						; zamiana kodu ASCII na warto�� cyfry
	movzx ecx, cl					; przechowanie warto�ci cyfry w
									; rejestrze ECX
									; mno�enie wcze�niej obliczonej warto�ci razy 10
	mul dziesiec
	add eax, ecx					; dodanie ostatnio odczytanej cyfry
	jmp pobieraj_znaki				; skok na pocz�tek p�tli
byl_enter:
									; warto�� binarna wprowadzonej liczby znajduje si� teraz w rejestrze EAX
	pop ebx
	pop ecx	
	popfd
	ret
wczytaj_dec_do_EAX ENDP


podnies_EAX_do_kwadratu PROC
	push edx

	xor edx, edx
	mov dx, ax
	mul dx
	shl edx, 16
	add eax, edx
	
	pop edx
	ret
podnies_EAX_do_kwadratu ENDP


wyswietl_EAX_hex PROC
									; wy�wietlanie zawarto�ci rejestru EAX
									; w postaci liczby szesnastkowej
	pusha							; przechowanie rejestr�w

									; rezerwacja 12 bajt�w na stosie (poprzez zmniejszenie
									; rejestru ESP) przeznaczonych na tymczasowe przechowanie
									; cyfr szesnastkowych wy�wietlanej liczby
	sub esp, 12
	mov edi, esp					; adres zarezerwowanego obszaru
									; pami�ci
									; przygotowanie konwersji
	mov ecx, 8						; liczba obieg�w p�tli konwersji
	mov esi, 0						; indeks pocz�tkowy u�ywany przy
									; zapisie cyfr
									; p�tla konwersji
ptl3hex:
									; przesuni�cie cykliczne (obr�t) rejestru EAX o 4 bity w lewo
									; w szczeg�lno�ci, w pierwszym obiegu p�tli bity nr 31 - 28
									; rejestru EAX zostan� przesuni�te na pozycje 3 - 0
	rol eax, 4
									; wyodr�bnienie 4 najm�odszych bit�w i odczytanie z tablicy
									; 'dekoder' odpowiadaj�cej im cyfry w zapisie szesnastkowym
	mov ebx, eax					; kopiowanie EAX do EBX
	and ebx, 0000000FH				; zerowanie bit�w 31 - 4 rej.EBX
	mov dl, dekoder[ebx]			; pobranie cyfry z tablicy
									; przes�anie cyfry do obszaru roboczego
	mov [edi+esi], dl
	inc esi							; inkrementacja modyfikatora
	loop ptl3hex					; sterowanie p�tl�

									; wpisanie znaku nowego wiersza przed i po cyfrach
	mov byte PTR [edi+8], 'h'
	mov byte PTR [edi+9], 10

	mov ebx, 0

zero2spaces:
	cmp byte PTR [edi+ebx], '0'
	jne wyswietlhex
	mov byte PTR [edi+ebx], ' '
	inc ebx
	cmp ebx, 7
	jb zero2spaces
	
wyswietlhex:
									; wy�wietlenie przygotowanych cyfr
	push 10							; 8 cyfr + 2 znaki nowego wiersza
	push edi						; adres obszaru roboczego
	push 1							; nr urz�dzenia (tu: ekran)
	call __write					; wy�wietlenie
									; usuni�cie ze stosu 24 bajt�w, w tym 12 bajt�w zapisanych
									; przez 3 rozkazy push przed rozkazem call
									; i 12 bajt�w zarezerwowanych na pocz�tku podprogramu
	add esp, 24

	popa							; odtworzenie rejestr�w
	ret								; powr�t z podprogramu
wyswietl_EAX_hex ENDP


wczytaj_do_EAX_hex PROC
									; wczytywanie liczby szesnastkowej z klawiatury � liczba po
									; konwersji na posta� binarn� zostaje wpisana do rejestru EAX
									; po wprowadzeniu ostatniej cyfry nale�y nacisn�� klawisz
									; Enter
	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ebp
									; rezerwacja 12 bajt�w na stosie przeznaczonych na tymczasowe
									; przechowanie cyfr szesnastkowych wy�wietlanej liczby
	sub esp, 12						; rezerwacja poprzez zmniejszenie ESP
	mov esi, esp					; adres zarezerwowanego obszaru pami�ci
	push dword PTR 10				; max ilo�� znak�w wczytyw. liczby
	push esi						; adres obszaru pami�ci
	push dword PTR 0				; numer urz�dzenia (0 dla klawiatury)
	call __read						; odczytywanie znak�w z klawiatury
									; (dwa znaki podkre�lenia przed read)
	add esp, 12						; usuni�cie parametr�w ze stosu
	mov eax, 0						; dotychczas uzyskany wynik
pocz_konw:
	mov dl, [esi]					; pobranie kolejnego bajtu
	inc esi							; inkrementacja indeksu
	cmp dl, 10						; sprawdzenie czy naci�ni�to Enter
	je gotowe						; skok do ko�ca podprogramu
									; sprawdzenie czy wprowadzony znak jest cyfr� 0, 1, 2 , ..., 9
	cmp dl, '0'
	jb pocz_konw					; inny znak jest ignorowany
	cmp dl, '9'
	ja sprawdzaj_dalej
	sub dl, '0'						; zamiana kodu ASCII na warto�� cyfry
dopisz:
	shl eax, 4						; przesuni�cie logiczne w lewo o 4 bity
	or al, dl						; dopisanie utworzonego kodu 4-bitowego
									; na 4 ostatnie bity rejestru EAX
	jmp pocz_konw					; skok na pocz�tek p�tli konwersji
									; sprawdzenie czy wprowadzony znak jest cyfr� A, B, ..., F
sprawdzaj_dalej:
	cmp dl, 'A'
	jb pocz_konw					; inny znak jest ignorowany
	cmp dl, 'F'
	ja sprawdzaj_dalej2
	sub dl, 'A' - 10				; wyznaczenie kodu binarnego
	jmp dopisz
									; sprawdzenie czy wprowadzony znak jest cyfr� a, b, ..., f
sprawdzaj_dalej2:
	cmp dl, 'a'
	jb pocz_konw					; inny znak jest ignorowany
	cmp dl, 'f'
	ja pocz_konw					; inny znak jest ignorowany
	sub dl, 'a' - 10
	jmp dopisz
gotowe:
									; zwolnienie zarezerwowanego obszaru pami�ci
	add esp, 12
	pop ebp
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
wczytaj_do_EAX_hex ENDP



_main PROC
	call wczytaj_do_EAX_hex
	call wyswietl_EAX_dec

push 0
call _ExitProcess@4
_main ENDP

END
```

# Read and write in 13 symbols system
## x86 MASM

The goal of this exercise was to create a program that would read a number in 13 symbols system and convert it to decimal. The number was to be input as a string and the result was to be printed to the console.

```asm
.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC
public _main

.data
obszar		db 12 dup (?)
trzynascie	dd 13					; mno�nik
dekoder		db '0123456789ABC'
czy_minus	db 0

.code

wczytaj_do_EAX_trzynastkowo PROC
	pushfd
	push ecx	
	push ebx
	push edx
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
	mov dl, obszar
	cmp dl, '-'
	jne pobieraj_znaki
	inc ebx
pobieraj_znaki:
	mov cl, [ebx]					; pobranie kolejnej cyfry w kodzie
									; ASCII
	inc ebx							; zwi�kszenie indeksu
	cmp cl, 10						; sprawdzenie czy naci�ni�to Enter
	je byl_enter					; skok, gdy naci�ni�to Enter
	cmp cl, '9'
	ja znaki_duze
	sub cl, 30H						; zamiana kodu ASCII na warto�� cyfry
	jmp dalej

znaki_duze:
	cmp cl, 'A'
	jb byl_enter
	cmp cl, 'C'
	ja znaki_male
	sub cl, 'A' - 10
	jmp dalej

znaki_male:
	cmp cl, 'a'
	jb byl_enter
	cmp cl, 'c'
	ja byl_enter
	sub cl, 'a' - 10

dalej:
	movzx ecx, cl					; przechowanie warto�ci cyfry w
									; rejestrze ECX
									; mno�enie wcze�niej obliczonej warto�ci razy 10
	mul trzynascie
	add eax, ecx					; dodanie ostatnio odczytanej cyfry
	jmp pobieraj_znaki				; skok na pocz�tek p�tli
byl_enter:
	mov bl, obszar
	cmp bl, '-'
	jne dalej2
	neg eax

dalej2:
									; warto�� binarna wprowadzonej liczby znajduje si� teraz w rejestrze EAX
	pop edx
	pop ebx
	pop ecx	
	popfd
	ret
wczytaj_do_EAX_trzynastkowo ENDP


wyswietl_EAX_trzynastkowo PROC
	pusha

	sub esp, 12
	mov edi, esp
	add edi, 11
	mov ecx, 0
	
	or eax, eax
	jns konwersja
	mov czy_minus, 1
	neg eax


konwersja:
	xor edx, edx					; zerowanie starszej cz�ci dzielnej
	mov ebx, trzynascie				; dzielnik r�wny 20
	div ebx							; dzielenie przez 20, reszta w EDX,
									; iloraz w EAX
	dec edi							; zmniejszenie indeksu
	mov bl, dekoder[edx]
	mov [edi], bl					; zapisanie cyfry w kodzie ASCII
	inc ecx
	or eax, eax						; sprawdzenie czy iloraz = 0
	jne konwersja					; skok, gdy iloraz niezerowy

									; wype�nienie pozosta�ych bajt�w spacjami i wpisanie
									; znak�w nowego wiersza

	mov byte PTR [edi+ecx], 0AH		; kod nowego wiersza
	add ecx, 1
	mov dl, czy_minus
	test czy_minus, 1
	jz wyswietl
	dec edi
	inc ecx
	mov dl, '-'
	mov [edi], dl

wyswietl:
									; wy�wietlenie cyfr na ekranie
	push dword PTR ecx				; liczba wy�wietlanych znak�w
	push dword PTR edi				; adres wy�w. obszaru
	push dword PTR 1				; numer urz�dzenia (ekran ma numer 1)
	call __write					; wy�wietlenie liczby na ekranie
	add esp, 24						; usuni�cie parametr�w ze stosu


	popa
	ret
wyswietl_EAX_trzynastkowo ENDP


_main PROC
	call wczytaj_do_EAX_trzynastkowo
	sub eax, 10
	call wyswietl_EAX_trzynastkowo

	push 0
	call _ExitProcess@4
_main ENDP

END
```

.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC
public _main

.data
obszar		db 12 dup (?)
trzynascie	dd 13					; mno¿nik
dekoder		db '0123456789ABC'
czy_minus	db 0

.code

wczytaj_do_EAX_trzynastkowo PROC
	pushfd
	push ecx	
	push ebx
	push edx
									; wczytywanie liczby dziesiêtnej z klawiatury – po
									; wprowadzeniu cyfr nale¿y nacisn¹æ klawisz Enter
									; liczba po konwersji na postaæ binarn¹ zostaje wpisana
									; do rejestru EAX
									; max iloœæ znaków wczytywanej liczby
	push dword PTR 12
	push dword PTR OFFSET obszar	; adres obszaru pamiêci
	push dword PTR 0				; numer urz¹dzenia (0 dla klawiatury)
	call __read						; odczytywanie znaków z klawiatury
									; (dwa znaki podkreœlenia przed read)
	add esp, 12						; usuniêcie parametrów ze stosu
									; bie¿¹ca wartoœæ przekszta³canej liczby przechowywana jest
									; w rejestrze EAX; przyjmujemy 0 jako wartoœæ pocz¹tkow¹
	mov eax, 0
	mov ebx, OFFSET obszar			; adres obszaru ze znakami
	mov dl, obszar
	cmp dl, '-'
	jne pobieraj_znaki
	inc ebx
pobieraj_znaki:
	mov cl, [ebx]					; pobranie kolejnej cyfry w kodzie
									; ASCII
	inc ebx							; zwiêkszenie indeksu
	cmp cl, 10						; sprawdzenie czy naciœniêto Enter
	je byl_enter					; skok, gdy naciœniêto Enter
	cmp cl, '9'
	ja znaki_duze
	sub cl, 30H						; zamiana kodu ASCII na wartoœæ cyfry
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
	movzx ecx, cl					; przechowanie wartoœci cyfry w
									; rejestrze ECX
									; mno¿enie wczeœniej obliczonej wartoœci razy 10
	mul trzynascie
	add eax, ecx					; dodanie ostatnio odczytanej cyfry
	jmp pobieraj_znaki				; skok na pocz¹tek pêtli
byl_enter:
	mov bl, obszar
	cmp bl, '-'
	jne dalej2
	neg eax

dalej2:
									; wartoœæ binarna wprowadzonej liczby znajduje siê teraz w rejestrze EAX
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
	xor edx, edx					; zerowanie starszej czêœci dzielnej
	mov ebx, trzynascie				; dzielnik równy 20
	div ebx							; dzielenie przez 20, reszta w EDX,
									; iloraz w EAX
	dec edi							; zmniejszenie indeksu
	mov bl, dekoder[edx]
	mov [edi], bl					; zapisanie cyfry w kodzie ASCII
	inc ecx
	or eax, eax						; sprawdzenie czy iloraz = 0
	jne konwersja					; skok, gdy iloraz niezerowy

									; wype³nienie pozosta³ych bajtów spacjami i wpisanie
									; znaków nowego wiersza

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
									; wyœwietlenie cyfr na ekranie
	push dword PTR ecx				; liczba wyœwietlanych znaków
	push dword PTR edi				; adres wyœw. obszaru
	push dword PTR 1				; numer urz¹dzenia (ekran ma numer 1)
	call __write					; wyœwietlenie liczby na ekranie
	add esp, 24						; usuniêcie parametrów ze stosu


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

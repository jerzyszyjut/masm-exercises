.686
.model flat
extern _puts : PROC
extern _ExitProcess@4 : PROC
public _main

.code
wyswietl_EAX_dec_glupie PROC
	push ebp
	mov ebp, esp
	pusha
	mov ebx, [ebp+4]
	mov eax, [ebx]

	sub esp, 12
	mov edi, esp
	add edi, 11
	mov ecx, 0
	mov ebx, 10						; dzielnik równy 10

konwersja:
	xor edx, edx					; zerowanie starszej czêœci dzielnej
	div ebx							; dzielenie przez 10, reszta w EDX,
									; iloraz w EAX
	add dl, 30H						; zamiana reszty z dzielenia na kod
									; ASCII
	dec edi							; zmniejszenie indeksu
	mov [edi],dl					; zapisanie cyfry w kodzie ASCII
	inc ecx
	or eax, eax						; sprawdzenie czy iloraz = 0
	jne konwersja					; skok, gdy iloraz niezerowy

									; wype³nienie pozosta³ych bajtów spacjami i wpisanie
									; znaków nowego wiersza

wyswietl:
	mov byte PTR [edi+ecx], 0AH		; kod nowego wiersza
	add ecx, 1
	mov byte PTR [edi+ecx], 0		; null
	add ecx, 1
									; wyœwietlenie cyfr na ekranie
	push dword PTR edi				; adres wyœw. obszaru
	call _puts						; wyœwietlenie liczby na ekranie
	add esp, 16						; usuniêcie parametrów ze stosu

	popa
	pop ebp
	ret
wyswietl_EAX_dec_glupie ENDP

suma_liczb PROC
	push ebp
	mov ebp, esp
	pusha
	xor eax, eax

	mov ebx, [ebp+4]
	add eax, [ebx]

	add ebx, 4
	mov ax, [ebx]

	add ebx, 2
	mov ax, [ebx]

	popa
	pop ebp
	add dword ptr [esp], 8
	ret
suma_liczb ENDP

_main PROC
	call suma_liczb
	dd 5
	dw 8
	dw 1
	nop

	push 0
	call _ExitProcess@4
_main ENDP

END

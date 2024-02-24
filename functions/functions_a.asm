.686
.model flat

public _miesz2float
public _pomnoz32
public _float_razy_float
public _plus_jeden_double
public _roznica
public _kopia_tablicy
public _komunikat
public _szukaj_elem_min
public _szyfruj

extern _malloc : proc

.code
_miesz2float PROC
	push ebp
	mov ebp, esp
	pushad

	mov eax, [ebp+8]
	bsr edx, eax
	mov ecx, 32
	sub ecx, edx
	shl eax, cl
	shr eax, 9

	add edx, 127-8
	shl edx, 23
	or eax, edx

	push eax
	fld dword ptr [esp]
	pop eax

	popad
	pop ebp
	ret
_miesz2float ENDP

_pomnoz32 PROC
	push ebp
	mov ebp, esp
	pushad

	mov eax, [ebp+8]
	add eax, 02800000h

	push eax
	fld dword ptr [esp]
	pop eax

	popad
	pop ebp
	ret
_pomnoz32 ENDP

_float_razy_float PROC
	push ebp
	mov ebp, esp
	pushad

	mov eax, [ebp+8]
	mov ebx, [ebp+12]
	; Zaladowanie argumentow na eax i ebx
	and eax, 007FFFFFh
	and ebx, 007FFFFFh
	; Wyciagniecie mantysy
	bts eax, 23
	bts ebx, 23
	; Ustawienie jawne jedynki

	xor edx, edx

	mul ebx
	mov ecx, 23
	
petla:
	shr edx, 1
	rcr eax, 1
	loop petla ; edx -> eax -> wyrzuca

	bsr ecx, eax
	sub ecx, 23
	cmp ecx, 0
	jle dalej
	shr eax, cl
	jmp dalej_2

dalej:
	xor ecx, ecx

dalej_2:
	btr eax, 23

	mov ebx, [ebp+8]
	and ebx, 7F800000h
	shr ebx, 23
	sub ebx, 127
	add ecx, ebx

	mov ebx, [ebp+12]
	and ebx, 7F800000h
	shr ebx, 23
	add ecx, ebx
	
	shl ecx, 23

	or eax, ecx
	push eax
	fld dword ptr [esp]
	pop eax

	popad
	pop ebp
	ret
_float_razy_float ENDP

_plus_jeden_double PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi
	; odczytanie liczby w formacie double
	mov eax, [ebp+8]
	mov edx, [ebp+12]
	; wpisanie 1 na pozycji o wadze 2^0 mantysy do EDI:ESI
	mov esi, 0
	mov edi, 00100000h
	; wyodrebnienie wykladnika (11 bitow)
	mov ebx, edx
	shr ebx, 20
	; obliczenie wykladnika
	sub ebx, 1023
	; zerowanie wykladnika i bitu znaku
	and edx, 000FFFFFh
	; dopisanie niejawnej
	or edx, 00100000h

	; edx:eax liczba z czescia niejawna
	; edi:esi jedynka na odpowiednim miejscu
	; ebx - wykladnik
	
	; w EDX:EAX jest tylko mantysa teraz
	; EDI nowa liczba powoli
	mov ecx, ebx ; EBX = wykladnik 2^EBX
	cmp ecx, 20 ; jezeli mniejszy to zmiesci sie tylko w EDI
	jle dalej
przesun:
	shr edi, 1
	rcr esi, 1
	loop przesun
	jmp niePrzesun
dalej:
	shr edi, cl
niePrzesun:
	btr edx, 20 ; pozbycie sie niejawnej jedynki
	add edx, edi
	bt edx, 20 ; jezeli jest tam 1 to korekcja
	jnc bezKorekcji
	btr edx, 20
	shr edx, 1
	add ebx, 1
bezKorekcji:
	add eax, esi ; w EAX mlodsza czesc
	add ebx, 1023 ; tworzymy wykladnik
	shl ebx, 20
	or edx, ebx ; w EDX starsza czesc

	; zaladowanie wartosci na wierzcholek stosu koprocesora
	push edx
	push eax
	fld qword ptr [esp]
	add esp, 8
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_plus_jeden_double ENDP

_roznica PROC
	push ebp
	mov ebp, esp
	push ebx

	mov eax, [ebp+8]
	mov eax, [eax]
	mov ebx, [ebp+12]
	mov ebx, [ebx]
	mov ebx, [ebx]

	sub eax, ebx

	pop ebx
	pop ebp
	ret
_roznica ENDP

_kopia_tablicy PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi

	mov esi, [ebp+8]
	
	mov eax, [ebp+12]
	lea eax, [eax*4]
	push eax
	call _malloc
	cmp eax, 0
	add esp, 4
	je koniec

	mov edi, eax

	mov ecx, [ebp+12]
	xor ebx, ebx
petla:
	mov eax, [esi+ebx*4]
	bt eax, 0
	sbb edx, edx
	not edx
	and edx, eax
	mov [edi+ebx*4], edx
	inc ebx
	loop petla

	mov eax, edi

koniec:
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_kopia_tablicy ENDP

_komunikat PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi

	mov esi, [ebp+8]
	xor ebx, ebx
liczenie:
	mov al, [esi+ebx]
	inc ebx
	cmp al, 0
	jne liczenie

	push ebx
	call _malloc
	add esp, 4
	cmp eax, 0
	je koniec
	mov edi, eax

	dec ebx
	mov ecx, ebx
	xor ebx, ebx
przepisywanie:
	mov al, [esi+ebx]
	mov [edi+ebx], al
	inc ebx
	loop przepisywanie
	mov [edi+ebx], dword ptr 'd��B'
	add ebx, 4
	mov [edi+ebx], byte ptr '.'
	inc ebx
	mov [edi+ebx], byte ptr 0

	mov eax, edi

koniec:
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_komunikat ENDP

_szukaj_elem_min PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi

	mov esi, [ebp+8]
	mov ecx, [ebp+12]
	mov eax, esi
	xor ebx, ebx
petla:
	mov edx, [esi+ebx*4]
	cmp edx, [eax]
	jge dalej
	lea eax, [esi+ebx*4]
dalej:
	inc ebx
	loop petla

	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_szukaj_elem_min ENDP

kolejna_liczba_szyfruj PROC
	push ebx
	push ecx

	xor ebx, ebx
	xor ecx, ecx
	bt eax, 30
	rcl ebx, 1
	bt eax, 31
	rcl ecx, 1
	xor ebx, ecx
	shr ebx, 1
	rcl eax, 1

	pop ecx
	pop ebx
	ret
kolejna_liczba_szyfruj ENDP

_szyfruj PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi

	mov esi, [ebp+8]
	mov eax, 52525252H
	
	xor ebx, ebx
petla:
	mov dl, [esi+ebx]
	cmp dl, 0
	je koniec
	xor dl, al
	mov [esi+ebx], dl
	call kolejna_liczba_szyfruj
	inc ebx
	jmp petla

koniec:
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_szyfruj ENDP

END

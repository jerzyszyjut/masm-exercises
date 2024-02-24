.686
.model flat
extern _malloc : PROC

.code
_Matmul PROC
	push ebp
	mov ebp, esp
	sub esp, 4
	push ebx
	push esi
	push edi

	mov eax, [ebp+16]
	lea eax, [eax*4]
	mov ebx, [ebp+24]
	mul ebx
	push eax
	call _malloc				; rezerwuj� k * 4 * m bajt�w na wynikow� tablic� float�w (st�d *4)
	add esp, 4

	mov edi, eax				; edi		-> adres wynikowej tablicy
								; [ebp+8]	-> adres tablicy A
								; [ebp+12]	-> adres tablicy B
	xor esi, esi				; esi		-> indeks w wynikowej tablicy
	mov ecx, [ebp+16]	
	mov eax, [ebp+24]
	mul ecx				
	mov	[ebp-4], eax			; ebp-4	-> liczba okrazen 2 petli = k*m
	mov ecx, [ebp+24]			; ecx = m	-> liczba okrazen wewnetrznej petli

petla_2:
	xor edx, edx
	mov ecx, [ebp+24]	
	mov eax, esi
	div ecx						; dzielimy przez m
								; eax - indeks pierwszej tablicy l razy mniejszy	(esi//m)
								; edx - indeks drugiej tablicy		(esi%m)
	push edx
	mov ecx, [ebp+20]
	mul ecx
	pop edx						; eax - poprawny indeks pierwszej tablicy (pomo�ony przez l)
	mov ecx, [ebp+20]	 
	fldz						; przed p�tl� sumuj�c� wrzucam wyraz neutralny na stos (dla dodawania to 0)
petla_1:
	mov ebx, [ebp+8]
	fld qword ptr [ebx+eax*8]	; adres pierwszej tablicy + obecny indeks pierwszej tablicy
	mov ebx, [ebp+12]
	fild dword ptr [ebx+edx*4]	; adres drugiej tablicy + obecny indeks drugiej tablicy
	fmulp						; mno�� odpowiedni� kom�rk� pierwszej tablicy i drugiej
	faddp						; dodaj� do poprzedniej sumy mno�onych wierszy i kolumn

	add eax, 1					; zwi�kszam indeks pierwszej tablicy o 1
	add edx, [ebp+24]			; zwi�kszam indeks drugiej tablicy o m
	loop petla_1
	fstp dword ptr [edi+esi*4]	; po sumowaniu przemno�e� kom�rek wiersza i kolumny wrzucam wynik do tablicy wynikowej
	inc esi						; zwi�kszam indeks wynikowej tablicy
	mov edx, [ebp-4]			
	dec edx						
	mov [ebp-4], edx			; dekrementuje licznik drugiej petli zapisywany w pamieci
	jnz petla_2
	
	mov eax, edi				; wrzucam adres wynikowej tablicy do eax (warto�� zwracana przez funkcj�)
	pop edi
	pop esi
	pop ebx
	add esp, 4
	pop ebp
	ret
_Matmul ENDP
END

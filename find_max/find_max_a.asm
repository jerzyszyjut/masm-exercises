public szukaj64_max
.code
szukaj64_max PROC
	push rbx				; przechowanie rejestrów
	push rsi
	mov rbx, rcx			; adres tablicy
	mov rcx, rdx			; liczba elementów tablicy
	mov rsi, 0				; indeks bie¿¹cy w tablicy
							; w rejestrze RAX przechowywany bêdzie najwiêkszy dotychczas
							; znaleziony element tablicy - na razie przyjmujemy, ¿e jest
							; to pierwszy element tablicy
	mov rax, [rbx + rsi*8]
							; zmniejszenie o 1 liczby obiegów pêtli, bo iloœæ porównañ
							; jest mniejsza o 1 od iloœci elementów tablicy
	dec rcx
ptl: 
	inc rsi					; inkrementacja indeksu
							; porównanie najwiêkszego, dotychczas znalezionego elementu
							; tablicy z elementem bie¿¹cym
	cmp rax, [rbx + rsi*8]
	jge dalej				; skok, gdy element bie¿¹cy jest
							; niewiêkszy od dotychczas znalezionego
							; przypadek, gdy element bie¿¹cy jest wiêkszy
							; od dotychczas znalezionego
	mov rax, [rbx+rsi*8]
dalej: 
	loop ptl				; organizacja pêtli
							; obliczona wartoœæ maksymalna pozostaje w rejestrze RAX
							; i bêdzie wykorzystana przez kod programu napisany w jêzyku C
	pop rsi
	pop rbx
	ret
szukaj64_max ENDP
END

# UTF-8 to UTF-16 conversion
## x86 MASM

The goal of this exercise was to create a program that would convert a string from UTF-8 to UTF-16. 

```asm
.686
.model flat
public _main

extern _MessageBoxA@16 : proc
extern _MessageBoxW@16 : proc
extern _ExitProcess@4 : proc

.data
tekst	db 41H,6cH,61H,0
		db 'A','l','a',0
		db 'Ala',0
tytul  db 'Tytul',0
tytulW  dw 'T','y','t','u','l',0
tekstW  db 0,41H,0,6cH,0,61H,0,0

bufor       db    50H, 6FH, 0C5H, 82H, 0C4H, 85H, 63H, 7AH, 65H, 6EH, 69H, 61H, 20H
            db    0F0H, 9FH, 9AH, 82H   ; parow�z
            db    20H, 20H, 6BH, 6FH, 6CH, 65H, 6AH, 6FH, 77H, 6FH, 20H
            db    0E2H, 80H, 93H ; p�pauza
            db    20H, 61H, 75H, 74H, 6FH, 62H, 75H, 73H, 6FH, 77H, 65H, 20H, 20H
            db    0F0H,  9FH,  9AH,  8CH ; autobus
wynik       dw    48 dup (0),0 

.code
_main PROC

	 mov ecx,offset wynik - offset bufor ; liczba bajt�w do interpretacji
	 mov esi,0   ; ustawienie indeks�w odczytu i zapisu na 0
	 mov edi,0

ptl: mov al,bufor[esi]
	 add esi,1		; wskaznik odczytu na nastepny znak
	 cmp al,7fh			 ; sprawdzenie pierwszego bajtu czy nale�y 
						 ; do jednobajtowego znaku utf-8 (przedzia� 00-7fh)
						 	;przedzia�y
	;0-7Fh - znak utf8 jednobajtowy
	;80 - BFh - kolejny bajt w znaku 2,3,4 bajtowym
	;C0 - DFh - znak utf8 dwubajtowy
	;E0 - EFh - znak utf8 trzybajtowy
	;F0 - F7h - znak utf8 czterobajtowy
	 ja znak_utf8_wielobajtowy
	 mov ah,0			 ; ustawiamy starsz� cz�� 16 bitowego s�owa na 0
	 mov wynik[edi],ax   ; wpisujemy znak utf-16 do bufora wynikowego
	 add edi,2			 ; wskaznik zapisu na nast�py znak utf-16
	;mov ebx, offset wynik
	 ;mov [ebx+edi],ax
	 ;mov wynik[edi],al
	 ;mov wynik[edi+1],ah

	 jmp koniec

znak_utf8_wielobajtowy:
;rozr�nienie zakresu, a tym samym liczby bajt�w sk�adaj�cych si� na znak
;utf-8. Uwaga: zak�adamy, �e uk�ad znak�w w buforze jest prawid�owy.
	  cmp al,0E0h
	  jb dwubajtowy
	  cmp al,0f0h
	  jb trzybajtowy
	  jmp czterobajtowy

dwubajtowy:
	; 110x xxxx  10xx xxxx   - al, ah
	mov ah,bufor[esi]	; odczyt bajtu 10xx xxxx nale��cego do znaku
	add esi,1   ;przesuni�cie indeksu odczytu
	xchg al,ah  ; ax = 110x xxxx  10xx xxxx 
	shl al,2	; ax = 110x xxxx  xxxx xx00
	shl ax,3	; ax = xxxx  xxxx xxx0 0000
	shr ax,5	; ax = 0000 0xxx xxxx xxxx - znak w utf16
	mov wynik[edi], ax	; zapis znaku do bufora wyj�ciowego
	add edi,2	;zwi�kszenie indeksu zapisu
	sub  ecx,1  ; zmniejszenie liczby bajt�w do przetwarzania
	jmp koniec
trzybajtowy:
	; 0000 0000 1110 xxxx  10xx xxxx 10xx xxxx   - eax
	movzx eax,al	; konwersja byte na dword, wyzerowanie starszych bajt�w eax
	shl eax,16	    ; przesuni�cie bit�w 7-0 na pozycj� 23-16
	mov al,bufor[esi+1] ; odczytanie dw�ch pozosta�ych bajt�w nale��cych do znaku utf-8
	mov ah,bufor[esi]   ; zachowuj�c w�a�ciw� kolejno��
	add esi,2
	; inna wersja powy�szego kodu
	;mov ax,word ptr bufor[esi]
	;ror ax,8
	;xchg al,ah
	
	;pozbycie si� niepotrzebnych prefiks�w i scalenie istotnych bit�w
	; 0000 0000 1110 xxxx  10xx xxxx 10xx xxxx 
	shl al,2	; 0000 0000 1110 xxxx  10xx xxxx xxxx xx00
	shl ax,2	; 0000 0000 1110 xxxx  xxxx xxxx xxxx 0000
	shr eax,4	; 0000 0000 0000 1110  xxxx xxxx xxxx xxxx 
	mov wynik[edi],ax
	add edi,2
	sub  ecx,2  ; zmniejszenie liczby bajt�w do przetwarzania
	jmp koniec
czterobajtowy:
	; znaki utf-8 czterobajtowe w formacie
	; 1111 0xxx  10xx xxxx 10xx xxxx  10xx xxxx 
	;pocz�tkowo zajmujemy si� najstarsz� cze�ci�
	mov ah,bufor[esi]
	add esi,1
	xchg ah,al
	shl al,2 ; 1111 0xxx  xxxx xx00
	shl ax,5
	shr ax,7 ; 0000 000x xxxx xxxx
	;przesuwamy wyznaczone istotne bity na pozycj� 24-16
	shl eax,16 ; 0000 000x xxxx xxxx 0000 0000 0000 0000
	;i przekszta�cmy dwie m�odsze cz�ci znaku
	mov al,bufor[esi+1]
	mov ah,bufor[esi]
	add esi,2 ; 0000 000x xxxx xxxx 10xx xxxx  10xx xxxx 
	shl al,2	; 0000 000x xxxx xxxx 10xx xxxx  xxxx xx00
	shl ax,2	; 0000 000x xxxx xxxx xxxx  xxxx xxxx 0000
	shr eax,4	; 0000 0000 000x xxxx xxxx xxxx  xxxx xxxx   U+
	; w eax mamy punkt kodowy U+
	
	;konwersja U+ na dwuznakowy kod UTF-16
	;rozbicie na grupy 10 bitowe i dopisanie prefiks�w
	;110 110 xxxxx xxxxx  110 111 xxxxx xxxxx
	sub eax,10000H
	rol eax,6 ;0000 0xxx xxxx xxxx  xxxx xxxx xx00 0000
	ror ax,6 ; 0000 0xxx xxxx xxxx  0000 00xx xxxx xxxx
	add eax,0d800dc00h ;1101 10xx xxxx xxxx  1101 11xx xxxx xxxx
	ror eax, 16
	mov DWORD PTR wynik[edi],eax
	add edi,4
	sub ecx,3  ; zmniejszenie liczby bajt�w do przetwarzania

koniec:
	 sub ecx,1	; p�tla rozkazowa loop ma za ma�y zasi�g
	 cmp ecx,0	; wymieniona na rozkaz skoku warunkowego
	 jne ptl
	 ;loop ptl

	
	push 4  ; przyciski
	push OFFSET tytulW
	push OFFSET wynik
	push 0  ; hwnd
	call _MessageBoxW@16

	push 0
	call _ExitProcess@4

_main ENDP
END
```

.686
.model flat
public _szukaj_max

.code
_szukaj_max PROC
	push ebp
	mov ebp, esp
						; ebp stare = [ebp]
						; slad = [ebp+4]
						; a = [ebp+8]
						; b = [ebp+12]
						; c = [ebp+16]
						; d = [ebp+20]
	mov eax, [ebp+8]
	cmp eax, [ebp+12] 
	jae a_wieksze_b		; a >= b
	jb b_wieksze_a		; a < b

a_wieksze_b:
	cmp eax, [ebp+16] 
	jae a_wieksze_c		; a >= c
	jb c_wieksze_a		; a < c
	
a_wieksze_c:
	cmp eax, [ebp+20] 
	jae powrot			; a >= d
	mov eax, [ebp+20] 
	jmp powrot			; a < d

b_wieksze_a:
	mov eax, [ebp+12]
	cmp eax, [ebp+16] 
	jae b_wieksze_c		; b >= c
	jb c_wieksze_b		; b < c

b_wieksze_c:
	cmp eax, [ebp+16] 
	jae powrot			; b >= d
	mov eax, [ebp+20] 
	jmp powrot			; b < d

c_wieksze_b:
	mov eax, [ebp+16]
	cmp eax, [ebp+20] 
	jae powrot			; c >= d
	mov eax, [ebp+20]
	jb powrot			; c < d

c_wieksze_a:
	mov eax, [ebp+16]
	cmp eax, [ebp+20] 
	jae powrot			; c >= d
	mov eax, [ebp+20]
	jb powrot			; c < d

powrot:
	pop ebp
	ret

_szukaj_max ENDP
END

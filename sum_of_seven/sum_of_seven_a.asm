public suma_siedmiu_liczb
.code
suma_siedmiu_liczb PROC
	push rbp
	mov rbp, rsp

	xor rax, rax
	mov [rbp+16], rcx
	mov [rbp+24], rdx
	mov [rbp+32], r8
	mov [rbp+40], r9
	mov rcx, 7
	mov rdx, 16

ptl:
	add rax, [rbp+rdx]
	add rdx, 8
	loop ptl

	pop rbp
	ret
suma_siedmiu_liczb ENDP
END

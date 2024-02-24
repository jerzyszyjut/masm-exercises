.686
.model flat

.code 
exp PROC
	fldl2e
	fmulp st(1), st(0)
	fst st(1)
	frndint
	fsub st(1), st(0)
	fxch
	f2xm1
	fld1
	faddp st(1), st(0) 
	fscale
	fstp st(1)
	ret
exp ENDP

_main PROC
	finit
	fld1
	call exp
	nop
_main ENDP

END

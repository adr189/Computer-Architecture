; reservar area do display
displays: resb 4	
; vetor com configuracao de displays para cada algarismo (0-F)
v_display: db 00111111b, 00000110b, 01011011b, 01001111b,01100110b,01101101b, 01111101b, 00000111b, 01111111b, 01101111b,01110111b, 01111100b, 00111001b, 01011110b, 01111001b, 01110001b
error: db 01111011b
unknown: db 01010011b
vars: db 0h, 0h, 0h, 0h
	
	xor ebx, ebx
read_display:
	xor eax, eax	
	mov al, [displays+ebx]
	mov ecx, -1 
proximo:
	inc ecx
	cmp [ecx+v_display], al
	jne proximo
	mov [vars+ebx], cl
	inc ebx
	cmp ebx, 3
	jne read_display
	

	xor edx, edx
routine:
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	mov al, [vars+2]
	mov bl, [vars+1]
	mov cl, [vars]

cmp_m1:	
	and al, 1
	cmp al, 1
	je cmp_m2
	and cl, 1
	and bl, 1
	cmp cl, bl
	je write_unknown
	jmp write_error

cmp_m2:
	and bl, 1
	cmp bl, 0
	je write_y
	and cl, 1 ; else
	cmp cl, 0
	je write_error
	jmp write_unknown

write_error:
	mov al, [error]
	mov [displays+edx], al
	jmp step
	
write_unknown:
	mov al, [unknown]
	mov [displays+edx], al
	jmp step
	
write_y:
	and cl, 1
	mov al, [v_display+ecx]
	mov [displays+edx], al
	jmp step

step:	
	shr [vars], 1
	inc edx
	cmp edx, 4
	jne routine
	jmp end
	
end:
	nop
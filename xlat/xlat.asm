section     .text
global      _start

_start:
	mov 	rbx, trans
  	mov		rdx, message
	mov 	rcx, 0

loop:
	mov		rax, qword [rdx + rcx]
	xlat
  
	push rax
	push rbx

	push rcx
	push rdx

	push rdi
	push rsi
  
	mov rbx, rax
	mov rax, 1
	mov rdi, 1
	mov [buffer], rbx
	mov rsi, buffer
	mov rdx, 1
	syscall
  
	pop rsi
	pop rdi

	pop rdx
	pop rcx

	pop rbx
	pop rax

	inc rcx

	cmp rcx, str_len
	jne loop


    mov     rax, 0x3c
    mov rdi, 0
    syscall
   

section     .data

message: db 'Hello world!'
str_len  equ $ - message
buffer: db 'a'

trans:
	times 33 db 20h
	db '!"#$%&', 27h, '()*+,-./0123456789:;<=>?@'
	db 'abcdefghijklmnopqrstuvwxyz'
	db '[\]^_`'
	db 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
	db '{|}~', 20h

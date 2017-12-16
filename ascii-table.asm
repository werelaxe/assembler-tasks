section     .text
global      _start

_start:
	mov 	rbx, trans
	mov 	cl, 0

loop:
	mov dl, cl
	and dl, 15
	cmp dl, 0
	jne notprint

	mov al, 10
	push rbx     ; print \n
	push rcx  
	mov [buffer], al
	mov rax, 1
	mov rdi, 1
	mov rsi, buffer
	mov rdx, 1
	syscall
	pop rcx
	pop rbx


notprint:
	mov	  al, cl
	xlat
  
	push rbx  ; print current symbol
	push rcx  
	mov [buffer], al
	mov rax, 1
	mov rdi, 1
	mov rsi, buffer
	mov rdx, 1
	syscall
	pop rcx
	pop rbx

	mov al, 32
	push rbx  ; print space
	push rcx
	mov [buffer], al
	mov rax, 1
	mov rdi, 1
	mov rsi, buffer
	mov rdx, 1
	syscall  
	pop rcx
	pop rbx


	inc cl
	cmp cl, 0
	jne loop

	mov al, 10
	push rbx     ; print \n
	push rcx  
	mov [buffer], al
	mov rax, 1
	mov rdi, 1
	mov rsi, buffer
	mov rdx, 1
	syscall

    mov     rax, 0x3c
    mov rdi, 0
    syscall
   

section     .data

message: db 'Hello world!'
str_len  equ $ - message
buffer: db 'a'

trans:
	times 32 db '.'
	db ' !"#$%&', 27h, '()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~.'
	times 128 db '.'

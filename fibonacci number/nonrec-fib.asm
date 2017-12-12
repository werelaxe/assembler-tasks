section     .text
global      _start

_start:
	mov rbx, 1
	push rbx
	push rbx

	mov rcx, 11
	sub rcx, 2

count_loop:
	pop rax
	pop rbx
	add rax, rbx
	push rax
	push rbx

	dec rcx
	cmp rcx, 0
	jne count_loop

	pop rcx
	pop rcx

	push 0

prepare_to_print_count_loop:
	mov rax, rcx
	mov rdx, 0
	mov rbx, 10
	idiv rbx
	add rdx, 48
	push rdx
	mov rcx, rax
	cmp rcx, 0
	je print_count_loop
	jmp prepare_to_print_count_loop

print_count_loop:
	pop rdx
	cmp rdx, 0
	je exit_label

	mov [buffer], rdx
	mov rsi, buffer
	mov rax, 1
	mov rdx, 1
	mov rdx, 1
	syscall
	jmp print_count_loop


exit_label:
    mov     rax, 0x3c
    mov rdi, 0
    syscall
   

section     .data

buffer: db 0

section     .text
global      _start

_start:
	mov rcx, 821
	push 0

count_loop:
	mov rax, rcx
	mov rdx, 0
	mov rbx, 10
	idiv rbx
	add rdx, 48
	push rdx
	mov rcx, rax
	cmp rcx, 0
	je print_loop
	jmp count_loop

print_loop:
	pop rdx
	cmp rdx, 0
	je exit_label

	mov [buffer], rdx
	mov rsi, buffer
	mov rax, 1
	mov rdx, 1
	mov rdx, 1
	syscall
	jmp print_loop


exit_label
    mov     rax, 0x3c
    mov rdi, 0
    syscall
   

section     .data

buffer: db 0

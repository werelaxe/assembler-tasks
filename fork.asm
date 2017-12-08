section     .text
global      _start


_start:
	mov rax, 57
	syscall

	cmp rax, 0
	jne exit_label

	mov rsi, message
	mov rax, 1
	mov rdx, str_len
	mov rdi, 1
	syscall


exit_label:
    mov     rax, 0x3c
    mov rdi, 0
    syscall
   

section     .data

buffer: db 0

message: db 'Hello child process!', 0xA
str_len equ $ - message

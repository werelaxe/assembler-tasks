section     .text
global      _start
extern func
	
_start:
	mov rax, 2
	call func
	mov rsi, mess
	mov rdx, 13
	mov rdi, 1
	syscall

exit_label:
    mov     rax, 0x3c
    mov rdi, 0
    syscall


section     .data

buffer: db 0

mess: db 'Hello world!', 10
ln: db $ - mess

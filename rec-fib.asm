section     .text
global      _start

fib:
	mov rbx, [rsp + 8]  ; put n into rbx
	cmp rbx, 1  ; if rbx <= 1
	jle base    ; return 1
	dec rbx     ; rbx = n - 1

	push 0     ; useless local space
	push rbx   ; put argument n - 1 to stack
	call fib  ; now in rax fib(n - 1)
	pop rbx    ; get argument n - 1 to rbx
	pop rdi    ; useless local space

	dec rbx  ; rbx = n - 2
	
	push rax  ; save fib(n - 1) in local space
	push rbx  ; put argument n - 2 to stack
	call fib ; now in rax fib(n - 2)
	pop rbx   ; put argument n - 2 to rbx
	pop rcx   ; put fib(n - 2) to rcx

	add rax, rcx ; rax = fib(n - 2) + fib(n - 1)
	jmp end

base:
	mov rax, 1
	jmp end

end:
	ret


_start:
	mov rax, 10
	dec rax
	push rax
	call fib
	add rsp, 8
	
	mov rcx, rax  ; put value into rcx for print
	push 0        ; add terminate symbol for print

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


exit_label:
    mov     rax, 0x3c
    mov rdi, 0
    syscall
   

section     .data

buffer: db 0

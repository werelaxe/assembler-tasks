section .text
global _start


draw_pixel:
	push rax
	push rbx
	push rcx
	push rdx
	mov rdx, 3
	mul rdx
	mov rcx, rax
	mov rax, rbx
	mov rdx, 1800
	mul rdx
	add rax, rcx

	cmp rax, 1080000
	jg end_draw_pixel
	cmp rax, 0
	jl end_draw_pixel
    
    ;mov [data + rax], byte 255
    mov [data + rax + 1], byte 255
    ;mov [data + rax + 2], byte 255

end_draw_pixel:
	pop rdx
	pop rcx
    pop rbx
    pop rax
    ret


draw_line_by_dy:

	mov [delta_x], rdi
	mov qword [delta_y], rsi
	fild qword [delta_y]
	fstp qword [delta_y]

	fild qword [delta_x]
	fdiv qword [delta_y]
	fstp qword [k]

	mov rdi, rsi
	mov rsi, 0

draw_by_dy_lp:
	mov [buffer], rsi
	fild qword [buffer]
	fmul qword [k]
	fistp qword [buffer]

	push rax
	push rbx
	
	add rbx, rsi
	mov rdx, qword [buffer]
	add rdx, rax
	mov rax, rdx
	call draw_pixel
	
	pop rbx
	pop rax
	
	inc rsi
	cmp rdi, rsi
	jne draw_by_dy_lp

	ret


draw_line_by_dx:
	mov [delta_x], rdi
	mov qword [delta_y], rsi
	fild qword [delta_x]
	fstp qword [delta_x]

	fild qword [delta_y]
	fdiv qword [delta_x]
	fstp qword [k]

	mov rsi, rdi
	inc rsi
	mov rdi, 0

draw_by_dx_lp:

	mov [buffer], rdi
	fild qword [buffer]
	fmul qword [k]
	fistp qword [buffer]

	push rax
	push rbx
	
	add rax, rdi
	mov rdx, qword [buffer]
	add rdx, rbx
	mov rbx, rdx
	call draw_pixel
	
	pop rbx
	pop rax
	
	inc rdi
	cmp rdi, rsi
	jne draw_by_dx_lp
	ret

draw_line:
	push rax
	push rbx
	push rcx
	push rdx
	push rdi
	push rsi

	cmp rbx, 599
	jge cond0
	jmp check_for_limit

cond0:
	cmp rdx, 0
	jl end_draw_line

check_for_limit:
	cmp rbx, 0
	jle cond1
	jmp check_for_adj

cond1:
	cmp rdx, 599
	jge end_draw_line


check_for_adj:
	cmp rbx, rdx
	jg adj

	cmp rax, rcx
	jg adj

	jmp count_deltas

adj:
	push rbx
	mov rbx, rdx
	pop rdx

	push rax
	mov rax, rcx
	pop rcx
	jmp count_deltas


count_deltas:
	mov rdi, rcx
	sub rdi, rax

	mov rsi, rdx
	sub rsi, rbx

	cmp rdi, rsi
	jg by_dx
	jmp by_dy

by_dx:
	call draw_line_by_dx
	jmp end_draw_line

by_dy:
	call draw_line_by_dy
	jmp end_draw_line


end_draw_line:	
	pop rsi
	pop rdi
	pop rdx
	pop rcx
	pop rbx
	pop rax
	ret

compute_function:
	mov [float_x], rdi
	fild qword [float_x]
	fdiv qword [float_y]
	;fadd qword [one]
	fcos
	
	fdivr qword [float_b]

	fadd qword [float_z]
	fistp qword [float_x]
	mov rsi, qword [float_x]
	ret


_start:

write_to_file:
    mov rdi, filename  ; open file
    mov rsi, 0102o     ; create if not exists
    mov rdx, 0666o     ; rights
    mov rax, 2
    syscall

    mov [fd], rax     ; write header
    mov rdx, 15       ;message length
    mov rsi, msg       ;message to write
    mov rdi, [fd]      ;file descriptor
    mov rax, 1         ;system call number (sys_write)
    syscall            ;call kernel


	mov rdi, 0
	call compute_function
	push rdi
	push rsi
	inc rdi

lp:
	call compute_function
	pop rbx
	pop rax
	mov rcx, rdi
	mov rdx, rsi

	call draw_line

	push rcx
	push rdx

	inc rdi
	cmp rdi, 600

	jne lp

end_drawing:
    mov rdx, 1080000   ; write data
    mov rsi, data       ;message to write
    mov rdi, [fd]      ;file descriptor
    mov rax, 1         ;system call number (sys_write)
    syscall            ;call kernel

    mov rdi, [fd]
    mov rax, 3         ;sys_close
    syscall

    mov rax, 60        ;system call number (sys_exit)
    syscall            ;call kernel

section .data
    msg db 'P6', 0xa, '600 600', 0xa, '255', 0xa
    filename db 'test.ppm', 0
    lenfilename equ $ - filename
    fd dq 0

    data: times 1080000 db 0
	float_x: dq 2.0
	float_y dq 50.0
	float_z dq 300.0
	float_a dq 1.0
	float_b dq 30.0
	one dq 1.0
	buffer dq 1.0
	k dq 0.5
	delta_x dq 1.0
	delta_y dq 1.0

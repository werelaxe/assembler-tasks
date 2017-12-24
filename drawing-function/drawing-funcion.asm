section .text
global _start


draw_ofst_xxel:
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
	jg end_draw_ofst_xxel
	cmp rax, 0
	jl end_draw_ofst_xxel
    
    ;mov [data + rax], byte 255
    mov [data + rax + 1], byte 255
    ;mov [data + rax + 2], byte 255

end_draw_ofst_xxel:
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
	call draw_ofst_xxel
	
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
	call draw_ofst_xxel
	
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

	cmp rbx, 601
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
	cmp rdx, 601
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
	fdiv qword [float_y] ; scaling by x, 50
	fsub qword [float_a] ; cetralizing
	fadd qword [ofst_x]  ; add offset by x from task
	fcos
	fdivr qword [one]    
	fsub qword [ofst_y]  ; add offset by y from task
	fmul qword [float_b] ; scaling by y, 30
	fadd qword [float_z] ; offset by y, 300
	fistp qword [float_x]
	mov rsi, qword [float_x]
	ret

; x: 345
; y: 315

draw_one:
	mov rax, 5
	add rax, rdi
	mov rbx, 0
	add rbx, rsi
	mov rcx, 5
	add rcx, rdi
	mov rdx, 10
	add rdx, rsi
	call draw_line

	mov rax, 0
	add rax, rdi
	mov rbx, 5
	add rbx, rsi
	mov rcx, 5
	add rcx, rdi
	mov rdx, 0
	add rdx, rsi
	call draw_line

	mov rax, 2
	add rax, rdi
	mov rbx, 10
	add rbx, rsi
	mov rcx, 8
	add rcx, rdi
	mov rdx, 10
	add rdx, rsi
	call draw_line
	ret


draw_zero:
	mov rax, 0
	add rax, rdi
	mov rbx, 3
	add rbx, rsi
	mov rcx, 2
	add rcx, rdi
	mov rdx, 0
	add rdx, rsi
	call draw_line
	
	mov rax, 2
	add rax, rdi
	mov rbx, 0
	add rbx, rsi
	mov rcx, 5
	add rcx, rdi
	mov rdx, 0
	add rdx, rsi
	call draw_line
	
	mov rax, 5
	add rax, rdi
	mov rbx, 0
	add rbx, rsi
	mov rcx, 7
	add rcx, rdi
	mov rdx, 3
	add rdx, rsi
	call draw_line
	
	mov rax, 7
	add rax, rdi
	mov rbx, 3
	add rbx, rsi
	mov rcx, 7
	add rcx, rdi
	mov rdx, 8
	add rdx, rsi
	call draw_line
	
	mov rax, 5
	add rax, rdi
	mov rbx, 11
	add rbx, rsi
	mov rcx, 7
	add rcx, rdi
	mov rdx, 8
	add rdx, rsi
	call draw_line
	
	mov rax, 5
	add rax, rdi
	mov rbx, 11
	add rbx, rsi
	mov rcx, 2
	add rcx, rdi
	mov rdx, 11
	add rdx, rsi
	call draw_line
	
	mov rax, 2
	add rax, rdi
	mov rbx, 11
	add rbx, rsi
	mov rcx, 0
	add rcx, rdi
	mov rdx, 8
	add rdx, rsi
	call draw_line
	
	mov rax, 0
	add rax, rdi
	mov rbx, 8
	add rbx, rsi
	mov rcx, 0
	add rcx, rdi
	mov rdx, 3
	add rdx, rsi
	call draw_line
	
	ret

_start:
	mov rax, 300
	mov rbx, 0
	mov rcx, 300
	mov rdx, 600
	call draw_line

	mov rax, 0
	mov rbx, 300
	mov rcx, 600
	mov rdx, 300
	call draw_line

	mov rdi, 345
	mov rsi, 310
	call draw_one

	mov rdi, 285
	mov rsi, 265
	call draw_one

	mov rdi, 287
	mov rsi, 305
	call draw_zero

	mov rdi, -5

dx_marks_lp:
	push rdi
	mov rsi, rdi
	mov rdi, 50
	
	mov rax, rsi
	mul rdi
	add rax, 300
	mov rdi, rax

	mov rax, rdi
	mov rbx, 295
	mov rcx, rdi
	mov rdx, 305
	call draw_line
	pop rdi
	inc rdi
	cmp rdi, 6
	jne dx_marks_lp

	mov rdi, -9

dy_marks_lp:
	push rdi
	mov rsi, rdi
	mov rdi, 30
	
	mov rax, rsi
	mul rdi
	add rax, 300
	mov rdi, rax

	mov rax, 295
	mov rbx, rdi
	mov rcx, 305
	mov rdx, rdi
	call draw_line
	pop rdi
	inc rdi
	cmp rdi, 10
	jne dy_marks_lp





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
	float_a dq 6.0
	float_b dq 30.0
	one dq 1.0
	buffer dq 1.0
	k dq 0.5
	delta_x dq 1.0
	delta_y dq 1.0
	ofst_x dq 4.7123
	ofst_y dq 1.5

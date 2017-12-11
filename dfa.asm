section     .text
global      _start


detectarg:
	mov rax, [rsp + 8]
	mov rcx, 0
	mov rdx, 0      ; bit means "We have seen a minus"

detectingloop:
	mov bl, [rax + rcx]

	cmp rbx, 61  ; =
	je argisvalue

	cmp rbx, 45
	jne isnotaminus
	mov rdx, 1      ; Now we have seen a minus

isnotaminus:
	cmp rbx, 0
	je finaldetecting

  	inc rcx
  	jmp detectingloop

finaldetecting:
	cmp rdx, 1
	je argiskey
	jmp argispar

argisvalue:
	mov rax, 0
	jmp detectend

argispar:
	mov rax, 2
	jmp detectend

argiskey:
	mov rax, 1
	jmp detectend

detectend:
  	ret


printstring:
	mov rax, [rsp + 8]
	mov rcx, 0

printloop:
	mov bl, [rax + rcx]
	cmp rbx, 0
	je printend

	push rcx
	push rax

	mov [buffer], rbx
	mov     rsi, buffer
  	mov     rax, 1
  	mov     rdi, 1
	mov     rdx, 1
  	syscall

  	pop rax
  	pop rcx
  	inc rcx
  	jmp printloop

printend:
	;mov rbx, 10
	;mov [buffer], rbx
	;mov rsi, buffer
  	;mov rax, 1
  	;mov rdi, 1
	;mov rdx, 1
  	;syscall
  	ret


_start:
	mov rax, [rsp]
	push rax

argsloop:
	pop rax      ; get current index of args
	cmp rax, 1   ; if it equals to program path
	je e         ; then end
	dec rax      ; dec current index of args
	push rax     ; remember it with stack

	mov rax, [rsp + 8 * (rax + 2)]

	push rax          ; put current pointer to stack
	call printstring  ; as printing param

	;pop rax           ; restore argument
	call detectarg     ; detect type of arg
	pop rdx            ; release memory stack

	cmp rax, 0
	je isvalue

	cmp rax, 1
	je iskey

	cmp rax, 2
	je isparam

isvalue:
	mov rsi, valuemessage
  	mov rax, 1
  	mov rdi, 1
	mov rdx, 10

spec:
  	syscall
	jmp argsloop
	
iskey:
	mov rsi, keymessage
  	mov rax, 1
  	mov rdi, 1
	mov rdx, 15
  	syscall
	jmp argsloop
	
isparam:
	mov rsi, parammessage
  	mov rax, 1
  	mov rdi, 1
	mov rdx, 14
  	syscall
	jmp argsloop

e:
    mov     rax, 0x3c
    mov rdi, 0
    syscall


section     .data

buffer: db 0

keymessage: db '        == key', 10
parammessage: db ' == parameter', 10
valuemessage: db ' == value', 10

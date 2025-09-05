.intel_syntax noprefix

section .data
    port    dw 0x1F90
    af      dw 2
    inaddr  dd 0
    padding dd 0, 0
    http_200 db "HTTP/1.1 200 OK",13,10,"Content-Type: text/html",13,10,"Content-Length: %d",13,10,13,10,0
    http_404 db "HTTP/1.1 404 Not Found",13,10,"Content-Type: text/html",13,10,"Content-Length: 13",13,10,13,10,"404 Not Found",0
    default_file db "index.html",0

section .bss
    client_fd   resq 1
    request_buf resb 512
    file_buf    resb 4096
    file_path   resb 256
    response_buf resb 512

section .text
.global _start

_start:
    mov rax, 41
    mov rdi, 2
    mov rsi, 1
    xor rdx, rdx
    syscall
    cmp rax, 0
    jl exit_error
    mov r12, rax

    mov rax, 49
    mov rdi, r12
    lea rsi, [port]
    mov rdx, 16
    syscall
    cmp rax, 0
    jl exit_error

    mov rax, 50
    mov rdi, r12
    mov rsi, 10
    syscall
    cmp rax, 0
    jl exit_error

main_loop:
    mov rax, 43
    mov rdi, r12
    xor rsi, rsi
    xor rdx, rdx
    syscall
    cmp rax, 0
    jl main_loop
    mov r13, rax

    mov rax, 57
    syscall
    cmp rax, 0
    jl main_loop
    je child_process

    mov rax, 3
    mov rdi, r13
    syscall
    jmp main_loop

child_process:
    mov rax, 0
    mov rdi, r13
    lea rsi, [request_buf]
    mov rdx, 512
    syscall
    cmp rax, 0
    jle close_client

    mov byte [request_buf + rax], 0

    lea rsi, [request_buf]
    mov rdi, rsi
    mov rcx, rax
    mov al, ' '
    cld
    repne scasb
    cmp byte [rdi], '/'
    jne send_404
    inc rdi
    lea rsi, [file_path]
    mov rcx, 255
copy_path:
    mov al, [rdi]
    cmp al, ' '
    je path_done
    cmp al, 0
    je path_done
    mov [rsi], al
    inc rsi
    inc rdi
    loop copy_path
path_done:
    mov byte [rsi], 0
    cmp byte [file_path], 0
    jne open_file
    lea rsi, [default_file]
    lea rdi, [file_path]
    mov rcx, 11
    rep movsb

open_file:
    mov rax, 2
    lea rdi, [file_path]
    mov rsi, 0
    syscall
    cmp rax, 0
    jl send_404
    mov r14, rax

    mov rax, 0
    mov rdi, r14
    lea rsi, [file_buf]
    mov rdx, 4096
    syscall
    mov r15, rax
    mov rax, 3
    mov rdi, r14
    syscall
    cmp r15, 0
    jle send_404

    lea rdi, [response_buf]
    lea rsi, [http_200]
    mov rcx, 47
    rep movsb
    mov rax, r15
    call format_number
    mov byte [rdi], 13
    inc rdi
    mov byte [rdi], 10
    inc rdi
    mov byte [rdi], 0
    mov r14, rdi

    mov rax, 1
    mov rdi, r13
    lea rsi, [response_buf]
    mov rdx, r14
    sub rdx, rsi
    syscall

    mov rax, 1
    mov rdi, r13
    lea rsi, [file_buf]
    mov rdx, r15
    syscall
    jmp close_client

send_404:
    mov rax, 1
    mov rdi, r13
    lea rsi, [http_404]
    mov rdx, 60
    syscall

close_client:
    mov rax, 3
    mov rdi, r13
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall

format_number:
    push rbx
    mov rbx, 10
    xor rcx, rcx
    mov r8, rax
convert_loop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    push rdx
    inc rcx
    test rax, rax
    jnz convert_loop
write_digits:
    pop rax
    mov [rdi], al
    inc rdi
    loop write_digits
    pop rbx
    ret

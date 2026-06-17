default rel

section .data
    choose_msg db "Choose option: 1-Factorial, 2-Average: ", 0
    choose_msg_len equ $ - choose_msg

    error_option db "You entered a value that is out of range. Try again: ", 0
    error_option_len equ $ - error_option

section .bss
    chosen_option resb 1

    fact_input resb 1
    fact_result resb 6
    fact_result_len resb 1
    temp_reg resb 4

section .text
    global _start
    extern _factorial

_start:
    ; Get chosen option - after verification
    call print_choose_msg
    call get_chosen_option

    mov al, byte [chosen_option]
    cmp al, '1'
    je go_factorial
    ;jmp calc_average

go_factorial:
    call _factorial
    jmp _exit


print_choose_msg:
    mov eax, 4  ; sys_write
    mov ebx, 1  ; stdout
    mov ecx, choose_msg
    mov edx, choose_msg_len
    int 0x80

    ret


get_chosen_option:
    mov eax, 3  ; sys_read
    mov ebx, 0  ; stdin
    mov ecx, chosen_option
    mov edx, 2
    int 0x80

    jmp verify_chosen_option

    ret

verify_chosen_option:
    mov al, byte [chosen_option]
    cmp al, '1'
    jb print_error_option

    cmp al, '2'
    ja print_error_option

    ret

print_error_option:
    mov eax, 4  ; sys_write
    mov ebx, 1  ; stdout
    mov ecx, error_option
    mov edx, error_option_len
    int 0x80

    jmp get_chosen_option

    ret
    



_exit:
    mov eax, 1      ; System call number for sys_exit
    mov ebx, 0      ; Exit code status (0 = success)
    int 0x80        ; Invoke the kernel
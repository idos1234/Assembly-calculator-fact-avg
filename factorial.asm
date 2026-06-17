default rel

section .data
    fact_input_msg db "Enter a number (0-9): ", 0
    fact_input_msg_len equ $ - fact_input_msg
    fact_result_msg db "! = ", 0
    fact_result_msg_len equ $ - fact_result_msg

    newline db 10

    zero_result db '1'

section .bss
    fact_input resb 2
    fact_result resb 6
    temp_reg resb 4

section .text
    global _factorial

_factorial:

    mov eax, 4  ; sys_write
    mov ebx, 1  ; stdout
    mov ecx, fact_input_msg
    mov edx, fact_input_msg_len
    int 0x80

    mov eax, 3  ; sys_read
    mov ebx, 0  ; stdin
    mov ecx, fact_input
    mov edx, 2
    int 0x80

    mov eax, 4  ; sys_write
    mov ebx, 1  ; stdout
    mov ecx, fact_input
    mov edx, 1
    int 0x80

    ; Calculation
    cmp byte [fact_input], '0'
    je fact_zero

    xor eax, eax
    mov al, byte [fact_input]
    sub al, '0'

    push eax
    call calc_fact
    add esp, 4
    

    ; Convert the result to string
    push fact_result
    push eax
    call number_to_string
    add esp, 8

    mov esi, eax
    mov edi, edx

    mov eax, 4  ; sys_write
    mov ebx, 1  ; stdout
    mov ecx, fact_result_msg
    mov edx, fact_result_msg_len
    int 0x80

    mov eax, 4  ; sys_write
    mov ebx, 1  ; stdout
    mov ecx, esi
    mov edx, edi

    int 0x80
    

    mov eax, 4  ; sys_write
    mov ebx, 1  ; stdout
    mov ecx, newline
    mov edx, 1
    int 0x80

    ret

calc_fact:
    ; Open Stack_Frame
    push ebp
    mov ebp, esp

    ; Save the registers
    push ecx
    push edx

    ; Calculation
    mov ecx, [ebp + 8]
    mov eax, 1

    fact_loop:
        mul ecx
        loop fact_loop

    ; Load the registers
    pop edx
    pop ecx

    ; Close Stack_frame
    mov esp, ebp
    pop ebp

    ret

number_to_string:
    ; Open Stack_Frame
    push ebp
    mov ebp, esp

    ; Save the registers
    push ecx
    push ebx
    push edi

    ; Convert
    mov eax, [ebp + 8]
    mov ebx, 10          ; Divide by 10 to get the next digit
    xor ecx, ecx
    count_digits_loop:
        xor edx, edx         ; Clear edx for division
        div ebx              ; Divide eax by 10 to get the next digit
        
        inc ecx              ; increase the digit count

        cmp eax, 0
        jnz count_digits_loop
    
    mov [temp_reg], ecx
    mov eax, [ebp + 8]
    mov ebx, 10
    mov edi, [ebp + 12]
    add edi, 5
    num_to_string_loop:
        xor edx, edx
        div ebx

        add dl, '0'
        mov [edi], dl
        dec edi

        loop num_to_string_loop

    ; Save output
    lea eax, [edi + 1]
    mov edx, [temp_reg]

    ; Load registers
    pop edi
    pop ebx
    pop ecx

    ; Close Stack_frame
    mov esp, ebp
    pop ebp

    ret

fact_zero:
    mov eax, 4  ; sys_write
    mov ebx, 1  ; stdout
    mov ecx, fact_result_msg
    mov edx, fact_result_msg_len
    int 0x80


    mov eax, 4  ; sys_write
    mov ebx, 1  ; stdout
    mov ecx, zero_result
    mov edx, 1
    int 0x80

    mov eax, 4  ; sys_write
    mov ebx, 1  ; stdout
    mov ecx, newline
    mov edx, 1
    int 0x80

    ret
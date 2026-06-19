section .data
    avg_input_msg_1 db "Please enter the first number: ", 0
    avg_input_msg_1_len equ $ - avg_input_msg_1
    avg_input_msg_2 db "Please enter the second number: ", 0
    avg_input_msg_2_len equ $ - avg_input_msg_2

    output_msg db "The average is: ", 0
    output_msg_len equ $ - output_msg

    newline db 10
    dot db "."

section .bss
    number_1 resb 5
    number_2 resb 5

    avg_result_str resb 4
    temp_reg resb 4


section .text
    global _average

_average:
    ; Print the first msg
    mov eax, 4
    mov ebx, 1
    mov ecx, avg_input_msg_1
    mov edx, avg_input_msg_1_len
    int 0x80

    ; Input the first number
    mov eax, 3
    mov ebx, 0
    mov ecx, number_1
    mov edx, 5
    int 0x80

    ; Print the second msg
    mov eax, 4
    mov ebx, 1
    mov ecx, avg_input_msg_2
    mov edx, avg_input_msg_2_len
    int 0x80

    ; Input the second number
    mov eax, 3
    mov ebx, 0
    mov ecx, number_2
    mov edx, 5
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, output_msg
    mov edx, output_msg_len
    int 0x80

    ; Convert first string to number
    push number_1
    call string_to_number
    add esp, 4

    mov edx, eax

    ; Convert second string to number
    push number_2
    call string_to_number
    add esp, 4

    ; Calculation
    push eax
    push edx
    call calc_average
    add esp, 8

    ; Convert result to string
    push edx

    push avg_result_str
    push eax
    call number_to_string_2
    add esp, 8

    mov ecx, eax
    mov eax, 4
    mov ebx, 1
    mov edx, 4
    int 0x80

    ;Print '.'
    mov eax, 4
    mov ebx, 1
    mov ecx, dot
    mov edx, 1
    int 0x80

    pop ecx
    imul ecx, 5
    add ecx, '0'
    mov [temp_reg], ecx

    mov eax, 4
    mov ebx, 1
    mov ecx, temp_reg
    mov edx, 1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ret


    
calc_average:
    ; Open Stack Frame
    push ebp
    mov ebp, esp

    ; Save the registers
    push ebx

    ; Sum the numbers
    mov eax, [ebp + 8]
    add eax, [ebp + 12]

    ; Divide by 2
    mov ebx, 2
    xor edx, edx
    div ebx

    ; Load the registers
    pop ebx

    ; Close the stack frame
    mov esp, ebp
    pop ebp

    ret


string_to_number:
    ; Open Stack Frame
    push ebp
    mov ebp, esp

    ; Save the registers
    push edi
    push ecx
    push ebx

    xor eax, eax
    mov edi, [ebp + 8]

    mov ecx, 4
    convert1_loop:
        xor ebx, ebx
        mov bl, [edi]
        cmp bl, 10 ;Whether it reached '\n'
        je end_loop

        sub bl, '0'

        imul eax, 10
        add eax, ebx

        inc edi
        dec ecx
        cmp ecx, 0
        jne convert1_loop

    
    end_loop:

    ; Load the registers
    pop ebx
    pop ecx
    pop edi

    ; Close the stack frame
    mov esp, ebp
    pop ebp

    ret

number_to_string_2:
    ; Open Stack Frame
    push ebp
    mov ebp, esp

    ; Save the registers
    push ebx
    push ecx
    push edx
    push edi


    ; Count how many digits the result contains
    mov eax, [ebp + 8]
    xor ecx, ecx
    mov ebx, 10

    count_digits_loop_2:
        xor edx, edx
        div ebx

        inc ecx

        cmp eax, 0
        jne count_digits_loop_2

    
    mov edi, [ebp + 12]
    add edi, 3
    mov eax, [ebp + 8]

    convert2_loop:
        xor edx, edx
        div ebx

        add dl, '0'
        mov [edi], dl
        dec edi

        loop convert2_loop

    ; Save result
    lea eax, [edi + 1]


    ; Load registers
    pop edi
    pop edx
    pop ecx
    pop ebx

    ; Close Stack_frame
    mov esp, ebp
    pop ebp

    ret

        
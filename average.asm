section .data
    avg_input_msg_1 db "Please enter the first number: ", 0
    avg_input_msg_1_len equ $ - avg_input_msg_1
    avg_input_msg_2 db "Please enter the second number: ", 0
    avg_input_msg_2_len equ $ - avg_input_msg_2

section .bss
    number_1 resb 4
    number_2 resb 4


section .text
    global _average

_average:
    ; Print the first msg
    mov eax, 4
    mov ebx, 1
    mov ecx, avg_input_msg_1
    mov edx, avg_input_msg_1_len
    int 0x80

    
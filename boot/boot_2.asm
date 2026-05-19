[BITS 16]
org 0x8000             
start:
    cli
    mov ax, cs
    mov ds, ax        

    mov si, success_msg;1
    call print
    
    call enable_a20
    lgdt [gdt_descriptor_32]
    cli
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp dword 0x08:protected_entry


enable_a20:
    in al, 0x92
    or al, 00000010b
    out 0x92, al
    ret


gdt_start_32:
gdt_null_32:				;Нулевой дескриптор обязательный, все по 0
	dq 0
gdt_code_32:				;Сегмент кода, 32 бита, база = 0, лимит 4 гб. 
	dw 0xFFFF			;Лимит (0 - 15)
	dw 0x0000			;база (0 - 15)
	db 0x00			;база (16 - 23)
	db 10011010b			;Байт доступа
	db 11001111b			;Флаги и лимит (16 – 19)
	db 0x00			;база (24 – 31)

gdt_data_32:				;Сегмент данных, 32 бита, лимит 4 гб. 
	dw 0xFFFF			;Лимит (0 - 15)
	dw 0x0000			;база (0 - 15)
	db 0x00			;база (16 - 23)
	db 10010010b			;Байт доступа (RW = 1, E = 0)
	db 11001111b			;Флаги и лимит (16 – 19)
	db 0x00			;база (24 - 31)
gdt_end_32:
gdt_descriptor_32:
	dw gdt_end_32 - gdt_start_32 - 1
	dd gdt_start_32


print:
    mov ah, 0x0E
loop:
    lodsb
    test al, al
    jz end
    int 0x10
    jmp loop
end:
    ret


success_msg db "Success boot 2", 13, 10, 0








[BITS 32]
protected_entry:
    cli
    ; init segments
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x90000

    mov esi, succes_32bit
    call print_32

    lgdt [gdt_descriptor_64]
    enable_pae

    hlt



print_32:
    mov edi, 0xB8000
loop_print:
    lodsb
    test al, al
    jz end_pr
    mov byte [edi], al
    mov byte [edi+1], 0x07
    add edi, 2
    jmp loop_print
end_pr:
    ret



gdt_start_64:
gdt_null_64:				    ;Нулевой дескриптор обязательный, все по 0
	dq 0
gdt_code_64:				    ;Сегмент кода, 32 бита, база = 0, лимит 4 гб. 
	dw 0x0000			    ;Лимит (0 - 15)                         Игнорируется
	dw 0x0000			    ;база (0 - 15)
	db 0x00			        ;база (16 - 23)
	db 10011010b			;Байт доступа
	db 00100000b			;Флаги и лимит (16 – 19)
	db 0x00			        ;база (24 – 31)

gdt_data_64:				    ;Сегмент данных, 32 бита, лимит 4 гб. 
	dw 0x0000			    ;Лимит (0 - 15)                         Игнорируется
	dw 0x0000			    ;база (0 - 15)
	db 0x00			        ;база (16 - 23)
	db 10010010b			;Байт доступа (RW = 1, E = 0)
	db 00000000b			;Флаги и лимит (16 – 19)                 Игнорируется
	db 0x00			        ;база (24 - 31)
gdt_end_64:
gdt_descriptor_64:
	dw gdt_end - gdt_start - 1
	dd gdt_start


enable_pae:
    mov eax, cr4
    or eax, 1 << 5          ;PAE = bit 5
    mov cr4, eax



succes_32bit db "Hello 32bit world !!",0
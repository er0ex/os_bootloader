[BITS 16]
org 0x7c00


start:
	cli 	

	mov ax, cs
	mov ds, ax

	mov si, hello_string
	call print

	call reset
	call read_disk
	hlt



reset:
	mov ah, 0
	mov dl, 0
	int 0x13
	jc error
	ret


read_disk:
	mov ax, 0x0000
	mov es, ax
	mov bx, 0x8000

	mov ah, 0x02
	mov al, 4
	mov ch, 0
	mov cl, 2
	mov dh, 0
	mov dl, 0x80
	int 0x13
	jc error
	jmp 0x0000:0x8000
	ret


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

error:
	mov si, error_msg
	call print
	ret


hello_string db "Success boot 1",13,10,0
error_msg db "Error",13,10,0

times 510 - ($ - $$) db 0

dw 0xAA55 


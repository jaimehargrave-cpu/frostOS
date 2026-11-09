.section .multiboot,"a"
.balign 8
multiboot_header:
    .long 0xe85250d6
    .long 0
    .long multiboot_header_end - multiboot_header
    .long -(0xe85250d6 + (multiboot_header_end - multiboot_header))
    .short 0
    .short 0
    .long 8
multiboot_header_end:

.section .text.boot,"ax"
.code32
.global _start
.type _start, @function
_start:
    cli
    movl $boot_stack_top, %esp

    # Identity-map the first GiB with 2 MiB pages.
    movl $page_directory, %edi
    xorl %ecx, %ecx
1:
    movl %ecx, %eax
    shll $21, %eax
    orl $0x83, %eax
    movl %eax, (%edi, %ecx, 8)
    movl $0, 4(%edi, %ecx, 8)
    incl %ecx
    cmpl $512, %ecx
    jne 1b

    movl $page_directory, %eax
    movl %eax, %cr3

    movl %cr4, %eax
    orl $0x620, %eax
    movl %eax, %cr4

    movl $0xc0000080, %ecx
    rdmsr
    orl $0x100, %eax
    wrmsr

    movl %cr0, %eax
    orl $0x80000000, %eax
    movl %eax, %cr0

    lgdt gdt64_pointer
    ljmp $0x08, $long_mode_start

.code64
long_mode_start:
    movw $0x10, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %ss
    movq $boot_stack_top, %rsp
    xorq %rbp, %rbp
    call frostos_main
2:
    hlt
    jmp 2b

.section .rodata
.balign 8
gdt64:
    .quad 0x0000000000000000
    .quad 0x00af9a000000ffff
    .quad 0x00cf92000000ffff
gdt64_end:
gdt64_pointer:
    .word gdt64_end - gdt64 - 1
    .long gdt64

.section .bss
.balign 4096
page_directory:
    .skip 4096
.balign 16
boot_stack_bottom:
    .skip 16384
boot_stack_top:

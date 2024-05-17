.set ALIGN, 1<<0
.set MEMINFO, 1<<1
.set FLAGS, ALIGN | MEMINFO
.set MAGIC, 0x1BADB002
.set CHECKSUM, -(MAGIC + FLAGS)

# Create the multiboot header
.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

# Set the stack up, as GRUB doesn't define a stack
.section .bss
.align 16
stack_bottom:
    .skip 16384 # 16 KiB
stack_top:

# Entry point to the kernel.
.section .text
.global _start
.type _start, @function
_start:
    # Grub has loaded us into 32bit pmode.
    # Set up the stack
    mov $stack_top, %esp

    # Init processor state stuff here if needed.

    # Enter the high-level kernel.
    call kernel_main
    cli
1:  hlt
    jmp 1b

# Set the size of _start to here minus it's start. Useful for debugging.
.size _start, . - _start

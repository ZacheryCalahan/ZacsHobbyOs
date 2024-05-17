ENTRY(_start)

SECTIONS 
{
    /* 2M is decided to be a safe start offset. */
    . = 2M;


    /* Multiboot header, and the text section */
    .text BLOCK(4K) :ALIGN(4K)
    {
        *(.multiboot)
        *(.text)
    }

    /* Read only data */
    .rodata BLOCK(4K) : ALIGN(4K)
    {
        *(.rodata)
    }

    /* Read-write data (initialized) */
    .data BLOCK(4K) : ALIGN(4K)
    {
        *(.data)
    }

    /* Read-write data (uninitted) and stack */
    .bss BLOCK(4K) : ALIGN(4K)
    {
        *(COMMON)
        *(.bss)
    }
}
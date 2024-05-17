C_SOURCES = $(wildcard kernel/*.c kernel/drivers/*.c)
HEADERS = $(wildcard kernel/*.h kernel/drivers/*.h)
OBJ = $(C_SOURCES:.c=.o)

CC = /home/zac/opt/cross/bin/i686-elf-gcc
AS = /home/zac/opt/cross/bin/i686-elf-as
CFLAGS = -std=gnu99 -ffreestanding -O2 -Wall -Wextra
LFLAGS = -ffreestanding -O2 -nostdlib

grubrun: os-image.iso
	qemu-system-i386 -cdrom os-image.iso

run: os-image.bin
	qemu-system-i386 -kernel os-image.bin

os-image.iso: os-image.bin
	mkdir -p isodir/boot/grub
	cp os-image.bin isodir/boot/os-image.bin
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o os-image.iso isodir
	

os-image.bin: ${OBJ} boot/boot.o
	$(CC) -T linker.ld -o os-image.bin $(LFLAGS) ${OBJ} boot/boot.o -lgcc
	$(info ${OBJ})


# Wildcard Rules

%.o: %.c $(HEADERS)
	$(CC) -o $@ -c $^ $(CFLAGS)

%.o: %.s
	$(AS) $^ -o $@

# Phony stuffs.
.PHONY: clean
clean:
	@rm -rf *.bin *.iso *.o os-image.iso
	@rm -rf kernel/*.o boot/*.o
	@rm -rf isodir
OS: bootsec.bin fileTable.bin kernel.bin
	cat bootsec.bin fileTable.bin kernel.bin > os.bin

bootsec.bin:
	nasm ../src/asm/bootsec.asm -f bin -o bootsec.bin

fileTable.bin:
	nasm ../src/asm/fileTable.asm -f bin -o fileTable.bin

kernel.bin:
	nasm ../src/asm/kernel.asm -f bin -o kernel.bin

clean:
	rm *.bin

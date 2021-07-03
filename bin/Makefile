OS: bootsec.bin kernel.bin fileTable.bin calculator.bin
	cat bootsec.bin kernel.bin fileTable.bin calculator.bin > os.bin

bootsec.bin:
	nasm ../src/asm/bootsec.asm -f bin -o bootsec.bin

fileTable.bin:
	nasm ../src/asm/fileTable.asm -f bin -o fileTable.bin

kernel.bin:
	nasm ../src/asm/kernel.asm -f bin -o kernel.bin

calculator.bin:
	nasm ../src/asm/calculator.asm -f bin -o calculator.bin

clean:
	rm *.bin

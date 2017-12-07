nasm -f elf64 $1 -o program.o
ld program.o -o program
./program
rm program
rm program.o


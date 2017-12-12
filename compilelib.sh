nasm -f elf64 program.asm -o program.o
nasm -f elf64 lib.asm -o lib.o

gcc -shared lib.o -o lib.so
gcc program.o -o program -nostdlib -L. -l:lib.so

rm program.o
rm lib.o
# rm lib.so


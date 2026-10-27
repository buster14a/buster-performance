#!/usr/bin/env bash
# Which padding object wild keeps before b.o: variants of section flags, symbols and options.
set -u
d=$(mktemp -d)
cd "$d"
printf 'int a(void){return 1;}\nint b(void);\nint main(void){return a()+b();}\n' > a.c
printf 'int b(void){return 2;}\n' > b.c
clang -O2 -c a.c b.c
pad() { printf "$2" | clang -c -x assembler - -o "pad-$1.o"; }
pad sym '\t.text\n\t.balign 16\n\t.globl buster_shift_padding\nbuster_shift_padding:\n\t.skip 4096\n'
pad retain '\t.section .text.buster_shift_padding,"axR",@progbits\n\t.balign 16\n\t.globl buster_shift_padding\nbuster_shift_padding:\n\t.skip 4096\n'
pad text-retain '\t.section .text,"axR",@progbits\n\t.balign 16\n\t.skip 4096\n'
pad nop '\t.text\n\t.balign 16\n\t.globl buster_shift_padding\nbuster_shift_padding:\n\t.fill 4096,1,0x90\n'
for linker in wild ld.lld; do
    for v in "sym -Wl,-u,buster_shift_padding" "sym -Wl,--undefined=buster_shift_padding" "sym -Wl,--require-defined=buster_shift_padding" "sym -Wl,--no-gc-sections" "retain" "nop -Wl,-u,buster_shift_padding" "sym -Wl,--export-dynamic-symbol=buster_shift_padding" "sym -Wl,-e,main,-u,buster_shift_padding"; do
        set -- $v
        out="p-$linker-$1"
        clang -no-pie --ld-path="$(command -v $linker)" "${@:2}" a.o "pad-$1.o" b.o -o "$out" 2> err.txt
        echo "$linker $v: $(nm -n "$out" 2>/dev/null | grep -E ' (a|b|main|buster_shift_padding)$' | awk '{printf "%s@%s ", $3, substr($1, 11)}') $(head -c 200 err.txt)"
    done
done
pad text-retain '\t.section .text,"axR",@progbits\n\t.balign 16\n\t.skip 4096\n' 2>&1 | head -2
rm -rf "$d"

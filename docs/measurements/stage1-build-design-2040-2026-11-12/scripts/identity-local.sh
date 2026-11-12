#!/bin/bash
# Local identity check (development machine, clang 23.1.6; no timing): the front end's unit compiled by the build's
# own command with -g, with line tables only, and without debug information; the objects' loaded sections compared.
S=/tmp/claude-0/-home-user-buster/b7674301-5589-53a9-8832-8d0d8ba7e4ba/scratchpad
cd /home/user/buster || exit 2
mapfile -t command < $S/dev/ident2/command.txt
nodebug=(); for a in "${command[@]}"; do [ "$a" = -g ] || nodebug+=("$a"); done
"${command[@]}" -o $S/dev/ident2/g.o > $S/dev/ident2/g.log 2>&1 &
"${command[@]}" -gline-tables-only -o $S/dev/ident2/g1.o > $S/dev/ident2/g1.log 2>&1 &
"${nodebug[@]}" -o $S/dev/ident2/g0.o > $S/dev/ident2/g0.log 2>&1 &
wait
{
    clang --version | head -1
    for v in g g1 g0; do
        for section in .text .rodata .data .eh_frame .data.rel.ro; do
            llvm-objcopy -O binary --only-section=$section $S/dev/ident2/$v.o $S/dev/ident2/$v.bin 2> /dev/null
            echo "$v $section $(stat -c %s $S/dev/ident2/$v.bin) $(sha256sum < $S/dev/ident2/$v.bin | cut -c1-16)"
        done
        echo "$v sections: $(llvm-readelf -S -W $S/dev/ident2/$v.o | grep -c ' PROGBITS .* AX ')"
        echo "$v all text sections: $(llvm-objcopy -O binary --only-section='.text*' $S/dev/ident2/$v.o /dev/stdout 2> /dev/null | sha256sum | cut -c1-16)"
    done
} > $S/dev/ident2/result.txt 2>&1
echo finished >> $S/dev/ident2/result.txt

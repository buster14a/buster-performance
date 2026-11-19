#!/usr/bin/env bash
set -euo pipefail
out=$1
mkdir -p "$out"
repo=$PWD
cd "$out"
cat > entry.S <<'ASSEMBLY'
.text
.globl _start
_start: mov $255,%edi
call __popcountdi2
mov %eax,%edi
mov $60,%eax
syscall
.section .note.GNU-stack,"",@progbits
ASSEMBLY
cc -c entry.S -o entry.o
ar p "$(cc -print-libgcc-file-name)" _popcountdi2.o > libgcc-popcount.o
test -s libgcc-popcount.o
for kind in ordinary unique; do
    awk -v kind="$kind" 'BEGIN {
        if (kind == "ordinary") print ".section .rodata,\042a\042,@progbits"
        else print ".section .rodata.str1.1,\042aMS\042,@progbits,1"
        for (i = 0; i < 4096; ++i) {
            printf ".globl item_%04d\nitem_%04d:\n", i, i
            if (kind == "ordinary") print ".long " i
            else printf ".asciz \042word-%04d\042\n", i
        }
        print ".section .note.GNU-stack,\042\042,@progbits"
    }' > "$kind.S"
    cc -c "$kind.S" -o "$kind.o"
done
flags=(-std=c17 -O2 -Wall -Wextra -Werror -march=x86-64-v4 -maes -mgfni -mvaes -mavx512vbmi -mavx512vbmi2 -mavx512vpopcntdq -mavx512bitalg -mavx512vnni)
cc "${flags[@]}" -c "$repo/tools/ci/vector-probe.c" -o probe.o
cc -pie probe.o -o system-probe
./system-probe > expected-probe
# Use the repository's own positive entry and supported second object verbatim.
{
    echo '#include <stdio.h>'
    sed -n '/^static const char foreign_strings_output_entry\[\]/,/^typedef struct ForeignStringsOutputFixture/{/^typedef struct /!p;}' "$repo/src/buster/compiler/foreign_strings_output_test.c"
    cat <<'C'
int main(int argc, char** argv)
{
    (void)argv;
    if (argc == 1)
        fputs(foreign_strings_output_entry, stdout);
    else
        printf("%smovabs $second_shared_repeat,%%rax\n%s", foreign_strings_output_second_begin, foreign_strings_output_second_end);
    return ferror(stdout) != 0;
}
C
} > export-fixtures.c
cc export-fixtures.c -o export-fixtures
./export-fixtures > first.S
./export-fixtures second > second.S
cc -c first.S -o first.o
cc -c second.S -o second.o
printf '%s\n' '.section .rodata.bad,"aMS",@progbits,1' '.byte 0x78,0x79' '.section .note.GNU-stack,"",@progbits' > malformed.S
cc -c malformed.S -o malformed.o
sha256sum *.o

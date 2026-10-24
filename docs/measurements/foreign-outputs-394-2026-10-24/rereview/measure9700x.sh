#!/bin/bash
# Times link-foreign's conversion (from --time) for a static glibc hello world, with and without
# --startup-applies-irelative, which skips the startup check's file lookups: medians of N runs each, interleaved.
# Reports the convert stage and its "copies" phase (foreign_link_build_end: the IFUNC refusal and the check), and the
# whole link's wall time from --time's first line.
compiler=$1
runs=${2:-41}
work=$3
mkdir -p $work && cd $work || exit 1
cat > hello.c <<'EOC'
#include <stdio.h>
#include <string.h>
int main(int argc, char** argv)
{
    char buffer[64];
    strcpy(buffer, argc > 1 ? argv[1] : "hello");
    printf("%s %zu\n", buffer, strlen(buffer));
    return 0;
}
EOC
gcc -O2 -c hello.c -o hello.o || exit 1
f() { gcc -print-file-name=$1; }
static=($(f crt1.o) $(f crti.o) $(f crtbeginT.o) hello.o --start-group $(f libgcc.a) $(f libgcc_eh.a) $(f libc.a) --end-group $(f crtend.o) $(f crtn.o))
pie=(-static -pie --no-dynamic-linker -z text $(f rcrt1.o) $(f crti.o) $(f crtbeginS.o) hello.o --start-group $(f libgcc.a) $(f libgcc_eh.a) $(f libc.a) --end-group $(f crtendS.o) $(f crtn.o))
median() { sort -g | awk '{a[NR] = $1} END {printf "%.3f", a[int((NR + 1) / 2)]}'; }
for kind in static pie; do
    if [ $kind = static ]; then args=("${static[@]}"); else args=("${pie[@]}"); fi
    rm -f conv_${kind}_* copies_${kind}_* total_${kind}_*
    for ((i = 0; i < runs; i++)); do
        for flag in without with; do
            extra=(); [ $flag = with ] && extra=(--startup-applies-irelative)
            "$compiler" link-foreign -o out_$kind --time "${extra[@]}" "${args[@]}" 2> time_$kind.txt || { cat time_$kind.txt; exit 1; }
            awk '$1 == "link-foreign:" {print $2}' time_$kind.txt >> total_${kind}_${flag}.txt
            awk '$1 == "convert" {print $2}' time_$kind.txt >> conv_${kind}_${flag}.txt
            awk '$1 == "convert" {for (i = 1; i < NF; i++) if ($i == "copies") print $(i + 1)}' time_$kind.txt >> copies_${kind}_${flag}.txt
        done
    done
    ./out_$kind world > /dev/null || exit 1
    for flag in without with; do
        echo "$kind $flag: link $(median < total_${kind}_${flag}.txt) ms, convert $(median < conv_${kind}_${flag}.txt) ms, copies phase $(median < copies_${kind}_${flag}.txt) ms ($(wc -l < conv_${kind}_${flag}.txt) runs)"
    done
done

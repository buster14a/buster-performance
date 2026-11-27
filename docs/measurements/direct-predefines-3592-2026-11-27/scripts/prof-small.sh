#!/bin/bash
# prof-small.sh NAME UNIT N: perf record (user cycles, -c 100000, below the sample-rate limit) over N compiles of a small
# unit, CPU 2; perf stat of the same loop. Results in results/prof-NAME-UNIT/.
set -uo pipefail
here=$HOME/buster-fast-bench/3586-claude2
name=$1; unit=$2; n=$3
bin=$here/bin/compiler-$name
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
M=$C/libc/musl
base=(--lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc)
sys=(-isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
musl=(-D_XOPEN_SOURCE=700 "-I$M/arch/x86_64" "-I$M/arch/generic" "-I$C/musl-generated/obj/src/internal" "-I$M/src/include" "-I$M/src/internal" "-I$C/musl-generated/obj/include" "-I$M/include")
tmp=$(mktemp -d /dev/shm/prof-3586.XXXXXX)
printf 'int add(int a, int b) { return a + b; }\n' > "$tmp/add.c"
printf '#include <stdio.h>\nint main(void) { printf("hello %%d\\n", 1); return 0; }\n' > "$tmp/hello.c"
case $unit in
    add) args=("${base[@]}" -c "$tmp/add.c");;
    hello) args=("${base[@]}" "${sys[@]}" -c "$tmp/hello.c");;
    wcwidth) args=("${base[@]}" "${musl[@]}" -c "$M/src/ctype/wcwidth.c");;
    plain-add) args=(--lanes 1 -c "$tmp/add.c");;
esac
out=$here/results/prof-$name-$unit; mkdir -p "$out"
printf '#!/bin/bash\nfor ((i = 0; i < %d; i++)); do "$@"; done\n' "$n" > "$tmp/loop.sh"; chmod +x "$tmp/loop.sh"
taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,cycles:k,instructions:u,page-faults,task-clock -o "$out/stat.csv" -- "$tmp/loop.sh" "$bin" "${args[@]}" -o "$tmp/o.o"
taskset -c 2 perf record -q -e cycles:u -c 100000 -o "$out/perf.data" -- "$tmp/loop.sh" "$bin" "${args[@]}" -o "$tmp/o.o" 2>/dev/null
perf report -i "$out/perf.data" --no-children --sort sym --stdio 2>/dev/null | grep -v '^#' | grep -v '^$' | head -n 45 > "$out/top.txt"
rm -rf "$tmp"
cat "$out/stat.csv" | grep -v '^#' ; head -n 45 "$out/top.txt"

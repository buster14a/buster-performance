#!/bin/bash
# kprof-small.sh NAME UNIT N: perf record of kernel cycles with call chains over N compiles of a small unit on CPU 2
# (the CPU's, so the exit helper's teardown is included): results/kprof-NAME-UNIT/.
set -uo pipefail
here=$HOME/buster-fast-bench/3586-claude2
name=$1; unit=$2; n=$3
bin=$here/bin/compiler-$name
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
M=$C/libc/musl
base=(--lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc)
sys=(-isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
musl=(-D_XOPEN_SOURCE=700 "-I$M/arch/x86_64" "-I$M/arch/generic" "-I$C/musl-generated/obj/src/internal" "-I$M/src/include" "-I$M/src/internal" "-I$C/musl-generated/obj/include" "-I$M/include")
tmp=$(mktemp -d /dev/shm/kprof-3586.XXXXXX)
printf 'int add(int a, int b) { return a + b; }\n' > "$tmp/add.c"
printf '#include <stdio.h>\nint main(void) { printf("hello %%d\\n", 1); return 0; }\n' > "$tmp/hello.c"
case $unit in
    add) args=("${base[@]}" -c "$tmp/add.c");;
    hello) args=("${base[@]}" "${sys[@]}" -c "$tmp/hello.c");;
    wcwidth) args=("${base[@]}" "${musl[@]}" -c "$M/src/ctype/wcwidth.c");;
    version) args=(--version);;
esac
out=$here/results/kprof-$name-$unit; mkdir -p "$out"
printf '#!/bin/bash\nfor ((i = 0; i < %d; i++)); do "$@"; done\n' "$n" > "$tmp/loop.sh"; chmod +x "$tmp/loop.sh"
perf record -q -C 2 -e cycles:k -c 20000 -g -o "$out/perf.data" -- taskset -c 2 "$tmp/loop.sh" "$here/waitall" "$bin" "${args[@]}" -o "$tmp/o.o" > /dev/null 2>&1
perf report -i "$out/perf.data" --children --sort sym --stdio -g none --percent-limit 1.5 2>/dev/null | grep -v '^#' | grep -v '^$' | head -n 70 > "$out/children.txt"
perf report -i "$out/perf.data" --no-children --sort sym --stdio -g none 2>/dev/null | grep -v '^#' | grep -v '^$' | head -n 30 > "$out/self.txt"
rm -rf "$tmp"
cat "$out/children.txt"; echo ===; cat "$out/self.txt"

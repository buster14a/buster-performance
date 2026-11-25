#!/bin/bash
# faults-by-map.sh NAME...: one -c of hello.c (the corpus's headers) by bin/compiler-NAME under perf trace, its page
# faults counted by what they hit (the executable's file, anonymous memory, other files), 3 runs each.
here=$HOME/buster-fast-bench/direct-designs-np4nn5
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
tmp=$(mktemp -d /dev/shm/pf-np4nn5.XXXXXX)
printf '#include <stdio.h>\nint main(void) { printf("hello %%d\\n", 1); return 0; }\n' > "$tmp/hello.c"
for n in "$@"; do for r in 1 2 3; do
  taskset -c 2 perf trace -F all --no-syscalls -o "$tmp/t.$n.$r" -- "$here/bin/compiler-$n" --lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include" -c "$tmp/hello.c" -o "$tmp/hello.o" > /dev/null 2>&1
  printf '%s run %s: total %s, executable %s, anonymous %s, other %s\n' "$n" "$r" "$(grep -c 'fault' "$tmp/t.$n.$r")" "$(grep 'fault' "$tmp/t.$n.$r" | grep -c "=> .*compiler-$n")" "$(grep 'fault' "$tmp/t.$n.$r" | grep -c '=> \(//anon\|\[anon\|0x\|\[unknown\]\)')" "$(grep 'fault' "$tmp/t.$n.$r" | grep -v "=> .*compiler-$n" | grep -vc '=> \(//anon\|\[anon\|0x\|\[unknown\]\)')"
done; done
head -3 "$tmp/t.$1.1"
rm -rf "$tmp"

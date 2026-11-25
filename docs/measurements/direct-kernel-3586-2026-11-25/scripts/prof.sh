#!/bin/bash
# prof.sh NAME: bin/compiler-NAME's -c of the frozen sqlite3.c on CPU 2, the object on /dev/shm: counters (15 runs),
# kernel cycles by symbol and by caller (40 compiles under perf record -g), the system calls of one compile.
set -uo pipefail
here=$HOME/buster-fast-bench/3586-claude
name=$1
bin=$here/bin/compiler-$name
out=$here/results/prof-$name
mkdir -p "$out"
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
unit=(--lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc
      -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include"
      -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c")
o=/dev/shm/3586-$name.o
chmod +x "$bin"; "$bin" --version > /dev/null || exit 1
{ date -u +%FT%TZ; uname -r; cat /proc/loadavg; cat /sys/kernel/mm/transparent_hugepage/enabled /sys/kernel/mm/transparent_hugepage/defrag; } > "$out/host.txt"
taskset -c 2 "$bin" "${unit[@]}" -o "$o" || echo "compile failed" >> "$out/host.txt"
sha256sum "$o" | cut -c1-16 > "$out/object.txt"; grep -ca 'buster direct' "$o" >> "$out/object.txt"
taskset -c 2 perf stat -r 15 -e cycles:u,cycles:k,instructions:u,page-faults,task-clock -o "$out/stat.txt" -- "$bin" "${unit[@]}" -o "$o"
printf '#!/bin/bash\nfor i in $(seq 40); do "%s" %s -o "%s"; done\n' "$bin" "${unit[*]}" "$o" > "$out/loop.sh"; chmod +x "$out/loop.sh"
taskset -c 2 perf record -q -e cycles:k -c 4001 -g -o "$out/k.data" -- "$out/loop.sh" > /dev/null 2>&1
perf report -i "$out/k.data" --comm compiler-$name --no-children --sort sym -g none --stdio 2>/dev/null | grep -v '^#' | grep -v '^$' | head -80 > "$out/k-self.txt"
perf report -i "$out/k.data" --comm compiler-$name --children --sort sym -g none --stdio 2>/dev/null | grep -v '^#' | grep -v '^$' | head -150 > "$out/k-children.txt"
perf report -i "$out/k.data" --comm compiler-$name --no-children --sort sym -g caller,0.5,callee,function,percent --stdio 2>/dev/null | grep -v '^$' | head -1500 > "$out/k-callers.txt"
perf report -i "$out/k.data" --sort comm,pid --stdio 2>/dev/null | grep -v '^#' | grep -v '^$' | head -100 > "$out/k-pids.txt"
strace -f -c -o "$out/strace-c.txt" "$bin" "${unit[@]}" -o "$o"
strace -f -tt -T -o "$out/strace.txt" "$bin" "${unit[@]}" -o "$o"
rm -f "$o"
echo done > "$out/done"

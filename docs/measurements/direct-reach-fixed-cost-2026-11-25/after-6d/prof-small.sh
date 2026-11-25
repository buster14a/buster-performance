#!/bin/bash
# prof-small.sh NAME: where a small unit's process goes, by the default driver (no --predefines): 500 compiles of
# musl's src/ctype/isdigit.c by -std=c99 on CPU 2, user instructions and cycles by symbol.
set -uo pipefail
here=$HOME/buster-fast-bench/direct-designs-np4nn5
n=$1
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
M=$C/libc/musl
tmp=$(mktemp -d /dev/shm/ps-np4nn5.XXXXXX)
cat > "$tmp/run.sh" <<EOS
#!/bin/bash
for i in \$(seq 500); do taskset -c 2 $here/bin/compiler-$n -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I $M/arch/x86_64 -I $M/arch/generic -I $C/musl-generated/obj/src/internal -I $M/src/include -I $M/src/internal -I $C/musl-generated/obj/include -I $M/include -c $M/src/ctype/isdigit.c -o $tmp/out.o; done
EOS
chmod +x "$tmp/run.sh"
perf stat -e instructions:u,cycles:u,cycles:k -x, -o "$here/results/prof-small-$n.stat" -- "$tmp/run.sh" > /dev/null 2>&1
perf record -q -e instructions:u -c 10007 -o "$tmp/i.data" -- "$tmp/run.sh" > /dev/null 2>&1
perf report --stdio -i "$tmp/i.data" --sort sym --comms compiler-$n > "$here/results/prof-small-$n.txt" 2> /dev/null
readelf -p .comment "$tmp/out.o" | grep -o 'buster[^ ]*' | head -1 >> "$here/results/prof-small-$n.stat"
rm -rf "$tmp"

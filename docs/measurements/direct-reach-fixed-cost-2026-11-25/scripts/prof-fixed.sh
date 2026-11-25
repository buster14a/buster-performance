#!/bin/bash
# prof-fixed.sh: where a one-function unit's process goes, by symbol, user and kernel: 400 compiles under perf record,
# with the default pages and with BUSTER_HUGE_PAGES=0.
set -uo pipefail
here=$HOME/buster-fast-bench/direct-designs-np4nn5
bin=$here/main/build/compiler
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
base=(--lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc)
tmp=$(mktemp -d /dev/shm/prof-np4nn5.XXXXXX)
printf 'int add(int a, int b) { return a + b; }\n' > "$tmp/add.c"
cat > "$tmp/loop.sh" <<EOL
#!/bin/bash
for i in \$(seq 400); do "$bin" ${base[*]} -c "$tmp/add.c" -o "$tmp/out.o"; done
EOL
chmod +x "$tmp/loop.sh"
for p in default nothp; do
    if [ $p = nothp ]; then export BUSTER_HUGE_PAGES=0; else unset BUSTER_HUGE_PAGES; fi
    taskset -c 2 perf record -q -e cycles -c 20011 -o "$tmp/$p.data" -- "$tmp/loop.sh" > /dev/null 2>&1
    echo "=== $p"
    perf report -i "$tmp/$p.data" --comm compiler --sort sym --stdio 2>/dev/null | grep -v "^#" | grep -v "^$" | head -70
done
unset BUSTER_HUGE_PAGES
echo "=== strace -c (default)"
strace -f -c -o "$tmp/strace.txt" "$bin" "${base[@]}" -c "$tmp/add.c" -o "$tmp/out.o"; head -30 "$tmp/strace.txt"
echo "=== strace"
strace -o "$tmp/strace2.txt" "$bin" "${base[@]}" -c "$tmp/add.c" -o "$tmp/out.o"; cut -c1-160 "$tmp/strace2.txt" | head -120
rm -rf "$tmp"

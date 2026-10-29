#!/bin/bash
# Whether a benchmark process's huge-page faults grow with its readings: item2-nothp on h16x19.c, 8 lanes with every
# lane, with 6 and with 48 passes, each between two copies of /proc/vmstat, the counters that changed printed in full
# (3-diag12.txt), in one lock hold.
D=/home/david/buster-fast-bench/697-cloud
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-697-cloud
export EXCLUSIVE_TITLE="#697 deferred bodies (cloud session): a check of the huge-page counters on the 9700X"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/697"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
cat > "$D/3-diag12-hold.sh" <<'INNER'
#!/bin/bash
D=/home/david/buster-fast-bench/697-cloud
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
options=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
L="$D/3-diag12.txt"
for passes in 6 48; do
    echo "== $(date -Is) vmstat item2-nothp passes $passes" >> "$L"
    cat /proc/vmstat > "$D/3-diag12-before.vmstat"
    "$D/item2-nothp/build/compiler" benchmark-checker-deferred --passes "$passes" --lanes 8 --every-lane --cpus 2,0,1,3,4,5,6,7 "${options[@]}" "$D/inputs/synthetic/h16x19.c" > /dev/null 2>&1
    echo "exit=$? $(date -Is)" >> "$L"
    cat /proc/vmstat > "$D/3-diag12-after.vmstat"
    python3 -c "
import sys
b = dict(l.split() for l in open(sys.argv[1]))
a = dict(l.split() for l in open(sys.argv[2]))
for k in sorted(a):
    d = int(a[k]) - int(b.get(k, 0))
    if d != 0 and (k.startswith(('thp', 'pgalloc', 'pgfault', 'pgfree', 'nr_anon')) or 'zero' in k):
        print('vmstat', k, d)
" "$D/3-diag12-before.vmstat" "$D/3-diag12-after.vmstat" >> "$L"
done
INNER
chmod +x "$D/3-diag12-hold.sh"
~/buster-fast-bench/exclusive.sh "$D/3-diag12-hold.sh" 2>> "$D/3-queue.lock.txt"
echo "3-diag12 done $(date -Is)" >> "$D/chain.out"

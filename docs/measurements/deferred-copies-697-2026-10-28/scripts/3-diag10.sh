#!/bin/bash
# Where item2-nothp's lanes wait on eight lanes, against final4's (h16x19.c, every lane): each tree's plain run of 24
# passes between two copies of /proc/vmstat, then its run of 6 passes under perf record of every context switch with
# its call chain, in one lock hold (3-diag10.txt); then, in another, the lanes' switch-outs by chain, and the whole
# kernel chains of the lanes' clear_page_erms samples in diag5's and diag9's cycle profiles (chains.py).
D=/home/david/buster-fast-bench/697-cloud
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-697-cloud
export EXCLUSIVE_TITLE="#697 deferred bodies (cloud session): a diagnostic of item 2's lanes on the 9700X"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/697"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
cat > "$D/3-diag10-hold.sh" <<'INNER'
#!/bin/bash
D=/home/david/buster-fast-bench/697-cloud
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
options=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
L="$D/3-diag10.txt"
for t in item2-nothp final4; do
    echo "== $(date -Is) vmstat $t" >> "$L"
    cat /proc/vmstat > "$D/3-diag10-$t-before.vmstat"
    "$D/$t/build/compiler" benchmark-checker-deferred --passes 24 --lanes 8 --every-lane --cpus 2,0,1,3,4,5,6,7 "${options[@]}" "$D/inputs/synthetic/h16x19.c" >> "$L" 2>&1
    echo "exit=$? $(date -Is)" >> "$L"
    cat /proc/vmstat > "$D/3-diag10-$t-after.vmstat"
    join "$D/3-diag10-$t-before.vmstat" "$D/3-diag10-$t-after.vmstat" | awk '$3 != $2 { print "vmstat", $1, $3 - $2 }' >> "$L"
done
for t in item2-nothp final4; do
    echo "== $(date -Is) switches $t" >> "$L"
    perf record -q -e context-switches -c 1 -g -o "$D/3-diag10-$t-switches.data" "$D/$t/build/compiler" benchmark-checker-deferred --passes 6 --lanes 8 --every-lane --cpus 2,0,1,3,4,5,6,7 "${options[@]}" "$D/inputs/synthetic/h16x19.c" >> "$L" 2>&1
    echo "exit=$? $(date -Is)" >> "$L"
done
INNER
chmod +x "$D/3-diag10-hold.sh"
~/buster-fast-bench/exclusive.sh "$D/3-diag10-hold.sh" 2>> "$D/3-queue.lock.txt"
sleep 20
~/buster-fast-bench/exclusive.sh bash -c '
D=/home/david/buster-fast-bench/697-cloud
for t in item2-nothp final4; do
    perf script -i "$D/3-diag10-$t-switches.data" -F pid,tid,ip,sym 2>/dev/null | python3 "$D/chains.py" all > "$D/3-diag10-$t-switches.txt"
done
perf script -i "$D/3-diag5-item2-nothp-cycles.data" -F pid,tid,ip,sym 2>/dev/null | python3 "$D/chains.py" clear_page_erms > "$D/3-diag10-diag5-item2-nothp-clears.txt"
perf script -i "$D/3-diag9-final4-cycles.data" -F pid,tid,ip,sym 2>/dev/null | python3 "$D/chains.py" clear_page_erms > "$D/3-diag10-diag9-final4-clears.txt"' 2>> "$D/3-queue.lock.txt"
echo "3-diag10 done $(date -Is)" >> "$D/chain.out"

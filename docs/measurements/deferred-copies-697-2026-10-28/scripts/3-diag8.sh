#!/bin/bash
# What the 8.26 MB mappings (0x843000 bytes) are, whose first touches item2-nothp's lanes clear under
# check_input_declaration (3-diag5.sh's cycles): item2-nothp's benchmark on h16x19.c on 8 lanes with every lane, 400
# passes, its /proc/PID/smaps entries of that size (with their VmFlags, THPeligible and AnonHugePages) and its threads'
# stacks, sampled four times while it runs, in one lock hold.
D=/home/david/buster-fast-bench/697-cloud
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-697-cloud
export EXCLUSIVE_TITLE="#697 deferred bodies (cloud session): a diagnostic of item 2's lanes on the 9700X"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/697"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
cat > "$D/3-diag8-inner.sh" <<'INNER'
#!/bin/bash
D=/home/david/buster-fast-bench/697-cloud
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
options=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
"$D/item2-nothp/build/compiler" benchmark-checker-deferred --passes 400 --lanes 8 --every-lane --cpus 2,0,1,3,4,5,6,7 "${options[@]}" "$D/inputs/synthetic/h16x19.c" > /dev/null &
pid=$!
for i in 1 2 3 4; do
    sleep 0.7
    echo "== sample $i $(date -Is)"
    awk 'BEGIN { RS = ""; FS = "\n" } { print }' /proc/$pid/smaps 2>/dev/null | awk '
        /^[0-9a-f]+-[0-9a-f]+ / { split($1, r, "-"); size = strtonum("0x" r[2]) - strtonum("0x" r[1]); keep = (size >= 8000000 && size <= 9000000); if (keep) print; next }
        keep && /^(Size|Rss|AnonHugePages|THPeligible|VmFlags)/ { print "    " $0 }'
    for t in /proc/$pid/task/*; do echo "  task $(basename $t) $(cat $t/comm) stack: $(grep -m1 "^\[stack" $t/maps 2>/dev/null)"; done | head -12
done
wait $pid
echo "exit=$?"
INNER
chmod +x "$D/3-diag8-inner.sh"
~/buster-fast-bench/exclusive.sh "$D/3-diag8-inner.sh" > "$D/3-diag8.txt" 2>&1
echo "3-diag8 done $(date -Is)" >> "$D/chain.out"

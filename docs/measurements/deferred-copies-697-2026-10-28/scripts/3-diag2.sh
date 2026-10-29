#!/bin/bash
# Where item 2's 2 MB pages come from on h16x19.c (3-diag.sh's profile: do_huge_pmd_wp_page and twice main3's
# clear_page_erms on fewer faults): each tree's benchmark once with /proc/vmstat's huge-page counters around it, then
# item 2's and main3's cycles with call chains, and the user frame under each sample in the kernel's page clearing.
# One lock hold each.
D=/home/david/buster-fast-bench/697-cloud
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-697-cloud
export EXCLUSIVE_TITLE="#697 deferred bodies (cloud session): a diagnostic of item 2's lanes on the 9700X"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/697"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
options=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
unit="$D/inputs/synthetic/${1:-h16x19}.c"
L="$D/3-diag2.txt"
cat > "$D/3-vmstat.sh" <<'INNER'
#!/bin/bash
# Runs its arguments with /proc/vmstat's THP and fault counters printed before and after.
grep -E "^(thp_|pgfault|nr_anon_transparent)" /proc/vmstat | sed "s/^/before /"
"$@"
status=$?
grep -E "^(thp_|pgfault|nr_anon_transparent)" /proc/vmstat | sed "s/^/after /"
exit $status
INNER
chmod +x "$D/3-vmstat.sh"
for tree in item2 main3; do
    echo "== $(date -Is) vmstat $tree $unit" >> "$L"
    ~/buster-fast-bench/exclusive.sh "$D/3-vmstat.sh" "$D/$tree/build/compiler" benchmark-checker-deferred --passes 12 --lanes 8 --every-lane --cpus 2,0,1,3,4,5,6,7 "${options[@]}" "$unit" >> "$L" 2>&1
    echo "exit=$? $(date -Is)" >> "$L"
done
for tree in item2 main3; do
    echo "== $(date -Is) record -g $tree $unit" >> "$L"
    ~/buster-fast-bench/exclusive.sh perf record -q -g -e cycles -F 20000 -o "$D/3-diag2-$tree.data" "$D/$tree/build/compiler" benchmark-checker-deferred --passes 6 --lanes 8 --every-lane --cpus 2,0,1,3,4,5,6,7 "${options[@]}" "$unit" >> "$L" 2>&1
    echo "exit=$? $(date -Is)" >> "$L"
    # Each sample in the kernel's page clearing, by the first user frame under it.
    nice -n 19 perf script -i "$D/3-diag2-$tree.data" -F comm,tid,ip,sym 2>/dev/null | awk '
        /^[^ \t]/ { if (clearing && user != "") count[user] += 1; clearing = 0; user = ""; next }
        /clear_page_erms|folio_zero_user|clear_huge_page/ { clearing = 1 }
        /do_huge_pmd/ { huge = 1 }
        { if (user == "" && $0 !~ /\[kernel/ && $2 !~ /^ffff/) { if ($2 != "") user = $2 } }
        END { for (k in count) print count[k], k }' | sort -rn | head -20 > "$D/3-diag2-$tree-clearing.txt"
done
echo "3-diag2 done $(date -Is)" >> "$D/chain.out"

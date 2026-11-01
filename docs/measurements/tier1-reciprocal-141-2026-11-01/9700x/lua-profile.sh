#!/usr/bin/env bash
# lua-profile.sh HEAD: where the Lua builds' cycles go: perf record (cycles:u, a sample per 100,003) of the Tier 0 and
# --tier1 builds' runs of each script, each build's runs one hold of the shared lock, pinned to CPU 2; then each run's
# samples by function and by class (classes.txt: "tier1" where the function's code differs between the two builds).
. ~/buster-fast-bench/claude-141-reciprocal/common.sh
lua=$PWD/corpora-$1/lua
out=$lua/profile
mkdir -p $out
for b in t0 t1; do
    "$lock" bash -c "cd $lua && for s in calls tables strings arithmetic closures; do taskset -c 2 perf record -q -e cycles:u -c 100003 -o $out/perf-\$s-$b.data -- ./lua-$b \$s.lua > /dev/null 2>&1; perf report -i $out/perf-\$s-$b.data --stdio --no-children --sort symbol 2>/dev/null | grep -v '^#' | grep -v '^\$' > $out/symbols-\$s-$b.txt; done"
done
# Each run's samples by class: a symbol's percentage into its class (a symbol classes.txt doesn't name is "other": libc,
# the loader, the kernel's entry), and the five hottest symbols.
for b in t0 t1; do
    for s in calls tables strings arithmetic closures; do
        awk -F'\t' 'NR == FNR { class[$1] = $2; next } { gsub(/%/, "", $1); split($0, f, /\] /); name = f[2]; sub(/ .*/, "", name); c = (name in class) ? class[name] : "other"; share[c] += $1 + 0 } END { printf "%s", FILENAME; for (c in share) printf " %s %.1f%%", c, share[c]; print "" }' $lua/classes.txt FS=' ' $out/symbols-$s-$b.txt
    done
done > $out/classes-shares.txt
echo done > $out/done

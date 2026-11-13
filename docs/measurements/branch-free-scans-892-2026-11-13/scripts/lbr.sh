#!/bin/bash
# lbr.sh TREE [PERIOD]: for #892, on the 9700X under the lock and pinned to CPU 2,
#   1. perf stat (11 runs) of -c sqlite3.c --lanes 1: user cycles, instructions, retired branches,
#      mispredicted branches and their direction mismatches;
#   2. perf record -j any,u of 8 such compiles, reduced to mispredicted LBR entries by from-address,
#      then symbolized with inlining (llvm-symbolizer) on the measured executable.
# Outputs go to ~/buster-fast-bench/892-claude/results/TREE/.
set -u
tree=${1:?tree}
period=${2:-200003}
top=${TOP:-150}
base=~/buster-fast-bench/892-claude
out=$base/results/$tree
mkdir -p "$out" "$base/run" "$base/bin" "$base/scratch"
cd "$base/run" || exit 2
ln -sfn /var/lib/buster-9700x/corpora/preprocessor-391e729af658 corpus
bin=$base/bin/compiler-$tree
cp -f "$base/$tree/build/compiler" "$bin.tmp" && mv -f "$bin.tmp" "$bin"
git -C "$base/$tree" rev-parse HEAD > "$out/commit.txt"
git -C "$base/$tree" diff --stat HEAD >> "$out/commit.txt"
sha256sum "$bin" > "$out/sha256.txt"
corpus=corpus
WL=("$bin" --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --target=x86_64-linux-gnu -march=znver5 -std=gnu17
    -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include"
    -isystem "$corpus/headers/usr/include"
    -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$corpus/sqlite" "$corpus/sqlite/sqlite3.c"
    -c -o "$base/scratch/$tree-sq.o" --lanes 1)
printf -v loop '%q ' "${WL[@]}"
export EXCLUSIVE_OWNER=claude-892 EXCLUSIVE_TITLE="#892: branch-free sites" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/892
export LC_ALL=C
ex=~/buster-fast-bench/exclusive.sh
# held RECEIPTS COMMAND...: COMMAND under the lock, the holder's line (the owner file's first) appended to RECEIPTS first.
held()
{
    local receipts=$1
    shift
    "$ex" bash -c 'head -n 1 /var/lib/buster-9700x/owner >> "$1"; shift; exec "$@"' held "$receipts" "$@"
}
"${WL[@]}" > /dev/null 2>&1 || { echo "workload failed" > "$out/error.txt"; exit 1; }
sha256sum "$base/scratch/$tree-sq.o" >> "$out/sha256.txt"
held "$out/holds.txt" timeout 600 taskset -c 2 perf stat -x, -r 11 -o "$out/stat.csv" \
    -e '{cycles:u,instructions:u,ex_ret_brn:u,ex_ret_brn_misp:u,ex_ret_msprd_brnch_instr_dir_msmtch:u}' -- "${WL[@]}" 2> "$out/stat.log"
held "$out/holds.txt" timeout 600 taskset -c 2 perf stat -x, -r 11 -o "$out/stat2.csv" \
    -e '{cycles:u,instructions:u,ex_ret_brn_tkn:u,ex_ret_brn_tkn_misp:u,ex_ret_brn_ind_misp:u}' -- "${WL[@]}" 2>> "$out/stat.log"
held "$out/holds.txt" timeout 900 taskset -c 2 perf record -q -o "$base/scratch/$tree-lbr.data" -j any,u -e cycles:u -c "$period" -- \
    bash -c "for ((i = 0; i < 8; i++)); do $loop > /dev/null 2>&1 || exit 1; done" 2> "$out/record.log"
echo "record status $?" >> "$out/record.log"
uname -a > "$out/host.txt"; perf --version >> "$out/host.txt"; llvm-symbolizer --version | head -n 2 >> "$out/host.txt"; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor >> "$out/host.txt"
# Every LBR entry: from/to/flags/... with FROM and TO as symbol+offset; count all and mispredicted ones by FROM.
perf script -i "$base/scratch/$tree-lbr.data" -F brstacksym 2>> "$out/record.log" |
    awk '
    {
        for (i = 1; i <= NF; i++)
        {
            n = split($i, f, "/");
            if (n < 3 || (f[3] != "M" && f[3] != "P" && f[3] != "-")) continue;
            from = f[1];
            total += 1; all[from] += 1;
            if (f[3] == "M") { misp += 1; m[from] += 1 }
        }
    }
    END {
        printf "# entries %d mispredicted %d\n", total, misp;
        for (a in m) printf "%s\t%d\t%d\n", a, m[a], all[a];
    }' > "$out/sites.raw"
head -1 "$out/sites.raw" > "$out/sites.tsv"
tail -n +2 "$out/sites.raw" | sort -t$'\t' -k2,2nr | head -n "$top" > "$out/sites.top"
cut -f1 "$out/sites.top" | llvm-symbolizer --obj="$bin" --inlining --functions=short --output-style=LLVM --relativenames > "$out/sites.sym" 2>> "$out/record.log"
echo done > "$out/done"

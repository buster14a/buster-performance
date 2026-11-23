#!/bin/bash
# Compile time with the pass and without it, one hold of the lock each: --tier1 --lanes 1 -c of the frozen sqlite3.c,
# and of Lua 5.4.8's 33 units (one bash command that compiles them in turn), 11 runs each after a warm-up, pinned to
# CPU 2, by time-runs; and the report's store motion line for each.
W=/tmp/3346-claude
export EXCLUSIVE_OWNER=claude-3346 EXCLUSIVE_TITLE='buster #3346: loop store motion sinks stores (compile time)' EXCLUSIVE_LINK=https://claude.ai/code/session_01Egbxnh2KB6UMiNcgm6mK5q
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
L=$HOME/buster-fast-bench/exclusive.sh
C=$W/tree/build/compiler
I=$HOME/buster-fast-bench/139-claude/inputs
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
driver=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc
        -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
cd $W || exit 1
mkdir -p logs scratch
units="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
cat > scratch/lua.sh <<INNER
#!/bin/bash
for s in $units; do $C --tier1 "\$@" --lanes 1 -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o $W/scratch/lua-t-\$s.o $I/lua-5.4.8/src/\$s.c || exit 1; done
INNER
chmod +x scratch/lua.sh
# The report's lines and the objects' identity, with the pass and without it, in one hold.
cat > scratch/reports.sh <<'INNER'
#!/bin/bash
INNER
declare -p C I units sqlite driver W >> scratch/reports.sh
cat >> scratch/reports.sh <<'INNER'
cd $W
for v in off on; do
    opt=(); [ $v = on ] && opt=(--tier1-passes=+storemotion)
    "$C" --tier1 "${opt[@]}" --tier1-report --lanes 1 -c -o scratch/sqlite3-$v.o "${driver[@]}" "$sqlite/sqlite3.c" 2>&1 | grep store-motion | sed "s/^/report sqlite3 $v /" >> logs/reports.txt
    for s in $units; do "$C" --tier1 "${opt[@]}" --tier1-report -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o scratch/lua-$v-$s.o "$I/lua-5.4.8/src/$s.c" 2>&1 | grep store-motion | sed "s/^/report lua $s $v /" >> logs/reports.txt; done
done
for o in scratch/lua-on-*.o; do cmp -s $o ${o/-on-/-off-} || echo "differs $o" >> logs/reports.txt; done
cmp -s scratch/sqlite3-on.o scratch/sqlite3-off.o || echo "differs sqlite3" >> logs/reports.txt
INNER
chmod +x scratch/reports.sh
$L scratch/reports.sh > logs/reports-run.txt 2>&1
$L bash -c "echo receipt: \$(head -1 /var/lib/buster-9700x/owner) at \$(date -u +%FT%TZ); sha256sum $C; taskset -c 2 $C time-runs --runs 11 --warmups 1 --executable $C --list --tier1 --lanes 1 -c -o scratch/sqlite3-t.o ${driver[*]} $sqlite/sqlite3.c --list --tier1 --tier1-passes=+storemotion --lanes 1 -c -o scratch/sqlite3-t.o ${driver[*]} $sqlite/sqlite3.c" > logs/compile-sqlite3.txt 2>&1
$L bash -c "echo receipt: \$(head -1 /var/lib/buster-9700x/owner) at \$(date -u +%FT%TZ); for r in 0 1 2 3 4 5 6 7 8 9 10 11; do for v in off on; do opt=; [ \$v = on ] && opt=--tier1-passes=+storemotion; taskset -c 2 perf stat -x, -e task-clock:u,cycles:u,instructions:u -o scratch/stat.txt $W/scratch/lua.sh \$opt && echo run \$r \$v \$(cut -d, -f1 scratch/stat.txt | grep -E '^[0-9]' | tr '\n' ' '); done; done" > logs/compile-lua.txt 2>&1

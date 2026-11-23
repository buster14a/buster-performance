#!/bin/bash
# sm3309-measure.sh STEP...: #3309's 9700X runs with the tree's Release compiler, each step one hold of the lock, pinned
# to CPU 2 where it times something.
#   corpora   identity: speedtest1's unit and Lua's 33 units by --tier1 with the pass (the default) and with
#             -storemotion, the report's counts and which objects differ; passes: benchmark-ir-source --passes --only
#             store-motion on the frozen sqlite3.c (every symbol listed); corpus: test-ir-source --passes on it (the
#             store-motion row among the others); compile: time-runs of --tier1 --lanes 1 -c sqlite3.c with the pass
#             and with -storemotion, 11 runs
#   programs  measure-tier1-programs --runs 5 with --variant --tier1-passes=-storemotion, where the file run-programs
#             exists
set -u
W=${W:-/dev/shm/3309-fable}
cd $W || exit 1
export EXCLUSIVE_OWNER=claude-3309-fable EXCLUSIVE_TITLE='buster #3309: loop store motion (measurements)' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3328
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
lock=$HOME/buster-fast-bench/exclusive.sh
C=${C:-$W/tree/build/compiler}
I=$HOME/buster-fast-bench/139-claude/inputs
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
driver=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc
        -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
receipt='echo "receipt: $(head -1 /var/lib/buster-9700x/owner) at $(date -u +%FT%TZ)"'
q() { printf "'%s' " "$@"; }
mkdir -p logs scratch
for step in "$@"; do
    log=logs/$step.txt
    case $step in
    corpora)
        rm -rf scratch/identity; mkdir -p scratch/identity
        printf '#include "sqlite3.c"\n#define randomFunc speedtest1_randomFunc\n#include "speedtest1.c"\n' > scratch/identity/speedtest1-unity.c
        script="$receipt; sha256sum '$C'; echo '== identity'; cd scratch/identity; status=0"
        for build in on off; do
            extra=""; [ $build = off ] && extra="--tier1-passes=-storemotion"
            script="$script; mkdir -p $build && '$C' --tier1 $extra --tier1-report -fno-asynchronous-unwind-tables -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sqlite' -I'$I' -o $build/speedtest1.o speedtest1-unity.c 2> $build/speedtest1.report || status=1"
            for s in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do
                script="$script; '$C' --tier1 $extra --tier1-report -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o $build/$s.o '$I/lua-5.4.8/src/$s.c' 2> $build/$s.report || status=1"
            done
        done
        script="$script; for o in on/*.o; do cmp -s \$o off/\$(basename \$o) || echo differs \$(basename \$o); done; grep -H store-motion on/*.report | sed 's/^/report /'; echo units \$(ls on/*.o | wc -l) with-line \$(grep -l store-motion on/*.report | wc -l); echo identity status \$status; sha256sum on/*.o off/*.o; cd $W"
        script="$script; echo '== passes'; taskset -c 2 '$C' benchmark-ir-source --passes --only store-motion $(q "${driver[@]:0:2}") --no-default-config $(q "${driver[@]:2}") '$sqlite/sqlite3.c'; echo passes status \$?"
        script="$script; echo '== corpus'; '$C' test-ir-source --passes $(q "${driver[@]:0:2}") --no-default-config $(q "${driver[@]:2}") '$sqlite/sqlite3.c'; echo corpus status \$?"
        lists=()
        for v in none -storemotion; do
            option=(); [ "$v" != none ] && option=("--tier1-passes=$v")
            lists+=(--list --tier1 "${option[@]}" --lanes 1 -c -o scratch/sqlite3-compile.o "${driver[@]}" "$sqlite/sqlite3.c")
        done
        script="$script; echo '== compile'; taskset -c 2 '$C' time-runs --runs 11 --warmups 1 --executable '$C' $(q "${lists[@]}"); echo compile status \$?"
        $lock bash -c "$script" > "$log" 2>&1
        ;;
    programs)
        # Only where the file run-programs asks for it: the objects' identity decides whether it can say anything.
        [ -e run-programs ] || { echo "programs skipped $(date -u +%FT%TZ)" >> logs/queue.txt; continue; }
        rm -rf scratch/programs; mkdir -p scratch/programs
        $lock bash -c "$receipt; taskset -c 2 '$C' measure-tier1-programs --runs 5 --clang clang --sqlite '$sqlite' --speedtest '$I' --lua '$I/lua-5.4.8/src' --scripts '$I/scripts' --directory '$W/scratch/programs' --variant --tier1-passes=-storemotion" > "$log" 2>&1
        ;;
    esac
    echo "$step exit $? $(date -u +%FT%TZ)" >> logs/queue.txt
done
echo "queue done $(date -u +%FT%TZ)" >> logs/queue.txt

#!/bin/bash
# queue.sh STEP...: #139's 9700X runs (buster#139), each step its own hold of the lock, pinned to CPU 2.
#   build      Release build (BUSTER_DEBUG_INFO=0) of repo, copied to compiler-COMMIT
#   passes     benchmark-ir-source-passes on the frozen sqlite3.c (each pass by both versions)
#   compile    time-runs of --tier1 --lanes 1 -c sqlite3.c with each --tier1-passes= variant (11 runs)
#   programsN  measure-tier1-programs with two --tier1-passes= variants (N = 1..4)
set -u
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-139 EXCLUSIVE_TITLE="Solve 139" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/139
export LC_ALL=C SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
lock=$HOME/buster-fast-bench/exclusive.sh
mkdir -p logs scratch
commit=$(git -C repo rev-parse --short=9 HEAD)
compiler=$PWD/compiler-$commit
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc
        -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
receipt='echo "receipt: $(head -1 /var/lib/buster-9700x/owner) at $(date -u +%FT%TZ)"'
for step in "$@"; do
    log=logs/$step-$commit.txt
    case $step in
    build)
        (cd repo && $lock bash -c "$receipt; env BUSTER_DEBUG_INFO=0 ./build.sh --config Release") > logs/build-$commit.txt 2>&1
        cp repo/build/compiler "$compiler" && sha256sum "$compiler" >> logs/build-$commit.txt
        ;;
    passes)
        $lock bash -c "$receipt; taskset -c 2 '$compiler' benchmark-ir-source-passes $(printf "'%s' " "${source[@]}") '$sqlite/sqlite3.c'" > "$log" 2>&1
        ;;
    compile)
        lists=()
        for v in none -sccp -dce -cfg -inline +gvn +licm +sroa +all -all; do
            option=(); [ "$v" != none ] && option=("--tier1-passes=$v")
            lists+=(--list --tier1 "${option[@]}" --lanes 1 -c -o scratch/sqlite3-compile.o "${source[@]}" "$sqlite/sqlite3.c")
        done
        $lock bash -c "$receipt; taskset -c 2 '$compiler' time-runs --runs 11 --warmups 1 --executable '$compiler' $(printf "'%s' " "${lists[@]}")" > "$log" 2>&1
        ;;
    programs1|programs2|programs3|programs4)
        case $step in
        programs1) variants=(--variant --tier1-passes=-sccp --variant --tier1-passes=-dce) ;;
        programs2) variants=(--variant --tier1-passes=-cfg --variant --tier1-passes=-inline) ;;
        programs3) variants=(--variant --tier1-passes=+gvn --variant --tier1-passes=+licm) ;;
        programs4) variants=(--variant --tier1-passes=+sroa --variant --tier1-passes=+all) ;;
        esac
        rm -rf "scratch/$step"; mkdir -p "scratch/$step"
        $lock bash -c "$receipt; taskset -c 2 '$compiler' measure-tier1-programs --runs 11 --clang clang --tcc \$(command -v tcc) --sqlite '$sqlite' --speedtest '$PWD/inputs' --lua '$PWD/inputs/lua-5.4.8/src' --scripts '$PWD/inputs/scripts' --directory '$PWD/scratch/$step' $(printf "'%s' " "${variants[@]}")" > "$log" 2>&1
        ;;
    esac
    echo "$step exit $? $(date -u +%FT%TZ)" >> logs/queue.txt
done
echo "queue done $(date -u +%FT%TZ)" >> logs/queue.txt

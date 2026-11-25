#!/bin/bash
set -euo pipefail
cd -- "$(dirname -- "$0")"
work=$PWD
source "$work/owner.sh"
lock=$HOME/buster-fast-bench/exclusive.sh
stage=build
trap 's=$?; printf "%s\t%d\n" "$stage" "$s" > "$work/campaign-status"' EXIT
while [[ ! -s build-status ]]; do sleep 2; done
test "$(cat build-status)" = $'done\t0'
stage=setup
mkdir -p raw
outdir=$(mktemp -d /tmp/buster-direct-ab.XXXXXX)
printf '%s\n' "$outdir" > "$work/raw/output-directory.txt"
"$lock" timeout -k 5 30 cc -std=c17 -O2 -Wall -Wextra -Werror time-one.c -o bin/time-one > logs/harness.log 2>&1
for v in baseline candidate; do ln -s "$work/four-workers.sh" "bin/$v-four"; done
C=$work/corpus
M=$C/libc/musl
flags=(--lanes 1 --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -c --predefines "$C/provenance/gnu17-pinned-predefines.txt")
sqlite=(-isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include"
        -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c")
musl=(-D_XOPEN_SOURCE=700 "-I$M/arch/x86_64" "-I$M/arch/generic" "-I$C/musl-generated/obj/src/internal"
      "-I$M/src/include" "-I$M/src/internal" "-I$C/musl-generated/obj/include" "-I$M/include")
{
    uname -n; uname -r; lscpu; lscpu -p=CPU,CORE,SOCKET,ONLINE
    date -u; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor /sys/devices/system/cpu/cpu2/topology/thread_siblings_list
    df -T "$outdir"; cat /proc/sys/kernel/perf_event_paranoid
    git -C src rev-parse HEAD; sha256sum candidate.patch bin/baseline bin/candidate
    rgcmd=$(command -v cores || :); printf 'cores=%s\n' "${rgcmd:-unavailable}"
    cat /sys/devices/system/cpu/cpufreq/boost 2>/dev/null || :
    grep -m1 -E 'CMAKE_C_COMPILER:.*=' src/build/cmake/native/CMakeCache.txt || :
    grep -m1 -o -- '-march=[^ "]*' src/build/compile_commands.json || :
    clangtree="$HOME/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378"
    "$clangtree/bin/clang" --version | head -1; cc --version | head -1; perf version || :
} > raw/host.txt
sha256sum input/*.c corpus/sqlite/sqlite3.c corpus/provenance/gnu17-pinned-predefines.txt > raw/inputs.sha256
(cd src && sha256sum src/buster/compiler/c_direct{,_cc,_lex,_types}.c) > raw/candidate-sources.sha256
printf 'workload\tworkers\tpair\tslot\tbuild\twall_ms\tuser_us\tsystem_us\tmaxrss_kib\tminor_faults\tmajor_faults\n' > raw/times.tsv
printf 'workload\tworkers\tpair\tslot\tbuild\tevent\tcount\trunning_ns\trunning_pct\n' > raw/pmu.tsv
printf 'workload\tworkers\tbuild\tpath\tobject_sha256\n' > raw/objects.tsv
pmu=0
if "$lock" timeout -k 5 15 taskset -c 2 perf stat -x ';' -e cycles:u,instructions:u,branches:u,branch-misses:u true > logs/perf-check.log 2>&1; then
    pmu=1
fi
for workers in 1 4; do
    cpu=2
    workloads=(sqlite wcwidth rem-pio2-large iconv-tables inline-chain locals-1000 locals-2000)
    reserve=()
    if [[ $workers == 4 ]]; then
        cpu=4; workloads=(sqlite iconv-tables inline-chain)
        if command -v cores >/dev/null; then reserve=(cores -n 4 --); fi
    fi
    for suite in "${workloads[@]}"; do
        case $suite in
            sqlite) args=("${sqlite[@]}");;
            wcwidth) args=("${musl[@]}" "$M/src/ctype/wcwidth.c");;
            rem-pio2-large) args=("${musl[@]}" "$M/src/math/__rem_pio2_large.c");;
            iconv-tables) args=("-I$M/src/locale" "$work/input/tables.c");;
            inline-chain) args=("$work/input/chain4000.c");;
            locals-1000) args=("$work/input/locals1000.c");;
            locals-2000) args=("$work/input/locals2000.c");;
        esac
        stage="$suite-$workers"
        echo "$stage"
        trial=("$lock" "${reserve[@]}" timeout -k 5 45 taskset -c "$cpu" bash "$work/trial.sh")
        for v in baseline candidate; do
            "${trial[@]}" verify "$suite" "$workers" 0 0 "$v" "$outdir" "${flags[@]}" "${args[@]}" >> logs/scheduling.log 2>&1
        done
        for ((r=-4; r<100; ++r)); do
            versions=(baseline candidate)
            if ((r % 2)); then versions=(candidate baseline); fi
            for p in 0 1; do
                "${trial[@]}" time "$suite" "$workers" "$r" "$p" "${versions[p]}" "$outdir" "${flags[@]}" "${args[@]}" >> logs/scheduling.log 2>&1
            done
        done
        if ((pmu && workers == 1)); then
            for ((r=0; r<8; ++r)); do
                versions=(baseline candidate)
                if ((r % 2)); then versions=(candidate baseline); fi
                for p in 0 1; do
                    "${trial[@]}" perf "$suite" "$workers" "$r" "$p" "${versions[p]}" "$outdir" "${flags[@]}" "${args[@]}" >> logs/scheduling.log 2>&1
                done
            done
        fi
    done
done
stage=done

#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
campaign=$1
if [[ ${2:-} != locked ]]; then
    export EXCLUSIVE_OWNER=codex-1340 EXCLUSIVE_TITLE="Issue 1340 SQLite $campaign" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1340
    exec "$HOME/buster-fast-bench/exclusive.sh" timeout -k 5 180 bash "$0" "$campaign" locked
fi
export LC_ALL=C
SCRATCH=objects
mkdir -p raw bin "$SCRATCH"
ln -sfn /var/lib/buster-9700x/corpora/preprocessor-391e729af658 corpus
ln -sfn ../base bin/compiler-base
ln -sfn ../head bin/compiler-head
old="$HOME/buster-fast-bench/1340-droid/root/bin/compiler-pre1049-znver5"
ln -sfn "$old" bin/compiler-pre1049
source src/tools/microarch/workloads.sh
snapshot() {
    date -u
    head -3 /var/lib/buster-9700x/owner
    uname -srmo
    lscpu | grep -E 'Model name|CPU family|Stepping'
    cat /proc/loadavg
    ps -eo psr,pcpu,pid,etimes,comm --sort=-pcpu | head -n 9 || true
}
snapshot > "raw/$campaign.hold"
trap 'snapshot >> "raw/$campaign.hold"' EXIT
if [[ $campaign == timing ]]; then
    sha256sum base head "$old" corpus/sqlite/sqlite3.c head.patch >raw/identity.txt
    cat base.commit head.commit "$old.commit" >>raw/identity.txt
    sha256sum src/tools/microarch/{uarch.c,workloads.sh} >>raw/identity.txt
    cc -std=c17 -O2 src/tools/microarch/uarch.c -lm -o uarch
    for work in sq-c sq-syn; do
        for mode in default off extra; do
            flags=()
            case $mode in off) flags=(-w);; extra) flags=(-Wall -Wextra);; esac
            variants=(base head)
            if [[ $mode == default ]]; then variants+=(pre1049); fi
            args=()
            for v in "${variants[@]}"; do
                workload "$v" "$work"
                taskset -c 2 "${WL[@]}" "${flags[@]}" >"raw/$work-$mode-$v.stdout" 2>"raw/$work-$mode-$v.stderr"
                if [[ $work == sq-c ]]; then sha256sum "$SCRATCH/$v-sq.o" >>"raw/objects-$mode.txt"; fi
                args+=(--list "$v" "${WL[@]}" "${flags[@]}" --time-stages)
            done
            cmp "raw/$work-$mode-base.stdout" "raw/$work-$mode-head.stdout"
            cmp "raw/$work-$mode-base.stderr" "raw/$work-$mode-head.stderr"
            if [[ $work == sq-c ]]; then cmp "$SCRATCH/base-sq.o" "$SCRATCH/head-sq.o"; fi
            taskset -c 2 ./uarch time "raw/$work-$mode" 31 "${args[@]}"
        done
    done
    args=()
    for v in base head; do
        workload "$v" sq-c
        args+=(--list "$v" "${WL[@]}")
    done
    taskset -c 2 ./uarch time raw/uninstrumented-default 41 "${args[@]}"
elif [[ $campaign == counters ]]; then
    args=()
    for v in base head pre1049; do
        workload "$v" sq-c
        args+=(--list "$v" perf stat --no-big-num -x, -e cycles:u,instructions:u,branches:u,branch-misses:u -- "${WL[@]}")
    done
    taskset -c 2 ./uarch time raw/perf-default 11 "${args[@]}"
fi

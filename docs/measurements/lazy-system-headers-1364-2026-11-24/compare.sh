#!/bin/bash
# Run next to base/ and candidate/, each built with BUSTER_HOST_ARCH=znver5 ./build.sh --config Release.
set -eu -o pipefail
cd "$(dirname "$0")"
audit=$HOME/buster-fast-bench/perf-audit-claude/inputs
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
read -ra inc <<< "$(pkg-config --cflags-only-I python3 gio-2.0 libxml-2.0)"
mkdir -p comparison
out=$PWD/comparison
printf '#include <immintrin.h>\nint main(void){return 0;}\n' > "$out/intrinsic.c"
export EXCLUSIVE_OWNER=codex-1364 EXCLUSIVE_TITLE="Issue 1364 whole-process comparison" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1364
compiler=$PWD/base/build/compiler
candidate=$PWD/candidate/build/compiler
command=("$compiler" time-runs --runs 24 --build main "$compiler" --build candidate "$candidate")
for unit in sqlite glibc mixed intrinsic; do
    case $unit in
        sqlite) args=(-w -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o "$out/sqlite.o");;
        glibc) args=(-w -fsyntax-only "$audit/glibc380.c");;
        mixed) args=(-w -fsyntax-only "${inc[@]}" "$audit/lib_all.c");;
        intrinsic) args=(-w -fsyntax-only "$out/intrinsic.c");;
    esac
    command+=(--list "${args[@]}" --list "${args[@]}" -flazy-system-headers --list "${args[@]}")
done
# Each round balances all 24 slots (two binaries, four inputs, eager/lazy/eager) and takes the lock independently.
for round in 1 2 3; do
    log=$out/round-$round.log
    "$HOME/buster-fast-bench/exclusive.sh" timeout -k 5 120 taskset -c 2 bash -c '
        cat /proc/loadavg >&2
        ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8 >&2
        "$@"
        rc=$?
        cat /proc/loadavg >&2
        ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8 >&2
        exit "$rc"
    ' measure "${command[@]}" > "$log" 2>&1
    grep -q 'time-runs: done, 0 failed processes' "$log"
    awk '/^run [0-9]+ list / {n++; if ($NF != 0) bad++} END {exit !(n==576 && !bad)}' "$log"
    echo "round $round passed"
done

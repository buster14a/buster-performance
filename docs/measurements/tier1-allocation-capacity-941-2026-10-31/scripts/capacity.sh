#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. Qualification harness for buster PR #941 (buster-performance record).
#
# capacity.sh REPOSITORY WORK OUT: archives buster's main 257892fb and PR #941's head 89bb2bca from REPOSITORY into
# WORK, builds capacity.c against each tree and compare.c, runs the two sweeps at once (two cores) and compares
# them. Each step's log in OUT starts with its UTC time and command and ends with its UTC time and exit status; the
# sweeps' own output goes to OUT/capacity-main.txt and OUT/capacity-head.txt. Exits with compare's status.
set -u
export LC_ALL=C
repository=$1
work=$2
out=$3
here=$(cd "$(dirname "$0")" && pwd)
main=257892fbaf369f99d93914c328824c6a315e019e
head=89bb2bcad078fa53146eef77abb874ed70a3767b
mkdir -p "$work" "$out"

stamp()
{
    date -u +%Y-%m-%dT%H:%M:%S.%3NZ
}

# step NAME COMMAND...: runs COMMAND with its output in OUT/NAME.log.
step()
{
    local name=$1
    shift
    {
        echo "start $(stamp)"
        echo "command: $*"
        "$@"
        local status=$?
        echo "end $(stamp) exit $status"
        return $status
    } > "$out/$name.log" 2>&1
}

host()
{
    uname -a
    grep -m1 'model name' /proc/cpuinfo
    echo "cpus: $(nproc --all), allowed: $(nproc)"
    echo "avx-512 and related flags: $(grep -o -w -E 'avx512[a-z_0-9]*|gfni|vaes|vpclmulqdq' /proc/cpuinfo | sort -u | tr '\n' ' ')"
    clang --version | head -1
    bash --version | head -1
}

trees()
{
    for tree in main head; do
        local commit
        commit=$([ "$tree" = main ] && echo "$main" || echo "$head")
        rm -rf "${work:?}/$tree"
        mkdir -p "$work/$tree"
        git -C "$repository" log -1 --format="$tree: commit %H tree %T: %s" "$commit" || return 1
        git -C "$repository" archive "$commit" | tar -x -C "$work/$tree" || return 1
        echo "$commit" > "$work/$tree/COMMIT"
        (cd "$work/$tree" && find . -type f -print0 | sort -z | xargs -0 sha256sum) > "$out/tree-$tree.sha256" || return 1
        echo "$tree: $(wc -l < "$out/tree-$tree.sha256") files"
    done
    echo "files that differ between the trees:"
    diff -rq "$work/main" "$work/head" | sed "s|$work/||g"
    return 0
}

build()
{
    local tree=$1
    echo "clang -O2 -march=native -I$work/$tree/src -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Wno-unused-function $here/capacity.c -o $work/capacity-$tree"
    clang -O2 -march=native -I"$work/$tree/src" -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Wno-unused-function "$here/capacity.c" -o "$work/capacity-$tree"
}

sweeps()
{
    local status_main=0 status_head=0 pid_main pid_head
    TIMEFORMAT="%R s real, %U s user, %S s system"
    { time "$work/capacity-main" > "$out/capacity-main.txt"; } 2> "$work/time-main.txt" &
    pid_main=$!
    { time "$work/capacity-head" > "$out/capacity-head.txt"; } 2> "$work/time-head.txt" &
    pid_head=$!
    wait "$pid_main" || status_main=$?
    wait "$pid_head" || status_head=$?
    echo "capacity-main: exit $status_main, $(cat "$work/time-main.txt")"
    echo "capacity-head: exit $status_head, $(cat "$work/time-head.txt")"
    [ "$status_main" = 0 ] && [ "$status_head" = 0 ]
}

step host host
step trees trees || exit 1
step build-capacity-main build main || exit 1
step build-capacity-head build head || exit 1
step build-compare clang -std=c17 -O2 -Wall -Wextra -Werror "$here/compare.c" -o "$work/compare" || exit 1
(cd "$work" && sha256sum capacity-main capacity-head compare) > "$out/executables.sha256"
(cd "$here" && sha256sum capacity.c compare.c capacity.sh) > "$out/scripts.sha256"
step sweeps sweeps
step compare "$work/compare" "$out/capacity-main.txt" "$out/capacity-head.txt"

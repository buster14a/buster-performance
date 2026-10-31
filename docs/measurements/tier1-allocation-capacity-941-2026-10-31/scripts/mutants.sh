#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. Qualification harness for buster PR #941 (buster-performance record).
#
# mutants.sh WORK OUT: after capacity.sh has made WORK/head, WORK/compare and OUT/capacity-main.txt, builds
# capacity.c against four copies of the head tree whose tier1_allocate_impl is changed in one place each, runs the
# four sweeps at once (four cores) and compares each with main's. Every one must fail:
# - keep-arena: a failure doesn't pop the arena back to its entry length;
# - write-result: a failure writes the result object;
# - extra-scratch: the vector path pushes 8 more scratch bytes, which the allocation never uses;
# - unzeroed-values: the value checks' column isn't cleared, so they read the arena's earlier bytes.
# Each step's log in OUT starts with its UTC time and command and ends with its UTC time and exit status.
set -u
export LC_ALL=C
work=$1
out=$2
here=$(cd "$(dirname "$0")" && pwd)

stamp()
{
    date -u +%Y-%m-%dT%H:%M:%S.%3NZ
}

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

# mutate NAME: WORK/mutant-NAME, the head tree with tier1_allocate_impl changed; fails unless exactly one line changed.
mutate()
{
    local name=$1
    local tree="$work/mutant-$name"
    local source="$tree/src/buster/compiler/tier1_allocate.c"
    rm -rf "$tree"
    cp -r "$work/head" "$tree"
    awk -v mutant="$name" '
        /^static Tier1AllocationError tier1_allocate_impl\(/ { inside = 1 }
        inside && /^}/ { inside = 0 }
        {
            line = $0
            if (inside && !done)
            {
                if (mutant == "keep-arena" && line == "        arena_pop_to(arena, saved);") { done = 1; next }
                if (mutant == "write-result" && line == "        arena_pop_to(arena, saved);") { print line; print "        if (result != 0) { *result = allocation; }"; done = 1; next }
                if (mutant == "extra-scratch" && index(line, "class_events = arena_push_array(arena, (uint64_t)columns.count * 2, sizeof(uint32_t), 4);") != 0) { sub(/columns\.count \* 2,/, "columns.count * 2 + 2,", line); print line; done = 1; next }
                if (mutant == "unzeroed-values" && line == "        memset(value_seen, 0, columns.value_count);") { done = 1; next }
            }
            print line
        }
        END { if (!done) { exit 1 } }
    ' "$work/head/src/buster/compiler/tier1_allocate.c" > "$source" || return 1
    diff "$work/head/src/buster/compiler/tier1_allocate.c" "$source"
    [ "$(diff "$work/head/src/buster/compiler/tier1_allocate.c" "$source" | grep -c '^[<>]')" -ge 1 ]
}

build()
{
    local name=$1
    echo "clang -O2 -march=native -I$work/mutant-$name/src -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Wno-unused-function $here/capacity.c -o $work/capacity-$name"
    clang -O2 -march=native -I"$work/mutant-$name/src" -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Wno-unused-function "$here/capacity.c" -o "$work/capacity-$name"
}

# run NAME: the mutant's sweep, and its comparison with main's, which must fail.
run()
{
    local name=$1
    "$work/capacity-$name" > "$work/capacity-$name.txt"
    echo "sweep exit $?: $(tail -n 1 "$work/capacity-$name.txt")"
    echo "violations by kind:"
    grep '^violation' "$work/capacity-$name.txt" | sed 's/^violation case [0-9]* [a-z0-9_]* capacity [0-9]*: //' | sort | uniq -c | sort -rn
    "$work/compare" "$out/capacity-main.txt" "$work/capacity-$name.txt" > "$work/compare-$name.txt"
    local status=$?
    echo "compare exit $status: $(tail -n 1 "$work/compare-$name.txt")"
    grep -E '^(ample outcomes differ|head.s boundary is higher|unexplained difference):' "$work/compare-$name.txt" | cut -d: -f1 | sort | uniq -c
    grep -E '^ample outcomes that differ [0-9]' "$work/compare-$name.txt"
    [ "$status" != 0 ]
}

mutants="keep-arena write-result extra-scratch unzeroed-values"
for name in $mutants; do
    step "mutate-$name" mutate "$name" || exit 1
    step "build-mutant-$name" build "$name" || exit 1
done
for name in $mutants; do
    step "mutant-$name" run "$name" &
done
status=0
for job in $(jobs -p); do
    wait "$job" || status=1
done
exit $status

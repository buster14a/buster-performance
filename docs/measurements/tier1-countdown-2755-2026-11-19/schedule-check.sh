#!/usr/bin/env bash
set -euo pipefail
# Run in a Buster checkout built with the same Release configuration as reverse_sum.
record=$(cd -- "$(dirname -- "$0")" && pwd)
scratch=$(mktemp -d)
trap 'rm -rf -- "$scratch"' EXIT
{
    echo 'typedef unsigned int uint32_t;'
    echo 'typedef unsigned long uint64_t;'
    grep -E '^#define BUSTER_X86_(FLAGS_ALL|RESOURCE_FLAGS_SHIFT|RESOURCE_FLAGS) ' src/buster/compiler/x86_semantics.c
    sed -n '/^static void tier1_schedule_live_flags(/,/^}/ { s/^static void /void /; p; }' src/buster/compiler/tier1_schedule.c
} > "$scratch/scheduler.c"
sha256sum "$scratch/scheduler.c"
./build/compiler --tier1 --tier1-passes=+unroll --tier1-strict --tier1-report --verify -march=x86-64 -c "$scratch/scheduler.c" -o "$scratch/scheduler.o"
objdump -d -Mintel --no-show-raw-insn "$scratch/scheduler.o"
size -A "$scratch/scheduler.o"
clang -std=c17 -O2 -march=x86-64 -Dtier1_schedule_live_flags=clang_live_flags -c "$scratch/scheduler.c" -o "$scratch/oracle.o"
clang -std=c17 -O2 -march=x86-64 -Wall -Wextra -Werror "$record/schedule-oracle.c" "$scratch/scheduler.o" "$scratch/oracle.o" -o "$scratch/check"
timeout 20s "$scratch/check"

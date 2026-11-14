#!/bin/bash
# envpad.sh N: main (tpad) with a dead used function of 16, 32 or 48 bytes (N = 15, 31, 47 bytes of padding and its
# ret) right before run_c_environment_benchmark and run_unwind_benchmark, which moves each by that much within its
# 64-byte line and nothing else of the program; built as the 9700X job builds it (inside the lock), its executable to
# placements/base-envpad/compiler-SIZE. The sources are restored after.
set -u
d=$HOME/buster-fast-bench/2559-step5b-claude
. "$d/scripts/env.sh"
export BUSTER_DEBUG_INFO=0
n=$1; size=$(( (n + 1 + 15) / 16 * 16 ))
cd "$d/tpad" || exit 2
git checkout -q -- src
for f in c_environment_benchmark.c:run_c_environment_benchmark unwind_benchmark.c:run_unwind_benchmark; do
    file=src/buster/compiler/${f%%:*}; fn=${f#*:}
    awk -v fn="$fn" -v n="$n" "\$0 ~ \"^static int \" fn \"\\\\(\" { printf \"__attribute__((used, noinline)) static void buster_layout_pad_%s(void)\\n{\\n    __asm__ volatile(\\\".skip %d, 0xcc\\\");\\n}\\n\\n\", fn, n } { print }" "$file" > "$file.new" && mv "$file.new" "$file"
done
git diff --stat
./build.sh --config Release --jobs 8 > "$d/logs/build-envpad-$size.log" 2>&1
status=$?
mkdir -p "$d/placements/base-envpad"
cp build/compiler "$d/placements/base-envpad/compiler-$size"
git checkout -q -- src
exit $status

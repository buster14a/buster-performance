#!/bin/sh
# The final build's call-graph check and sqlite3.c source-CFG dominator check (SCALAR, VECTOR and AUTO against the
# definition oracle), each under its own lock hold; then the host snapshot.
cd ~/buster-fast-bench/1352-claude || exit 1
corpus=~/buster-fast-bench/corpus-391e729af658
unset CPATH C_INCLUDE_PATH
BUSTER_HOST_ARCH=znver5 ./run.sh cg.log ./build.sh check-call-graph
printf 'check-call-graph: %s | %s\n' "$(grep -av '^exclusive.sh\|^  title\|^  link\|^  pull request\|^exit' cg.log | tail -1)" "$(tail -1 cg.log)"
./run.sh sq.log taskset -c 2 ./build/compiler test-ir-source --dominators --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c"
printf 'sqlite test-ir-source --dominators: %s | %s\n' "$(grep -a 'dominators forms' sq.log)" "$(tail -1 sq.log)"
{ uname -a; clang --version | head -1; cmake --version | head -1; ninja --version; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor; cat /sys/kernel/mm/transparent_hugepage/enabled; git -C . rev-parse HEAD; git -C ../1352-claude-base rev-parse HEAD; sha256sum build/compiler ../1352-claude-base/build/compiler; } > host.txt 2>&1
echo finished

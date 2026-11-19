#!/bin/bash
# #2924 C10c's head (c98e08a5a, branch c10c from c10c.bundle) on the 9700X, Release, every run under the lock: the
# encoder's tests, the benchmark in every mode (its check of every implementation against the scalar loop), the call
# graph's checks, test-files on the benchmarks, the complete driver's checks of main.c and the ownership check.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the x86 encoder, C10c" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs
if [ ! -d src ]; then git clone -q --shared $D/../c7gate/src src || exit 1; fi
git -C src fetch -q https://github.com/buster14a/buster main claude/wonderful-wozniak-vbfba7 || { echo "fetch failed" >> logs/status.txt; exit 1; }
git -C src fetch -q "$D/c10c.bundle" "+refs/heads/c10c:refs/heads/c10c" || { echo "bundle failed" >> logs/status.txt; exit 1; }
git -C src checkout -q --detach c98e08a5a && git -C src reset -q --hard
git -C src rev-parse HEAD > logs/commit.txt
cd src
($L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build.log" 2>&1) || { echo "build failed" >> "$D/logs/status.txt"; exit 1; }
mapfile -d '' -t flags < <(env -u BUSTER_SANITIZER BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags --config Release)
export FLAGS="${flags[*]}"
i=0
while IFS= read -r t; do
    [ -z "$t" ] && continue
    i=$((i+1))
    $L timeout -k 5 3000 bash -c "./build/compiler $t" > "$D/logs/t$i.log" 2>&1
    echo "$t: $?" >> "$D/logs/status.txt"
done <<'LIST'
test-x86-encoder
test-x86-encoder --seed 7
benchmark-x86-encoder --count 20000 --section 7 --offsets --fixups
benchmark-x86-encoder --vector --count 20000 --section 7 --offsets --fixups
benchmark-x86-encoder --mode32 --count 20000 --section 7 --offsets --fixups
benchmark-x86-encoder --mode16 --count 20000 --section 7 --offsets --fixups
benchmark-x86-encoder --apx --count 20000 --section 7 --offsets --fixups
benchmark-x86-encoder --address32 --count 20000 --section 7 --offsets --fixups
benchmark-x86-encoder --apx --uniform --count 20000 --section 7 --offsets --fixups
benchmark-x86-encoder --address32 --uniform --count 20000 --section 7 --offsets --fixups
test-branch-sizing --cross-check
test-assembler --cross-check
test-x86-disassembler
test-call-graph
-fsyntax-only -Wall -Werror $FLAGS -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c
--lanes 1 --verify -c $FLAGS -o /dev/shm/claude-2924-c10c-final.o -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c
test-files $FLAGS -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c src/buster/compiler/*_benchmark.c
LIST
rm -f /dev/shm/claude-2924-c10c-final.o
$L timeout -k 5 1800 ./build.sh check-call-graph --config Release > "$D/logs/check-call-graph.log" 2>&1; echo "check-call-graph: $?" >> "$D/logs/status.txt"
cc -std=c17 -O2 -o "$D/br" tools/ci/build_regression.c && $L timeout -k 5 1800 "$D/br" --ownership-only "$PWD/build/cmake/native/Release/compiler" > "$D/logs/ownership.log" 2>&1; echo "ownership: $?" >> "$D/logs/status.txt"
echo done >> "$D/logs/status.txt"
date -u +%FT%TZ > "$D/logs/.done"

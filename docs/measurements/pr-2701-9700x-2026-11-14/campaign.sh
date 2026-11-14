#!/usr/bin/env bash
set -uo pipefail
root="$HOME/buster-fast-bench/2701-codex-01a1d9ad"
head="$root/head"
base="$root/base"
export EXCLUSIVE_OWNER=codex-pr2701 EXCLUSIVE_TITLE='PR 2701 hardware qualification' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2701
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 BUSTER_ORACLE_CACHE=check
export BUSTER_CI_CACHE="$HOME/.cache/buster/ci"
export BUSTER_CLANG_RESOURCE_DIR="$HOME/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378/lib/clang/23"
export LD_LIBRARY_PATH="$HOME/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export PATH="$HOME/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378/bin:$HOME/.cache/buster/build-tools/cmake-4.4.3-ninja-1.13.2/bin:$PATH"
export BUSTER_CORPUS="$root/corpus" BUSTER_PPF_PRAGMA_ORACLE="$root/preprocessor-pragma-oracle"
run() {
  local phase="$1" seconds="$2"; shift 2
  printf '%s START %s\n' "$(date -Is)" "$phase" | tee -a "$root/status.log"
  "$HOME/buster-fast-bench/exclusive.sh" timeout -k 15 "$seconds" "$root/locked.sh" "$@" > "$root/$phase.log" 2>&1
  local rc=$?
  printf '%s END %s %d\n' "$(date -Is)" "$phase" "$rc" | tee -a "$root/status.log"
  if [ "$rc" -ne 0 ]; then printf '%s %d\n' "$phase" "$rc" > "$root/failed"; exit "$rc"; fi
}
run build-head 900 bash -c 'cd "$1"; taskset -c 0-7 ./build.sh shifts --config Release --jobs 8 "$2/head-shifts" main_unit_checker.c 0 1088 2112 3136' _ "$head" "$root"
run build-base 900 bash -c 'cd "$1"; taskset -c 0-7 ./build.sh shifts --config Release --jobs 8 "$2/base-shifts" main_unit_checker.c 0 1088 2112 3136' _ "$base" "$root"
run prepare-corpus 400 bash -c 'cd "$1"; bash tools/ci/fetch-corpus.sh "$2/corpus"' _ "$head" "$root"
run prepare-c-testsuite 400 bash -c 'cd "$1"; bash tools/ci/fetch-c-testsuite.sh build/c-testsuite' _ "$head"
run prepare-sqlite 400 bash -c 'cd "$1"; bash tools/ci/fetch-sqlite.sh build/sqlite' _ "$head"
run prepare-oracle 180 bash -c 'cd "$1"; flags=$(llvm-config --cxxflags --ldflags); read -r -a args <<< "${flags//$'\''\n'\''/ }"; clang++ -O2 -Wall -Werror tools/preprocessor_pragma_oracle.cpp "${args[@]}" -lclang-cpp -o "$2/preprocessor-pragma-oracle"; "$2/preprocessor-pragma-oracle" --version' _ "$head" "$root"
run predefines 90 bash -c 'cd "$1"; clang -dM -E -march=znver5 -fwrapv -funsigned-char -x c /dev/null > build/predefines.h; ./build/compiler parse -fsyntax-only -march=znver5 -Isrc -fwrapv -funsigned-char --predefines build/predefines.h -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c' _ "$head"
for part in 1 2 3 4; do
  run "native-$part" 900 bash -c 'cd "$1"; taskset -c 0-7 ./build/compiler parallel --jobs 8 --timeout 600 --shard "$2/4" --costs tools/ci/costs/native-none-O3.costs < tools/ci/correctness.tests' _ "$head" "$part"
done
run objects 180 bash "$root/performance.sh" "$root" objects
run performance 600 bash "$root/performance.sh" "$root" timing
for shift in 0 1088 2112 3136; do
  for side in base head; do
    run "stages-$side-$shift" 180 bash "$root/stages.sh" "$root" "$side" "$shift" stages
  done
done
for side in base head; do
  run "counters-$side" 180 bash "$root/stages.sh" "$root" "$side" 0 counters
done
printf '%s COMPLETE\n' "$(date -Is)" | tee -a "$root/status.log"
touch "$root/completed"

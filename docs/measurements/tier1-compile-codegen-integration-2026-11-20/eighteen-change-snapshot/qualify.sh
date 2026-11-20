#!/usr/bin/env bash
set -uo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
variant=$1
src="$root/eighteen-candidate"
[[ $variant == control ]] && src="$root/eighteen-control"
dst="$root/eighteen-evidence"
inputs="$root/integration-evidence"
cc=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
export PATH="$(dirname "$cc"):$PATH" BUSTER_TEST_HOST_BUSY=0 SOURCE_DATE_EPOCH=1792454400
cd "$src"
for task in c-testsuite debug pipeline emit select inlining; do
  log="$dst/eighteen-$variant-$task"
  case "$task" in
    c-testsuite) args=(test-c-testsuite --tier1 --code-size --clang "$cc" --jobs 1 --subset tests/c-testsuite/subset.txt "$inputs/c-testsuite");;
    debug) args=(test-debug);; pipeline) args=(test-tier1-pipeline);; emit) args=(test-tier1-emit);;
    select) args=(test-tier1-select);; inlining) args=(test-ir-inline);;
  esac
  CORES_TITLE="Check eighteen-PR compiler integration ($variant, $task)" CORES_LINK=https://github.com/buster14a/buster/pull/3136 cores -n 1 -- "$src/build/compiler" "${args[@]}" >"$log.log" 2>&1
  rc=$?; echo "$rc" > "$log.status"
done
for stage in common own-stage2 own-stage3; do
  compiler="$src/build/compiler"
  source="$src"
  [[ $stage == common ]] && source="$root/eighteen-control"
  [[ $stage == own-stage3 ]] && compiler="$dst/eighteen-$variant-own-stage2/compiler"
  dest="$dst/eighteen-$variant-$stage"
  if [[ $stage == common && $variant == control ]]; then continue; fi
  if [[ ! -x $compiler ]]; then printf 'missing compiler\n' > "$dest.log"; echo 2 > "$dest.status"; continue; fi
  cd "$source"
  CORES_TITLE="Self-host the eighteen-PR compiler ($variant, $stage)" CORES_LINK=https://github.com/buster14a/buster/pull/3136 cores -n 1 -- "$inputs/selfhost" "$compiler" "$inputs/sources.argv" "$inputs/tier1-flags.argv" "$dest" 900 >"$dest.log" 2>&1
  echo "$?" > "$dest.status"
done

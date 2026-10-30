#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Cheap helper/reader controls, no compiler build or host measurement.
set -euo pipefail
tools=$(realpath -- "${1:?usage: tool-controls.sh BUILT_TOOLS BASE_TREE HEAD_TREE NEW_OUTPUT}")
base=$(realpath -- "${2:?}")
head=$(realpath -- "${3:?}")
output=${4:?}
test ! -e "$output"
mkdir -p "$output"
output=$(realpath -- "$output")
source_dir=$(cd -- "$(dirname -- "$0")" && pwd)
sha256sum "$tools/probe_adapter" "$tools/validate_counts" "$source_dir/tool-controls.sh" \
    "$base/src/buster/compiler/c_check_actions.c" "$base/src/buster/compiler/c_checker.c" \
    "$head/src/buster/compiler/c_check_actions.c" "$head/src/buster/compiler/c_checker.c" > "$output/before-tests.sha256"
expect_failure()
{
    name=$1
    shift
    actual=0
    "$@" > "$output/$name.stdout" 2> "$output/$name.stderr" || actual=$?
    test "$actual" = 1
    printf '%s expected_exit=1 actual_exit=%s PASS\n' "$name" "$actual"
}
for revision in base head; do
    tree=$base
    if [[ "$revision" = head ]]; then tree=$head; fi
    "$tools/probe_adapter" "$tree/src/buster/compiler/c_check_actions.c" "$tree/src/buster/compiler/c_checker.c" \
        "$output/$revision.actions.c" "$output/$revision.checker.c" > "$output/$revision.adapter.stdout"
    expect_failure "$revision-repeated-adaptation" "$tools/probe_adapter" "$output/$revision.actions.c" "$output/$revision.checker.c" \
        "$output/$revision.repeat.actions.c" "$output/$revision.repeat.checker.c"
    expect_failure "$revision-same-input-output" "$tools/probe_adapter" "$tree/src/buster/compiler/c_check_actions.c" \
        "$tree/src/buster/compiler/c_checker.c" "$tree/src/buster/compiler/c_check_actions.c" "$output/$revision.unused.c"
done
printf 'no matching helper declaration\n' > "$output/no-marker.c"
expect_failure missing-marker "$tools/probe_adapter" "$output/no-marker.c" "$output/base.checker.c" "$output/missing.actions.c" "$output/missing.checker.c"
cat "$base/src/buster/compiler/c_check_actions.c" "$base/src/buster/compiler/c_check_actions.c" > "$output/duplicate-marker.c"
expect_failure duplicate-marker "$tools/probe_adapter" "$output/duplicate-marker.c" "$output/base.checker.c" "$output/duplicate.actions.c" "$output/duplicate.checker.c"
printf 'buster919-fenv total=2 access_on=0 access_off=2 diagnostic=0 compute=1 builtin=1\n' > "$output/off.base"
printf 'buster919-fenv total=0 access_on=0 access_off=0 diagnostic=0 compute=0 builtin=0\n' > "$output/off.head"
printf 'buster919-fenv total=3 access_on=3 access_off=0 diagnostic=0 compute=1 builtin=2\n' > "$output/on.base"
cp "$output/on.base" "$output/on.head"
printf 'buster919-fenv total=5 access_on=3 access_off=2 diagnostic=0 compute=3 builtin=2\n' > "$output/mixed.base"
printf 'buster919-fenv total=3 access_on=3 access_off=0 diagnostic=1 compute=3 builtin=0\n' > "$output/invalid.base"
cp "$output/invalid.base" "$output/invalid.head"
"$tools/validate_counts" off "$output/off.base" "$output/off.head" > "$output/valid-off.json"
"$tools/validate_counts" on "$output/on.base" "$output/on.head" > "$output/valid-on.json"
"$tools/validate_counts" mixed "$output/mixed.base" "$output/on.head" > "$output/valid-mixed.json"
"$tools/validate_counts" invalid-on "$output/invalid.base" "$output/invalid.head" > "$output/valid-invalid.json"
printf 'no receipt\n' > "$output/missing"
cat "$output/off.base" "$output/off.base" > "$output/duplicate"
sed 's/total=2/total=-2/' "$output/off.base" > "$output/negative"
sed 's/total=2/total=+2/' "$output/off.base" > "$output/signed"
sed 's/total=2/total=18446744073709551616/' "$output/off.base" > "$output/overflow"
sed 's/total=2/total=3/' "$output/off.base" > "$output/bad-sum"
sed 's/compute=1/compute=0/' "$output/off.base" > "$output/bad-route"
sed 's/diagnostic=0/diagnostic=3/' "$output/off.base" > "$output/bad-diagnostic"
sed 's/ builtin=1//' "$output/off.base" > "$output/partial"
sed 's/$/ extra=0/' "$output/off.base" > "$output/extra"
for name in missing duplicate negative signed overflow bad-sum bad-route bad-diagnostic partial extra; do
    expect_failure "reader-$name" "$tools/validate_counts" off "$output/$name" "$output/off.head"
done
expect_failure reader-head-still-calls-off "$tools/validate_counts" off "$output/off.base" "$output/off.base"
expect_failure reader-on-lost "$tools/validate_counts" on "$output/on.base" "$output/off.head"
expect_failure reader-mode "$tools/validate_counts" unsupported "$output/off.base" "$output/off.head"
sha256sum --check "$output/before-tests.sha256" > "$output/after-tests-check.txt"
printf 'Adapter and receipt-reader positive/negative controls passed; source/tool identities unchanged.\n'

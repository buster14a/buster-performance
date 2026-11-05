#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/1219-codex"
export EXCLUSIVE_OWNER=codex-1219 EXCLUSIVE_TITLE='Issue 1219 differential checks' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1419
while [ ! -f fixed-v8-tests.done ]; do
    if [ -s fixed-v8-tests.status ] && awk '$2 != 0 { bad = 1 } END { exit !bad }' fixed-v8-tests.status; then exit 1; fi
    sleep 2
done
mkdir -p fixed-v8-differential
csmith="$HOME/research/tools/csmith-install/bin/csmith"
yarpgen="$HOME/buster-fast-bench/codex138-tools/bin/yarpgen"
revision="csmith $(git -C "$HOME/research/tools/csmith" rev-parse HEAD); yarpgen binary sha256 $(sha256sum "$yarpgen" | cut -d' ' -f1)"
printf '%s\n' "$revision" > fixed-v8-differential/generators.txt
for seed in 1219 1221; do
    "$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 fixed-v8/build/compiler test-differential --buster "$PWD/fixed-v8/build/compiler" --tier0-default --tier1-arg --tier1 --tier1-arg --tier1-report --tier1-arg -fno-asynchronous-unwind-tables --csmith "$csmith" --csmith-include "$HOME/research/tools/csmith-install/include" --csmith-arg --max-funcs --csmith-arg 4 --csmith-arg --max-block-depth --csmith-arg 3 --csmith-arg --max-expr-complexity --csmith-arg 5 --yarpgen "$yarpgen" --yarpgen-arg --max-array-dims=2 --clang clang --generator both --seed "$seed" --count 2 --timeout-ms 30000 --revision b8d721e26f21f2b03229e071622ad4ed374a6e93 --generator-revision "$revision" --output "$PWD/fixed-v8-differential/seed-$seed" > "fixed-v8-differential/seed-$seed.log" 2>&1
    printf '%s 0\n' "$seed" >> fixed-v8-differential.status
done
touch fixed-v8-differential.done

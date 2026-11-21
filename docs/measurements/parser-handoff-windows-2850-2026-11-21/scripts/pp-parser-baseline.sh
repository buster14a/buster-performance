#!/bin/bash
set -eu
root=$HOME/buster-fast-bench/2850-pp-parser-window
mkdir -p "$root/baseline"
cd "$root"
ln -sf "$HOME/buster-fast-bench/2850-values-claude/inputs" inputs
cp "$HOME/buster-fast-bench/2850-parser-depth-blocks/corpora.sh" .
sed 's/checker parser depth blocks/PP to parser window/' "$HOME/buster-fast-bench/2850-parser-depth-blocks/lock.sh" >lock.sh
chmod +x lock.sh
source ./corpora.sh
eval "args=($sqlite_arguments)"
cc=$HOME/buster-fast-bench/2850-codex-step2/results/chainprbase6e9/compiler
cp "$cc" baseline/compiler
sha256sum baseline/compiler > baseline/compiler.sha256
cp "$(dirname "$cc")/revision.txt" baseline/
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
for i in 0 1 2; do
 flock -x 9
 ./lock.sh bash -c 'out=$1; shift; exec env BUSTER_HUGE_PAGES=1 taskset -c 2 "$@" >"$out.out" 2>"$out.err"' _ "baseline/$i-all" baseline/compiler benchmark-parser --passes 7 "${args[@]}" >"baseline/$i-all.lock" 2>&1
 ./lock.sh bash -c 'out=$1; shift; exec env BUSTER_HUGE_PAGES=1 taskset -c 2 "$@" >"$out.out" 2>"$out.err"' _ "baseline/$i-driver" baseline/compiler --time-stages -c -o baseline/sqlite.o "${args[@]}" >"baseline/$i-driver.lock" 2>&1
 flock -u 9
done
date -u +%FT%TZ >baseline/done

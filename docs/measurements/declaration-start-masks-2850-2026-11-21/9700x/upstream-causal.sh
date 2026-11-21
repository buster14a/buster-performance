#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-declaration-starts"
root=$PWD
export BUSTER_HOST_ARCH=znver5
./build-label.sh causal 0efe6db191c5314674011b2369c0ce98f405bd84 upstream-causal.patch
source ./corpora.sh
eval "sql=($sqlite_arguments)"; eval "musl_args=($musl_arguments)"
libc=(); for arg in "${musl_args[@]}"; do [[ $arg == *.c ]] && break; libc+=("$arg"); done
mkdir -p causal
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"; flock -x 9
cd trees/before
for c in sqlite lua musl; do
 case "$c" in sqlite) args=("${sql[@]}");; lua) args=("$lua/lvm.c");; musl) args=("${libc[@]}" "$musl/src/stdio/vfprintf.c");; esac
 "$root/lock.sh" env BUSTER_HUGE_PAGES=1 BUSTER_TEST_DECLARATION_REPLAY=1 taskset -c 2 "$root/results/causal/compiler" -fsyntax-only "${args[@]}" > "$root/causal/$c.out" 2> "$root/causal/$c.err"
done
date -u +%FT%TZ > "$root/causal/done"

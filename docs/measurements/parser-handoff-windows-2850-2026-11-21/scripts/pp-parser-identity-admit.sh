#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window"
root=$PWD
source ./corpora.sh
mkdir -p oracle-identity
base=$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9
clang=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$HOME/buster-fast-bench/2850-codex-step2/results/chainprbase6e9/build.log" | head -1)
src="$root/trees/identity"
mkdir -p identity-admission
./lock.sh taskset -c 2 "$clang" -DPROBE_ADMISSION -std=gnu17 -march=znver5 -O1 -g0 -fwrapv -funsigned-char -I"$src/src" pp-parser-identity-dump.c -o identity-admission/admit >identity-admission/build 2>&1
cd "$base"
main_arguments="-march=znver5 -Isrc -fwrapv -funsigned-char --predefines $root/oracle-identity/predefines.h src/buster/compiler/main.c"
for c in sqlite lua musl main; do
 key=${c}_arguments;eval "args=(${!key})";opts=();files=()
 for a in "${args[@]}"; do if [[ $a == *.c ]];then files+=("$a");else opts+=("$a");fi;done
 "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.files" 2>"$p.err"' _ "$root/identity-admission/$c" env BUSTER_TEST_PARSE_IDENTITY=1 "$root/identity-admission/admit" "${opts[@]}" -- "${files[@]}" >"$root/identity-admission/$c.lock" 2>&1
 echo "$c pass" >>"$root/identity-admission/status"
done
date -u +%FT%TZ >"$root/identity-admission/done"

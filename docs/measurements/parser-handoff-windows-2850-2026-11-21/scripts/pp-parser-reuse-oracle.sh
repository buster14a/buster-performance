#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window"
root=$PWD
source ./corpora.sh
mkdir -p oracle-reuse
base=$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9
clang=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$HOME/buster-fast-bench/2850-codex-step2/results/chainprbase6e9/build.log" | head -1)
for tag in before reuse; do
 src="$base"
 [[ $tag == before ]] || src="$root/trees/$tag"
 ./lock.sh taskset -c 2 "$clang" -std=gnu17 -march=znver5 -O1 -g0 -fwrapv -funsigned-char -I"$src/src" pp-parser-dump.c -o "oracle-reuse/$tag" >"oracle-reuse/$tag.build" 2>&1
done
./lock.sh taskset -c 2 "$clang" -dM -E -march=znver5 -fwrapv -funsigned-char -x c /dev/null >oracle-reuse/predefines.h
cd "$base"
main_arguments="-march=znver5 -Isrc -fwrapv -funsigned-char --predefines $root/oracle-reuse/predefines.h src/buster/compiler/main.c"
for c in sqlite lua musl main; do
 key=${c}_arguments;eval "args=(${!key})";opts=();files=()
 for a in "${args[@]}"; do if [[ $a == *.c ]];then files+=("$a");else opts+=("$a");fi;done
 for tag in before reuse; do
  "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.data" 2>"$p.files"' _ "$root/oracle-reuse/$c-$tag" "$root/oracle-reuse/$tag" "${opts[@]}" -- "${files[@]}" >"$root/oracle-reuse/$c-$tag.lock" 2>&1
 done
 cd "$root/oracle-reuse"
 cmp "$c-before.data" "$c-reuse.data" && cmp "$c-before.files" "$c-reuse.files"
 sha256sum "$c-before.data" "$c-reuse.data" >"$c.sha256";wc -cl "$c-before.data" "$c-before.files" >"$c.bytes"
 rm -f "$c-before.data" "$c-reuse.data"
 echo "$c pass" >>status
 cd "$base"
done
date -u +%FT%TZ >"$root/oracle-reuse/done"

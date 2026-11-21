#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window"
root=$PWD
source ./corpora.sh
mkdir -p oracle-srcprod
base=$HOME/buster-fast-bench/2850-codex-step2/trees/prepbase232
clang=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$HOME/buster-fast-bench/2850-codex-step2/results/prepbase232/build.log" | head -1)
for tag in before srcprod; do
 src="$base"
 [[ $tag == before ]] || src="$root/trees/$tag"
 extra=(); [[ $tag != srcprod ]] || extra=(-DPROBE_IDENTITY)
 ./lock.sh taskset -c 2 "$clang" ${extra[@]} -std=gnu17 -march=znver5 -O1 -g0 -fwrapv -funsigned-char -I"$src/src" pp-parser-identity-dump.c -o "oracle-srcprod/$tag" >"oracle-srcprod/$tag.build" 2>&1
done
./lock.sh taskset -c 2 "$clang" -dM -E -march=znver5 -fwrapv -funsigned-char -x c /dev/null >oracle-srcprod/predefines.h
cd "$base"
main_arguments="-march=znver5 -Isrc -fwrapv -funsigned-char --predefines $root/oracle-srcprod/predefines.h src/buster/compiler/main.c"
for c in sqlite lua musl main; do
 key=${c}_arguments;eval "args=(${!key})";opts=();files=()
 for a in "${args[@]}"; do if [[ $a == *.c ]];then files+=("$a");else opts+=("$a");fi;done
 for tag in before srcprod; do
  "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.data" 2>"$p.files"' _ "$root/oracle-srcprod/$c-$tag" env BUSTER_TEST_PARSE_IDENTITY=1 BUSTER_TEST_PARSE_SOURCE_POISON=1 "$root/oracle-srcprod/$tag" "${opts[@]}" -- "${files[@]}" >"$root/oracle-srcprod/$c-$tag.lock" 2>&1
 done
 cd "$root/oracle-srcprod"
 cmp "$c-before.data" "$c-srcprod.data" && cmp "$c-before.files" "$c-srcprod.files"
 sha256sum "$c-before.data" "$c-srcprod.data" >"$c.sha256";wc -cl "$c-before.data" "$c-before.files" >"$c.bytes"
 rm -f "$c-before.data" "$c-srcprod.data"
 echo "$c pass" >>status
 cd "$base"
done
date -u +%FT%TZ >"$root/oracle-srcprod/done"

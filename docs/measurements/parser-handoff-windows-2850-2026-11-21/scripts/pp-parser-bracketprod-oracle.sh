#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window"
root=$PWD
until [[ -f trees/bracketprod/src/buster/compiler/c_parser.c ]];do sleep 2;done
source ./corpora.sh
mkdir -p oracle-bracketprod
base=$HOME/buster-fast-bench/2850-codex-step2/trees/prepbase232
clang=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$HOME/buster-fast-bench/2850-codex-step2/results/prepbase232/build.log" | head -1)
for tag in before bracketprod; do
 src="$base"
 [[ $tag == before ]] || src="$root/trees/$tag"
 ./lock.sh taskset -c 2 "$clang" -std=gnu17 -march=znver5 -O1 -g0 -fwrapv -funsigned-char -I"$src/src" pp-parser-dump.c -o "oracle-bracketprod/$tag" >"oracle-bracketprod/$tag.build" 2>&1
done
./lock.sh taskset -c 2 "$clang" -dM -E -march=znver5 -fwrapv -funsigned-char -x c /dev/null >oracle-bracketprod/predefines.h
cd "$base"
main_arguments="-march=znver5 -Isrc -fwrapv -funsigned-char --predefines $root/oracle-bracketprod/predefines.h src/buster/compiler/main.c"
for c in sqlite lua musl main; do
 key=${c}_arguments;eval "args=(${!key})";opts=();files=()
 for a in "${args[@]}"; do if [[ $a == *.c ]];then files+=("$a");else opts+=("$a");fi;done
 for tag in before bracketprod; do
  "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.data" 2>"$p.files"' _ "$root/oracle-bracketprod/$c-$tag" "$root/oracle-bracketprod/$tag" "${opts[@]}" -- "${files[@]}" >"$root/oracle-bracketprod/$c-$tag.lock" 2>&1
 done
 cd "$root/oracle-bracketprod"
 cmp "$c-before.data" "$c-bracketprod.data" && cmp "$c-before.files" "$c-bracketprod.files"
 sha256sum "$c-before.data" "$c-bracketprod.data" >"$c.sha256";wc -cl "$c-before.data" "$c-before.files" >"$c.bytes"
 rm -f "$c-before.data" "$c-bracketprod.data"
 echo "$c pass" >>status
 cd "$base"
done
date -u +%FT%TZ >"$root/oracle-bracketprod/done"

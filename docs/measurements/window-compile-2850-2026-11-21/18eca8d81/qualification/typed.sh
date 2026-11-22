#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"; d=$PWD; w=${d%/*}
cd "$w/switch-inputs"; source ../switch-local-args.sh
tree=$w/pregraph-warning-study/compiler-source
main_arguments="-march=native -I$tree/src -fwrapv -funsigned-char --predefines $w/proof-predefines.h $tree/src/buster/compiler/main.c"
tmp=$(mktemp -d); trap 'rm -f -- "$tmp"/{unit.o,stdout,stderr,baseline,observed}; rmdir "$tmp"' EXIT
printf 'source\tcompiler\tobject-bytes\tobject-sha256\tstdout-bytes\tstdout-sha256\tstderr-bytes\tstderr-sha256\n' >"$d/typed.tsv"
for name in sqlite main;do
 var=${name}_arguments
 eval "args=(${!var})"
 for variant in main-fbef-clean seed-parser-windows;do
  "$w/$variant/build/compiler" --dump-typed --lanes 1 -c "${args[@]}" -o "$tmp/unit.o" >"$tmp/stdout" 2>"$tmp/stderr"
  sha256sum "$tmp"/{unit.o,stdout,stderr} | cut -d' ' -f1 >"$tmp/observed"
  if [[ $variant == main-fbef-clean ]]; then cp "$tmp/observed" "$tmp/baseline";else cmp "$tmp/baseline" "$tmp/observed";fi
  readarray -t digest <"$tmp/observed"
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$name" "$variant" "$(stat -c%s "$tmp/unit.o")" "${digest[0]}" "$(stat -c%s "$tmp/stdout")" "${digest[1]}" "$(stat -c%s "$tmp/stderr")" "${digest[2]}" >>"$d/typed.tsv"
 done
done

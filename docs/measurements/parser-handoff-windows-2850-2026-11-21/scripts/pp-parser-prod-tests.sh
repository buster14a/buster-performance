#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window"
root=$PWD
label=${1:-windows}
until test -f results/"$label"/.built; do sleep 3; done
source ./corpora.sh
mkdir -p checks-"$label"/bounds
cd checks-"$label"; out=$PWD
cp "$HOME"/buster-fast-bench/2850-parser-depth-blocks/boundaries/inputs/*.c bounds/
python3 - <<'PY'
from pathlib import Path
for align in (0,1,2,31,60,61,62,63,64,65,125,126,127,128,129):
 with Path(f'bounds/parameters-{align}.c').open('w') as f:
  f.write(';' * align + 'typedef int I; int (*p)(I); int f(int (*a)(I), int b) { int local(int); return a(b) + local(b); }\n')
  f.write('int (*g(void))(int) {return p;} int use(void) {return g()(2);}\n')
  f.write('struct S { int x; } __attribute__((aligned(8))); int done;\n')
PY
cc=$root/results/$label/compiler
clang=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$root/results/$label/build.log" | head -1)
cd "$root/trees/$label"
"$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.out" 2>"$p.err"' _ "$out/snippets" "$cc" test-parser --clang "$clang" --seed 133 >"$out/snippets.lock" 2>&1
echo snippets >>"$out/status"
"$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.out" 2>"$p.err"' _ "$out/boundaries" "$cc" test-parser --files-only "$out"/bounds/*.c >"$out/boundaries.lock" 2>&1
echo boundaries >>"$out/status"
"$root/lock.sh" taskset -c 2 "$clang" -dM -E -march=znver5 -fwrapv -funsigned-char -x c /dev/null >"$out/predefines.h"
cd "$HOME/buster-fast-bench/2850-codex-step2/trees/prepbase232"
main_arguments="-march=znver5 -Isrc -fwrapv -funsigned-char --predefines $out/predefines.h src/buster/compiler/main.c"
for c in sqlite lua musl main; do
 key=${c}_arguments; eval "args=(${!key})"
 case "$c" in
   lua) sample=("$lua/lvm.c");;
   musl) sample=();for a in "${args[@]}"; do [[ $a == *.c ]] && break;sample+=("$a");done;sample+=("$musl/src/stdio/vfprintf.c");;
   *) sample=("${args[@]}");;
 esac
 for path in before "$label"; do
  exe=$root/results/$path/compiler
  [[ $path != before ]] || exe=$root/results/base232/compiler
  for mode in E syntax default wall; do
   p="$out/$c-$path-$mode"; opts=(); cmdargs=("${sample[@]}")
   [[ $mode != E ]] || opts=(-E)
   if [[ $mode == syntax ]]; then opts=(-fsyntax-only -Wall -Wextra); cmdargs=("${args[@]}"); fi
   if [[ $mode == default || $mode == wall ]]; then opts=(-c -o "$out/current.o"); [[ $mode != wall ]] || opts+=(-Wall -Wextra); fi
   rm -f "$out/current.o"; st=0
   "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.out" 2>"$p.err"' _ "$p" "$exe" "${opts[@]}" "${cmdargs[@]}" >"$p.lock" 2>&1 || st=$?
   echo "$st" > "$p.status"
   sha256sum "$p.out" | cut -d' ' -f1 >"$p.stdout-sha";rm -f "$p.out"
   if test -e "$out/current.o";then sha256sum "$out/current.o" | cut -d' ' -f1 >"$p.object-sha"; fi
  done
 done
 for mode in E syntax default wall; do
  for v in status stdout-sha err object-sha; do a="$out/$c-before-$mode.$v"; b="$out/$c-$label-$mode.$v"; [[ ! -f $a && ! -f $b ]] || cmp "$a" "$b"; done
  echo "$c $mode pass" >> "$out/status"
 done
done
rm -f "$out/current.o"
date -u +%FT%TZ > "$out/done"

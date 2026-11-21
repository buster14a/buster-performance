#!/usr/bin/env bash
set -eu
d=$(cd "$(dirname "$0")" && pwd);w=$(cd "$d/.." && pwd)
rev=a60859270;r="$d/$rev";mkdir -p "$r";cd "$w/window-constants"
export PATH="~/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH"
./build.sh --config Develop >"$r/build.log" 2>&1
ln -f build/compiler "$r/compiler"
"$r/compiler" --node-window-constants --time-stages --lanes 1 -g -c tests/checker/node-window-constants.c -o "$r/fixture.o" >"$r/fixture.out" 2>"$r/fixture.err"
rg '^constant-window: roots=4 removed=10' "$r/fixture.err"
for f in tests/driver/assert_bool_comma.c tests/driver/assert_bool_comma_block.c tests/driver/unused_comparison_failed_assertions.c; do
 for p in base all quiet; do
  flags=(); [[ $p != all ]] || flags+=(-Weverything); [[ $p != quiet ]] || flags+=(-w)
  name=$(basename "$f")
  for m in parent off on;do exe="$r/compiler";opt=();[[ $m != parent ]] || exe="$d/b86eadcbd-compiler";[[ $m != on ]] || opt+=(--node-window-constants)
   rc=0;"$exe" "${opt[@]}" "${flags[@]}" -c "$f" -o "$r/invalid.o" >"$r/$name-$p-$m.stdout" 2>"$r/$name-$p-$m.diag" || rc=$?
   [[ $rc -eq 1 ]]
  done
  cmp "$r/$name-$p-parent.diag" "$r/$name-$p-on.diag";cmp "$r/$name-$p-off.diag" "$r/$name-$p-on.diag"
 done
done
"$r/compiler" test-checker --fixtures tests --clang "$(command -v clang)" --part 5/8 > "$r/part5.log" 2>&1
"$r/compiler" test-checker --fixtures tests --clang "$(command -v clang)" --attested > "$r/attested.log" 2>&1
python "$d/runtime.py" "$rev"
python "$d/assertions.py" "$rev"
for suite in tracked frozen generated;do python "$d/driver.py" "$r/compiler" "$d/b86eadcbd-compiler" "$r/$suite" "$suite";done
python "$d/stages.py" "$r/compiler" "$r/stages"

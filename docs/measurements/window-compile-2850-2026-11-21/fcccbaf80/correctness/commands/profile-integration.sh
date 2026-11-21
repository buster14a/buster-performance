#!/usr/bin/env bash
set -eu
d=$(cd "$(dirname "$0")" && pwd);w=$(cd "$d/.." && pwd);r="$d/27441f465";mkdir -p "$r"
export PATH="/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH"
cd "$w/window-constants-merge-train"
./build.sh --config Develop >"$r/build.log" 2>&1;ln -f build/compiler "$r/compiler"
"$r/compiler" test-checker --fixtures tests --clang "$(command -v clang)" --part 5/8 >"$r/part5.log" 2>&1
"$r/compiler" test-checker --fixtures tests --clang "$(command -v clang)" --attested >"$r/attested.log" 2>&1
for file in node-window-constants node-window; do
 for family in node-window node-window-constants node-window-assignments; do
  for shape in no-debug debug remapped poisoned; do
   flags=();[[ $shape == no-debug ]] || flags+=(-g);[[ $shape != remapped ]] || flags+=(-DWINDOW_REMAPPED_SOURCE);[[ $shape != poisoned ]] || flags+=(--poison-arenas)
   for profile in off on;do timer=();[[ $profile != on ]] || timer+=(--time-stages)
    x="$r/$file-$family-$shape-$profile";"$r/compiler" --lanes 1 "${flags[@]}" "${timer[@]}" --"$family" -c "tests/checker/$file.c" -o "$x.o" 2>"$x.err"
   done
   x="$r/$file-$family-$shape";"$r/compiler" --lanes 1 "${flags[@]}" -c "tests/checker/$file.c" -o "$x-ordinary.o" 2>"$x-ordinary.err"
   cmp "$x-off.o" "$x-ordinary.o";cmp "$x-off.o" "$x-on.o"
  done
 done
done
rp="$d/profile-707ef11f";mkdir -p "$rp"
(cd "$w/window-constants-profile-parent" && ./build.sh --config Develop) >"$rp/build.log" 2>&1
ln -f "$w/window-constants-profile-parent/build/compiler" "$rp/compiler";parent="$rp/compiler"
for suite in frozen generated tracked;do python "$d/driver.py" "$r/compiler" "$parent" "$r/$suite" "$suite";done
python "$d/stages.py" "$r/compiler" "$r/stages"
python "$d/all-gates.py" 27441f465

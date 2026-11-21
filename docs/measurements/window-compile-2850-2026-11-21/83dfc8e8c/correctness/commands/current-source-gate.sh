#!/usr/bin/env bash
set -eu
d=$(cd "$(dirname "$0")" && pwd);w=$(cd "$d/.." && pwd);r="$d/83dfc8e8c";mkdir -p "$r"
cd "$w/window-constants"
export PATH="/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH"
./build.sh --config Develop >"$r/build.log" 2>&1
ln -f build/compiler "$r/compiler"
"$r/compiler" test-checker --fixtures tests --clang "$(command -v clang)" --part 5/8 >"$r/part5.log" 2>&1
"$r/compiler" test-checker --fixtures tests --clang "$(command -v clang)" --attested >"$r/attested.log" 2>&1
for g in plain remapped;do opts=();[[ $g != remapped ]] || opts+=(-DWINDOW_REMAPPED_SOURCE)
 for p in normal poison;do flags=();[[ $p != poison ]] || flags+=(--poison-arenas)
  "$r/compiler" --node-window-constants --time-stages --lanes 1 -g -c "${opts[@]}" "${flags[@]}" tests/checker/node-window-constants.c -o "$r/$g-$p.o" 2>"$r/$g-$p.diag"
  rg '^constant-window: roots=4 removed=10' "$r/$g-$p.diag"
 done
done
for points in "$w/program-main-3246" "$w/profile-current-parent";do
 if [[ $(git -C "$points" rev-parse HEAD) == 325883abf9607ac726966a0af2097377832d53ac && -z $(git -C "$points" diff --name-only HEAD) && -x "$points/build/compiler" ]];then
  ln -f "$points/build/compiler" "$r/parent";break
 fi
done
if [[ ! -x "$r/parent" ]];then
 git -C "$w/window-constants" worktree add --detach "$w/window-constants-parent325" 325883abf9607ac726966a0af2097377832d53ac
 (cd "$w/window-constants-parent325" && ./build.sh --config Develop) >"$r/parent-build.log" 2>&1
 ln -f "$w/window-constants-parent325/build/compiler" "$r/parent"
fi
sha256sum "$r/parent" "$r/compiler" >"$r/binaries.sha256"
python "$d/parser-source-guard.py"
for suite in frozen tracked generated;do python "$d/driver.py" "$r/compiler" "$r/parent" "$r/$suite" "$suite";done
python "$d/stages.py" "$r/compiler" "$r/stages"
python "$d/all-gates.py" 83dfc8e8c

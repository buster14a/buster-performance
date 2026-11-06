#!/usr/bin/env bash
set -euo pipefail
root="$HOME/buster-fast-bench/1313-current-codex"
build="$root/base/build/cmake/znver5-g0"
input="$HOME/buster-fast-bench/1296-codex-20261105/corpus/sqlite"
dir="$root/layout-pad"
mkdir -p "$dir"
export EXCLUSIVE_OWNER=codex-1313-pad EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1313 LC_ALL=C
printf '.section .rodata,"a",@progbits\n.global codex_1313_layout_probe\ncodex_1313_layout_probe:\n.zero 2048\n.section .note.GNU-stack,"",@progbits\n' > "$dir/pad.s"
export EXCLUSIVE_TITLE='PR 1313 diagnostic rodata probe compilation'
"$HOME/buster-fast-bench/exclusive.sh" clang -c "$dir/pad.s" -o "$dir/pad.o" > "$dir/compile.log" 2>&1
cd "$build"
ninja -f build-Release.ninja -t commands compiler.link | tail -1 > "$dir/original-link.txt"
python3 - "$dir" <<'PY'
from pathlib import Path
import shlex,sys,json
p=Path(sys.argv[1]); args=shlex.split((p/'original-link.txt').read_text());assert args[:2]==[':','&&'] and args[-2:]==['&&',':'];args=args[2:-2]; k=args.index('-o');assert args[k+1]=='Release/compiler.link';args[k+1]=str(p/'compiler.link');args.insert(k,str(p/'pad.o'));(p/'link-argv.json').write_text(json.dumps(args,indent=2)+'\n')
PY
export EXCLUSIVE_TITLE='PR 1313 diagnostic rodata probe link'
"$HOME/buster-fast-bench/exclusive.sh" python3 - "$dir/link-argv.json" <<'PY' > "$dir/link.log" 2>&1
import json,subprocess,sys
subprocess.run(json.load(open(sys.argv[1])),check=True)
PY
ninja -f build-Release.ninja -t commands compiler | tail -1 > "$dir/original-bake.txt"
python3 - "$dir" <<'PYPAD'
from pathlib import Path
import shlex,sys,json
p=Path(sys.argv[1]);a=shlex.split((p/'original-bake.txt').read_text());k=a.index('&&');a=a[k+1:];a=[f'-DINPUT={p}/compiler.link' if x.startswith('-DINPUT=') else f'-DOUTPUT={p}/compiler' if x.startswith('-DOUTPUT=') else x for x in a];(p/'bake-argv.json').write_text(json.dumps(a,indent=2)+'\n')
PYPAD
export EXCLUSIVE_TITLE='PR 1313 diagnostic rodata probe bake'
"$HOME/buster-fast-bench/exclusive.sh" python3 - "$dir/bake-argv.json" <<'PYPAD' > "$dir/bake.log" 2>&1
import json,subprocess,sys
subprocess.run(json.load(open(sys.argv[1])),check=True)
PYPAD
nm "$dir/compiler" | grep ' codex_1313_layout_probe$' > "$dir/probe-symbol.txt"
sha256sum "$dir/compiler" "$root/base/build/compiler" "$dir/pad.o" > "$dir/binaries.sha256"
readelf -SW "$dir/compiler" > "$dir/sections.txt"
opts=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$input" "$input/sqlite3.c")
names=(base padded)
for ((r=0;r<4;r++)); do
 for ((j=0;j<2;j++)); do
  idx=$(((j+r)%2)); variant=${names[idx]}; src="$root/base/build/compiler"; [[ $variant != padded ]] || src="$dir/compiler"; label="$variant-$r"; export EXCLUSIVE_TITLE="PR 1313 layout probe $label"
  "$HOME/buster-fast-bench/exclusive.sh" bash -c 'set -euo pipefail; cp "$1" "$2"; sha256sum "$2" > "$3"; shift 3; taskset -c 2 perf stat -x, -e instructions:u -o "$1" -- "$2" -fsyntax-only "${@:3}"' -- "$src" "$dir/common-compiler" "$dir/$label.bin.sha256" "$dir/$label.perf" "$dir/common-compiler" "${opts[@]}" > "$dir/$label.stdout" 2> "$dir/$label.stderr"
 done
done
printf 'done\n' > "$dir/complete.txt"

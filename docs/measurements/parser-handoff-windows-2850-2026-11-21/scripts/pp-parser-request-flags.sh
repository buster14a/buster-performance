#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window"
root=$PWD
base=$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9
clang=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$HOME/buster-fast-bench/2850-codex-step2/results/chainprbase6e9/build.log" | head -1)
mkdir -p request-flags; out=$root/request-flags
python3 - "$out" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1])
for n in [0,1,31,61,62,63,64,65,126,127,128,129]:
 terms=' + '.join('x' for _ in range(4*n+1))
 (p/f'edge-{n}.c').write_text(';'*n+'typedef int I; int proto(I); int a; int b, c; int (*ptr)(int);\n'
  +'int first(I x) { return '+terms+'; }\n'
  +'struct S { int a; struct { int z; } s; }; int (*f(void))(int) {return ptr;}\n'
  +'int second(int (*g)(int), int x) { return g(x) + f()(x); } int final;\n')
PY
for label in before requests;do
 src=$base;[[ $label == before ]] || src="$root/trees/$label"
 overlay=$out/include-$label
 mkdir -p "$overlay/buster/compiler"
 python3 - "$src/src/buster/compiler/c_parser_impl.c" "$overlay/buster/compiler/c_parser_impl.c" <<'PY'
from pathlib import Path
import sys
s=Path(sys.argv[1]).read_text()
marker='        parse_flag_custom_attributes(kernels, input);'
assert s.count(marker)==1
s=s.replace(marker,marker+'''
        const unsigned pattern = (unsigned)strtoul(getenv("BUSTER_ORACLE_FLAGS"), NULL, 10);
        for (uint32_t i = 0; i < count; i += 1)
        {
            const uint32_t mixed = (i * 747796405u + 2891336453u) ^ (i >> 5);
            const bool flagged = pattern < 64 ? (i & 63) == pattern : pattern == 64 ? i == count - 1 :
                                 pattern == 65 ? i == 0 : pattern == 66 ? true : pattern == 67 ? mixed % 7 == 0 :
                                 pattern == 68 ? (i & 127) >= 61 && (i & 127) <= 66 : mixed % 173 == 0;
            kernels->flags[i] |= flagged;
        }
''')
Path(sys.argv[2]).write_text(s)
PY
 "$root/lock.sh" taskset -c 2 "$clang" -std=gnu17 -march=znver5 -O1 -g0 -fwrapv -funsigned-char -I"$overlay" -I"$src/src" -I"$src/src/buster/compiler" "$root/pp-parser-dump.c" -o "$out/$label" >"$out/$label.build" 2>&1
done
"$root/lock.sh" taskset -c 2 bash -c '
set -eu
d=$1;cd "$d"
for i in {0..69}; do
 for arm in before requests;do
  BUSTER_ORACLE_FLAGS="$i" ./"$arm" -- edge-*.c >"$arm.rows" 2>"$arm.files"
 done
 cmp before.rows requests.rows && cmp before.files requests.files
 bytes=$(wc -c <before.rows);sha=$(sha256sum before.rows|cut -d" " -f1)
 echo "$i $bytes $sha" >>status
done
rm -f before.rows requests.rows
date -u +%FT%TZ >done' _ "$out" > "$out/test.lock" 2>&1

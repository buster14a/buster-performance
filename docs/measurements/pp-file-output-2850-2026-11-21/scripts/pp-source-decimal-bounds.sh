#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;out=$root/digit-boundaries;mkdir -p "$out/inputs"
until [[ -f digit-oracle/built && -f results/digit1/.built ]];do sleep 2;done
python3 - "$out/inputs" <<'PY'
from pathlib import Path
import sys
d=Path(sys.argv[1])
for align in [0,1,2,3,15,16,30,31,32,47,62,63,64,65,127,128]:
 s=';'*align + '''
#define ONE 1
#define BOTH(a,b) ((a)+(b))
#define TWO 2
#define PLAIN(x) x
#define GLUE(a,b) a ## b
enum { V = 8 };
int f(int a)
{
  int x = -1 + (2 + 3) - 4 + 5 + a;
  int y = 07 + 010 + 0x1 + 2U + 3L + (int)(4e0) + 100 + 001;
  return PLAIN(1) + BOTH(2,3) + ONE + TWO + GLUE(1,0) + x + y + V + 0;
}
'''
 if align%2:s+= '#if 0\nint near(void){return 7;}\n#endif\n'
 (d/f'aligned-{align}.c').write_text(s)
(d/'continued.c').write_text('int x = 2\\\n5 + 4;\nint f(void){return 1 + 3;}\n')
(d/'pragma.c').write_text('#pragma message("digits 4 and 5")\nint f(void){return 6;}\n')
(d/'line.c').write_text('#line 90 "digits.c"\nint f(void){return __LINE__ + 5;}\n')
(d/'unreachable.c').write_text('int f(void){ if (0) return 9; else return 7; }\n')
PY
for f in "$out"/inputs/*.c;do
 name=$(basename "$f" .c)
 for mode in before writer read;do
  cc=$root/results/digit1/compiler;or=$root/digit-oracle/digit1-oracle
  if [[ $mode == before ]];then cc=$root/results/before/compiler;or=$root/digit-oracle/before-oracle;fi
  p=$out/$name-$mode
  "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.data" 2>"$p.or.err"' _ "$p" env BUSTER_TEST_SMALL_DECIMAL="$mode" "$or" -- "$f" >"$p.or.lock" 2>&1
  "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.stdout" 2>"$p.stderr"' _ "$p" env BUSTER_TEST_SMALL_DECIMAL="$mode" "$cc" -Wall -Wextra -c -o "$p.o" "$f" >"$p.lock" 2>&1
  sha256sum "$p.data" "$p.o" "$p.stderr" >"$p.sha256"
  if [[ $mode != before ]];then for x in data o stderr;do cmp "$out/$name-before.$x" "$p.$x";done;fi
 done
 rm "$out/$name"-*.data "$out/$name"-*.o
 echo "$name pass" >>"$out/status"
done
date -u +%FT%TZ >"$out/done"

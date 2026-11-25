#!/bin/bash
# mkpad.sh NAME SRCDIR: SRCDIR's harness with a 16- and a 48-byte nop function ahead of the lexer's code, built for
# znver5 as bin/direct-NAME-p16 and -p48 (the code placement's spread for one arm), shipped to the 9700X.
set -euo pipefail
name=$1; src=$2
for n in 16 48; do
  t=/home/user/dp/pad-$name-$n; rm -rf "$t"; mkdir -p "$t"; cp -r "$src/src" "$t/"
  nops=$(printf 'nop;%.0s' $(seq $n))
  python3 - "$t/src/buster/compiler/c_direct_lex.c" "$nops" <<'PY'
import sys
p, nops = sys.argv[1], sys.argv[2]
s = open(p).read()
anchor = 'typedef struct FastArena FastArena;'
assert s.count(anchor) == 1
s = s.replace(anchor, 'static __attribute__((used, noinline)) void fast_layout_pad(void) { __asm__ volatile("%s"); }\n' % nops + anchor)
open(p, 'w').write(s)
PY
  SHIP=1 /home/user/dp/mk.sh "$name-p$n" "$t" | tail -2
done

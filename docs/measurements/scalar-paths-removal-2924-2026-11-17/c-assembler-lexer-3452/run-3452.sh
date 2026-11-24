#!/bin/sh
# 3452 lexer gate: base, head and a copy of base (process noise control), rotated, pinned to CPU 2.
cd "$(dirname "$0")" || exit 1
for b in base head ctrl; do ./compiler-$b help >/dev/null 2>&1 || ./compiler-$b assemble 2>&1 | grep -q usage || { echo "bad $b"; exit 1; }; done
for r in 1 2 3 4 5 6 7; do
  case $((r % 3)) in 0) order="base head ctrl";; 1) order="head ctrl base";; 2) order="ctrl base head";; esac
  for f in inputs/*.s; do
    for b in $order; do
      line=$(taskset -c 2 ./compiler-$b assemble --timing -o /tmp/g3452.o "$f" 2>&1 >/dev/null; echo "status=$?")
      echo "$r $b $(basename $f) $line" | tr '\n' ' '; echo
    done
  done
done

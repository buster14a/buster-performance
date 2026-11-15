#!/bin/bash
# Lua 5.4.8's 34 files, each -c as the issue compiled them, with the options given; their summed stage clocks on stderr.
X=$1; shift
total=0
program=0
status=0
for f in inputs/lua-5.4.8/src/*.c; do
    "$X" "$@" -c -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX --time-stages -o out/lua-one.o "$f" 2> out/lua-one.err || status=1
    read -r t c < <(awk '$1=="time-stage"&&$2=="total"{t=$3} $1=="time-stage"&&$2=="check-program"{c=$3} END{print t, c}' out/lua-one.err)
    grep -v -E '^(time-|worker-budget|lowering-nodes)' out/lua-one.err >&2
    total=$(awk -v a="$total" -v b="$t" 'BEGIN{printf "%.3f", a + b}')
    program=$(awk -v a="$program" -v b="$c" 'BEGIN{printf "%.3f", a + b}')
done
printf 'time-stage\ttotal\t%s\ntime-stage\tcheck-program\t%s\n' "$total" "$program" >&2
exit $status

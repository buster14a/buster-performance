#!/usr/bin/env bash
# perf.sh TREE sqlite|main OUTPUT [probe options...]: records the probe's run with perf (cycles, user and kernel, DWARF
# call graphs) under the lock, pinned to CPU 2, into OUTPUT.data.
set -e
here="$HOME/buster-fast-bench/pp-117-claude"
. "$here/args.sh"
tree="$1"
input="$2"
output="$3"
shift 3
if [ ! -x "$here/$tree/probe" ] || [ "$here/probe.c" -nt "$here/$tree/probe" ]; then
    (cd "$here/$tree" && "$here/locked.sh" clang -O3 -g -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -w -o probe "$here/probe.c" -lm)
fi
if [ "$input" = sqlite ]; then inputs=("${sqlite[@]}"); else inputs=("${mainc[@]}"); fi
"$here/locked.sh" taskset -c 2 perf record -q -F 4999 -e cycles --call-graph dwarf,32768 -o "$output.data" "$here/$tree/probe" "$@" "${inputs[@]}"

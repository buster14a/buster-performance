#!/usr/bin/env bash
# probe.sh TREE sqlite|main [probe options...]: builds the scratch probe against TREE's sources (if needed) and runs it
# once under the lock, pinned to CPU 2.
set -e
here="$HOME/buster-fast-bench/pp-117-claude"
. "$here/args.sh"
tree="$1"
input="$2"
shift 2
if [ ! -x "$here/$tree/probe" ] || [ "$here/probe.c" -nt "$here/$tree/probe" ]; then
    (cd "$here/$tree" && "$here/locked.sh" clang -O3 -g -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -w -o probe "$here/probe.c" -lm)
fi
if [ "$input" = sqlite ]; then inputs=("${sqlite[@]}"); else inputs=("${mainc[@]}"); fi
"$here/locked.sh" taskset -c 2 "$here/$tree/probe" "$@" "${inputs[@]}"

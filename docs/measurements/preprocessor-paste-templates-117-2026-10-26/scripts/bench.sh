#!/usr/bin/env bash
# bench.sh TREE sqlite|main [benchmark options...]: one benchmark-preprocessor run under the lock, pinned to CPU 2.
set -e
here="$HOME/buster-fast-bench/pp-117-templates"
. "$here/args.sh"
tree="$1"
input="$2"
shift 2
if [ "$input" = sqlite ]; then inputs=("${sqlite[@]}"); else inputs=("${mainc[@]}"); fi
"$here/locked.sh" taskset -c 2 "$here/$tree/build/compiler" benchmark-preprocessor "$@" "${inputs[@]}"

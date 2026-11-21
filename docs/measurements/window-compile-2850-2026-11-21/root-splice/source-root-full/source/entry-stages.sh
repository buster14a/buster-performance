#!/bin/bash
set -eu
d=$(cd "$(dirname "$0")" && pwd); cc="$d/3cfa72aaf-compiler"; dir="$d/combined/stages";mkdir -p "$dir";cd "$d/../switch-inputs";source ../switch-local-args.sh;eval "args=($sqlite_arguments)"
for m in plain source dry physical; do
 x=()
 if [[ $m != plain ]];then x+=(NODE_SOURCE_QUIET=1 NODE_PROOF_NO_FP=1 NODE_PROOF_POINTERS=1 NODE_PROOF_CALLS=1 NODE_PROOF_NATIVE=1 NODE_SOURCE_ROWS=1 NODE_SPLICE_FRONT=1 NODE_SPLICE_ENABLE=1 NODE_SOURCE_STRINGS=1 NODE_SOURCE_REFRESH_POINTERS=1 NODE_SOURCE_LOCAL_ACCESS=1); fi
 if [[ $m = source ]];then x+=(NODE_SOURCE_ONLY=1); elif [[ $m != plain ]];then x+=(NODE_SOURCE_COMPACT=1 NODE_SOURCE_COMPACT_FULL=1 NODE_SOURCE_COMPACT_READS=1); fi
 if [[ $m = dry ]];then x+=(NODE_SOURCE_COMPACT_DRY=1);fi
 env "${x[@]}" "$cc" --time-stages --lanes 1 -c "${args[@]}" -o "$dir/$m.o" >"$dir/$m.out" 2>"$dir/$m.err"
done

#!/usr/bin/env bash
# Compile each source with --tier1 on the default (vector) path and with --scalar; compare the objects byte for byte.
# usage: twins.sh COMPILER OUTDIR [--flags "FLAGS"] FILE...
set -u
compiler=$1; shift
out=$1; shift
flags=""
if [ "${1:-}" = "--flags" ]; then flags=$2; shift 2; fi
mkdir -p "$out"
same=0; different=0; failed=0
for f in "$@"; do
    base=$(echo "$f" | tr '/' '_')
    v="$out/$base.v.o"; s="$out/$base.s.o"
    # shellcheck disable=SC2086
    if ! "$compiler" -c --tier1 $flags "$f" -o "$v" > "$out/$base.v.log" 2>&1; then failed=$((failed + 1)); echo "FAILED vector $f"; continue; fi
    # shellcheck disable=SC2086
    if ! "$compiler" -c --tier1 --scalar $flags "$f" -o "$s" > "$out/$base.s.log" 2>&1; then failed=$((failed + 1)); echo "FAILED scalar $f"; continue; fi
    if cmp -s "$v" "$s"; then same=$((same + 1)); rm -f "$v" "$s" "$out/$base.v.log" "$out/$base.s.log"; else different=$((different + 1)); echo "DIFFERENT $f"; fi
done
echo "same=$same different=$different failed=$failed"

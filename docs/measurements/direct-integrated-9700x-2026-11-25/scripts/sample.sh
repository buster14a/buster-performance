#!/bin/bash
set -euo pipefail
mode=$1 name=$2 tag=$3 round=$4 slot=$5 outdir=$6
shift 6
w=$PWD
output=$outdir/$name.o
if [[ $name != sqlite-rewrite || $mode == verify ]]; then rm -f "$output"; fi
snapshot() {
    cat /proc/loadavg >&2
    ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -11 >&2 || :
}
snapshot
if [[ $mode == verify ]]; then
    "$w/bin/$tag" -o "$output" "$@"
    path=full; if LC_ALL=C grep -aq 'buster direct' "$output"; then path=direct; fi
    expect=direct
    if [[ $name == locals && ( $tag == compBASE || $tag == comp3589 || $tag == comp3590 ) ]]; then expect=full; fi
    test "$path" = "$expect"
    hash=$(sha256sum "$output"); hash=${hash%% *}
    ref=$outdir/$name.$path.hash
    if [[ ! -f $ref ]]; then printf '%s\n' "$hash" > "$ref"; else test "$hash" = "$(cat "$ref")"; fi
    case $name in
        locals) cc -O0 "$w/inputs/check-locals.c" "$output" -o "$outdir/check" && timeout -k 2 10 "$outdir/check";;
        switch|unsigned) cc -O0 "$w/inputs/check-$name.c" "$output" -o "$outdir/check" && timeout -k 2 10 "$outdir/check";;
        semantics) cc "$output" -o "$outdir/check" && timeout -k 2 10 "$outdir/check";;
    esac
    printf '%s\t%s\t%s\t%s\n' "$name" "$tag" "$path" "$hash" >> "$w/objects.tsv"
else
    if [[ $name == sqlite-rewrite ]]; then test -s "$output"; fi
    stats=$("$w/bin/time-one" "$w/bin/$tag" -o "$output" "$@")
    printf '%s\t%s\t%s\t%s\t%s\n' "$name" "$round" "$slot" "$tag" "$stats" >> "$w/times.tsv"
fi
snapshot

#!/bin/bash
D=~/buster-fast-bench/653-claude
many_args()
{
    local m="$D/many-$1-$2"; local args=(-fsyntax-only)
    for ((d = 0; d < $1; d++)); do args+=(-I "$m/d$d"); done
    args+=(-I "$m/hdr" "$m/unit.c"); echo "${args[@]}"
}
cd "$D/inputs"
for f in tiny.c one.c uncompr.c deflate.c sqlite3.c; do
    echo "-- $f"
    taskset -c 2 "$D/pr/build/compiler" benchmark-preprocessor --only vectorized --listing-misses 16,0 "$f" 2>&1 | grep -E "^  vectorized|inclusive lookup|directories listed"
done
for spec in "100 2000" "200 4000"; do
    set -- $spec
    echo "-- many $1 dirs $2 headers"
    taskset -c 2 "$D/pr/build/compiler" benchmark-preprocessor --only vectorized --listing-misses 16,0 $(many_args $1 $2 | sed 's/-fsyntax-only//') 2>&1 | grep -E "^  vectorized|inclusive lookup|directories listed"
done

#!/bin/bash
# usage: same.sh A B OUT: -c -g -Wall -Wextra of sqlite 3.50.4's amalgamation, on the vector path and with --scalar,
# by out-A/compiler and out-B/compiler; the objects' and diagnostics' SHA-256 and a cmp of each pair. One hold.
set -u
. "$(dirname "$0")/common.sh"
a="$1"; b="$2"; out="$base/$3"; mkdir -p "$out"
held "$out/same.receipt" bash -c '
out="$1"; a="$2"; b="$3"; src="$4"; status=0
for path in vector scalar; do
  flag=; [ $path = scalar ] && flag=--scalar
  for x in $a $b; do
    "$(dirname "$out")/out-$x/compiler" $flag -c -g -Wall -Wextra "-I$src" "$src/sqlite3.c" -o "$out/$x-$path.o" 2> "$out/$x-$path.diag"
    echo "$x $path exit=$?" >> "$out/exits.txt"
  done
  cmp "$out/$a-$path.o" "$out/$b-$path.o" && cmp "$out/$a-$path.diag" "$out/$b-$path.diag" && echo "$path: same bytes" >> "$out/cmp.txt" || { echo "$path: DIFFERENT" >> "$out/cmp.txt"; status=1; }
done
sha256sum "$src/sqlite3.c" "$out"/*.o "$out"/*.diag > "$out/sha.txt"
wc -l "$out"/*.diag >> "$out/sha.txt"
exit $status' same "$out" "$a" "$b" "$sqlite504"
cat "$out/cmp.txt"

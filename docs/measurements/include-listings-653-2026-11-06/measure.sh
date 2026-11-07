#!/bin/bash
# #653 measurements on the 9700X: failed probes (strace -c), the preprocessor with listings on and off (one binary),
# whole processes of base and pr (ab + time-runs), the many -I case, and the files walk. Each run takes the lock alone.
set -uo pipefail
D=~/buster-fast-bench/653-claude
cd "$D"
export EXCLUSIVE_OWNER=claude-653 "EXCLUSIVE_TITLE=Solve 653 (include search listings)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/653
EX=~/buster-fast-bench/exclusive.sh
mkdir -p inputs out
cp -n ~/buster-fast-bench/claude-linker-80/inputs/sqlite-amalgamation-3530400/sqlite3.c inputs/ 2>/dev/null || true
cp -n zlib-1.3.1/*.c zlib-1.3.1/*.h inputs/ 2>/dev/null || true
printf 'int main(void)\n{\n    return 0;\n}\n' > inputs/tiny.c
printf '#include <stdio.h>\nint main(void)\n{\n    return puts("x");\n}\n' > inputs/one.c
sha256sum inputs/sqlite3.c inputs/deflate.c inputs/uncompr.c > out/inputs.sha256
# The many -I case: D empty directories before one with H guarded headers, a unit including them all.
make_many()
{
    local dirs=$1 headers=$2 m="many-$1-$2"
    rm -rf "$m"; mkdir -p "$m/hdr"
    for ((d = 0; d < dirs; d++)); do mkdir -p "$m/d$d"; done
    for ((h = 0; h < headers; h++)); do printf '#ifndef G%d\n#define G%d\nint v%d;\n#endif\n' $h $h $h > "$m/hdr/h$h.h"; printf '#include <h%d.h>\n' $h; done > "$m/unit.c"
}
make_many 10 2000; make_many 100 2000; make_many 200 4000
many_args()
{
    local m="$D/many-$1-$2"; local args=(-fsyntax-only)
    for ((d = 0; d < $1; d++)); do args+=(-I "$m/d$d"); done
    args+=(-I "$m/hdr" "$m/unit.c"); echo "${args[@]}"
}
cd inputs
echo "== strace -f -c (failed openat / all openat, getdents64, fstatfs)"
for t in base pr; do
    for f in tiny.c one.c uncompr.c deflate.c sqlite3.c; do
        $EX strace -f -c -o "$D/out/strace-$t-$f.txt" taskset -c 2 "$D/$t/build/compiler" -c "$f" -o "$D/out/$t-$f.o" > /dev/null 2>&1
        printf '%s %s: ' "$t" "$f"; awk '$NF == "openat" || $NF == "getdents64" || $NF == "fstatfs" || $NF == "newfstatat" { printf "%s %s calls %s errors; ", $NF, $4, (NF == 6 ? $5 : 0) }' "$D/out/strace-$t-$f.txt"; echo
    done
    for spec in "10 2000" "100 2000" "200 4000"; do
        set -- $spec
        $EX strace -f -c -o "$D/out/strace-$t-many-$1-$2.txt" taskset -c 2 "$D/$t/build/compiler" $(many_args $1 $2) > /dev/null 2>&1
        printf '%s many %s dirs %s headers: ' "$t" "$1" "$2"; awk '$NF == "openat" || $NF == "getdents64" || $NF == "fstatfs" || $NF == "newfstatat" { printf "%s %s calls %s errors; ", $NF, $4, (NF == 6 ? $5 : 0) }' "$D/out/strace-$t-many-$1-$2.txt"; echo
    done
done
for f in tiny.c one.c uncompr.c deflate.c sqlite3.c; do cmp "$D/out/base-$f.o" "$D/out/pr-$f.o" && echo "$f: base and pr objects identical"; done
echo "== benchmark-preprocessor --listing-misses 16,0 (pr binary, CPU 2)"
for f in one.c uncompr.c deflate.c sqlite3.c; do
    echo "-- $f"
    $EX taskset -c 2 "$D/pr/build/compiler" benchmark-preprocessor --listing-misses 16,0 "$f" 2>&1 | grep -E "^  (vectorized|scalar)|directories listed|include"
done
for spec in "100 2000" "200 4000"; do
    set -- $spec
    echo "-- many $1 dirs $2 headers"
    $EX taskset -c 2 "$D/pr/build/compiler" benchmark-preprocessor --listing-misses 16,0 $(many_args $1 $2 | sed 's/-fsyntax-only//') 2>&1 | grep -E "^  (vectorized|scalar)|directories listed"
done
echo "== whole processes: ab --rounds 5 time-runs --runs 21 (-c, CPU 2)"
"$D/pr/build/compiler" ab --rounds 5 --cpu 2 --lock $EX "$D/base" "$D/pr" -- time-runs --runs 21 --list -c tiny.c -o /tmp/653-claude-tiny.o --list -c one.c -o /tmp/653-claude-one.o \
    --list -c uncompr.c -o /tmp/653-claude-uncompr.o --list -c deflate.c -o /tmp/653-claude-deflate.o > "$D/out/ab-small.txt" 2>&1
echo "ab small status $?"
"$D/pr/build/compiler" ab --rounds 5 --cpu 2 --lock $EX "$D/base" "$D/pr" -- time-runs --runs 11 --list -c sqlite3.c -o /tmp/653-claude-sqlite3.o > "$D/out/ab-sqlite.txt" 2>&1
echo "ab sqlite status $?"
"$D/pr/build/compiler" ab --rounds 3 --cpu 2 --lock $EX "$D/base" "$D/pr" -- time-runs --runs 11 --list $(many_args 10 2000) --list $(many_args 100 2000) --list $(many_args 200 4000) > "$D/out/ab-many.txt" 2>&1
echo "ab many status $?"
cd "$D"
echo "== benchmark-files (main.c of the pr tree)"
for t in base pr; do
    (cd pr && $EX "$D/$t/build/compiler" benchmark-files -march=znver5 -Isrc -fwrapv -funsigned-char src/buster/compiler/main.c > "$D/out/files-$t.txt" 2>&1)
done
echo measure-done

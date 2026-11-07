#!/bin/bash
# #653 measurements on the 9700X, in few short holds of the lock: strace counts (one hold), the preprocessor with
# listings on and off in one binary (one hold), whole processes of base and pr interleaved by time-runs (a hold each),
# the many -I case, the files walk, and the listing's cost against a failed probe.
set -uo pipefail
D=~/buster-fast-bench/653-claude
cd "$D"
./update.sh > update.log 2>&1 || exit 1
cat update.log
export EXCLUSIVE_OWNER=claude-653 "EXCLUSIVE_TITLE=Solve 653 (include search listings)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/653
EX=~/buster-fast-bench/exclusive.sh
cd inputs
many_args()
{
    local m="$D/many-$1-$2"; local args=(-fsyntax-only)
    for ((d = 0; d < $1; d++)); do args+=(-I "$m/d$d"); done
    args+=(-I "$m/hdr" "$m/unit.c"); echo "${args[@]}"
}
cat > "$D/strace-batch.sh" <<'EOS'
#!/bin/bash
D=~/buster-fast-bench/653-claude
many_args()
{
    local m="$D/many-$1-$2"; local args=(-fsyntax-only)
    for ((d = 0; d < $1; d++)); do args+=(-I "$m/d$d"); done
    args+=(-I "$m/hdr" "$m/unit.c"); echo "${args[@]}"
}
cd "$D/inputs"
for t in base pr; do
    for f in tiny.c one.c uncompr.c deflate.c sqlite3.c; do
        strace -f -c -o "$D/out/strace-$t-$f.txt" taskset -c 2 "$D/$t/build/compiler" -c "$f" -o "$D/out/$t-$f.o" > /dev/null 2>&1
        printf '%s %s: ' "$t" "$f"; awk '$NF == "openat" || $NF == "getdents64" || $NF == "fstatfs" || $NF == "newfstatat" { printf "%s %s calls %s errors; ", $NF, $4, (NF == 6 ? $5 : 0) }' "$D/out/strace-$t-$f.txt"; echo
    done
    for spec in "10 2000" "100 2000" "200 4000"; do
        set -- $spec
        strace -f -c -o "$D/out/strace-$t-many-$1-$2.txt" taskset -c 2 "$D/$t/build/compiler" $(many_args $1 $2) > /dev/null 2>&1
        printf '%s many %s dirs %s headers: ' "$t" "$1" "$2"; awk '$NF == "openat" || $NF == "getdents64" || $NF == "fstatfs" || $NF == "newfstatat" { printf "%s %s calls %s errors; ", $NF, $4, (NF == 6 ? $5 : 0) }' "$D/out/strace-$t-many-$1-$2.txt"; echo
    done
done
for f in tiny.c one.c uncompr.c deflate.c sqlite3.c; do cmp "$D/out/base-$f.o" "$D/out/pr-$f.o" && echo "$f: base and pr objects identical"; done
EOS
cat > "$D/pp-batch.sh" <<'EOS'
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
EOS
chmod +x "$D/strace-batch.sh" "$D/pp-batch.sh"
echo "== strace -f -c"
$EX bash "$D/strace-batch.sh"
echo "== whole processes: time-runs, base and pr interleaved, 2 copies each (CPU 2), three holds"
for round in 1 2 3; do
    $EX taskset -c 2 "$D/pr/build/compiler" time-runs --runs 15 --copies 2 --directory /tmp --build base "$D/base/build/compiler" --build pr "$D/pr/build/compiler" \
        --list -c tiny.c -o /tmp/653-claude-tiny.o --list -c one.c -o /tmp/653-claude-one.o --list -c uncompr.c -o /tmp/653-claude-uncompr.o \
        --list -c deflate.c -o /tmp/653-claude-deflate.o --list -c sqlite3.c -o /tmp/653-claude-sqlite3.o > "$D/out/time-small-$round.txt" 2>&1
    echo "time-runs small round $round status $?"
done
$EX taskset -c 2 "$D/pr/build/compiler" time-runs --runs 7 --copies 2 --directory /tmp --build base "$D/base/build/compiler" --build pr "$D/pr/build/compiler" \
    --list $(many_args 10 2000) --list $(many_args 100 2000) --list $(many_args 200 4000) > "$D/out/time-many.txt" 2>&1
echo "time-runs many status $?"
cd "$D"
echo "== benchmark-files (main.c of the pr tree)"
for t in base pr; do
    (cd pr && $EX "$D/$t/build/compiler" benchmark-files -march=znver5 -Isrc -fwrapv -funsigned-char src/buster/compiler/main.c > "$D/out/files-$t.txt" 2>&1)
    echo "benchmark-files $t status $?"
done
echo measure-done

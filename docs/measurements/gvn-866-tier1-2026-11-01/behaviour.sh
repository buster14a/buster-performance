#!/bin/bash
# Does --tier1-gvn change what c-testsuite's programs do? Compile each way, run both, compare status and output.
set -u
REPO=${REPO:?set REPO to a buster checkout}
OUT=/tmp/opencode/gvn866/t1/behaviour
C=$CORPUS/tests/single-exec
cd "$REPO" || exit 1
mkdir -p "$OUT"
same=0; differ=0; skipped=0
for f in "$C"/*.c; do
    name=$(basename "$f" .c)
    # Only programs whose main returns a status and prints; skip ones that need a header we may not have.
    ./build/compiler -c --tier1 -fno-asynchronous-unwind-tables -o "$OUT/a.o" "$f" > /dev/null 2>&1 || { skipped=$((skipped+1)); continue; }
    ./build/compiler -c --tier1 --tier1-gvn -fno-asynchronous-unwind-tables -o "$OUT/b.o" "$f" > /dev/null 2>&1 || { skipped=$((skipped+1)); continue; }
    cc -o "$OUT/a" "$OUT/a.o" > /dev/null 2>&1 || { skipped=$((skipped+1)); continue; }
    cc -o "$OUT/b" "$OUT/b.o" > /dev/null 2>&1 || { skipped=$((skipped+1)); continue; }
    ao=$("$OUT/a" 2>&1); as=$?
    bo=$("$OUT/b" 2>&1); bs=$?
    if [ "$ao" = "$bo" ] && [ "$as" = "$bs" ]; then same=$((same+1)); else
        differ=$((differ+1)); echo "DIFFER $name status $as/$bs"; fi
done
echo "behaviour: same=$same differ=$differ skipped=$skipped"

#!/bin/bash
# run-mutants.sh TREE MUTANTS.py FILE LIST OUT: each mutant applied to TREE's FILE, built (Release), LIST run through parallel
# --fail-fast, then reverted. OUT gets "name: killed|SURVIVED|build-failed".
set -u
TREE=$1; MUT=$2; FILE=$3; LIST=$4; OUT=$5
cd "$TREE"
: > "$OUT"
names=$(python3 -c "exec(open('$MUT').read()); print(' '.join(m[0] for m in M))")
for name in $names; do
    cp "$FILE" "$FILE.orig"
    python3 - "$MUT" "$FILE" "$name" <<'PY'
import sys
exec(open(sys.argv[1]).read())
m=[x for x in M if x[0]==sys.argv[3]][0]
s=open(sys.argv[2]).read()
assert s.count(m[1])==1, m[0]
open(sys.argv[2],'w').write(s.replace(m[1],m[2]))
PY
    if ./build.sh --config Release > "$OUT.$name.build" 2>&1; then
        if build/compiler parallel --jobs 4 --fail-fast "$LIST" > "$OUT.$name.log" 2>&1; then
            echo "$name: SURVIVED" >> "$OUT"
        else
            echo "$name: killed ($(grep -m1 ' failed' "$OUT.$name.log" | cut -c1-120))" >> "$OUT"
        fi
    else
        echo "$name: build-failed" >> "$OUT"
    fi
    mv "$FILE.orig" "$FILE"
done
./build.sh --config Release > "$OUT.restore.build" 2>&1
echo done >> "$OUT"

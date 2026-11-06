#!/bin/bash
# diag-final.sh: 9fa45bbb's diagnostics on the corpus with -Wall -Wextra (vector, --scalar, the x86-64 host build),
# compared with main's (diag/A-*, diag/D-*), as diag/{G,H,X}-*.
set -u
D=/home/david/.cache/droid-1340
cd "$D" || exit 2
log=$D/diag-final.log
: > "$log"
tree=$D/tree-gate
if [[ ! -f $tree/COMMIT ]]; then
    mkdir -p "$tree"
    (set -o pipefail; git -C "$D/wt" archive 9fa45bbbc2c5e2b4d7db31b729c0ef0172d69200 | tar -x -C "$tree") || exit 2
    echo 9fa45bbbc2c5e2b4d7db31b729c0ef0172d69200 > "$tree/COMMIT"
fi
(cd "$tree" && BUSTER_HOST_ARCH=x86-64 ./build.sh) > "$D/build-gate-x86-64.log" 2>&1 || { echo "build x86-64 failed" >> "$log"; exit 1; }
cp "$tree/build/compiler" bin/compiler-gate-x86-64
sha256sum bin/compiler-main bin/compiler-gate bin/compiler-gate-x86-64 >> "$log"
rm -rf diag/G-s diag/G-c diag/H-s diag/H-c diag/X-s
awk '$2=="diag/A-s" || $2=="diag/A-c"' diag/jobs | sed 's|^bin/compiler-main diag/A-|bin/compiler-gate diag/G-|' > diag/jobs-final
awk '$2=="diag/D-s" || $2=="diag/D-c"' diag/jobs | sed 's|^bin/compiler-main diag/D-|bin/compiler-gate diag/H-|' >> diag/jobs-final
awk '$2=="diag/A-s"' diag/jobs | sed 's|^bin/compiler-main diag/A-s|bin/compiler-gate-x86-64 diag/X-s|' >> diag/jobs-final
wc -l diag/jobs-final >> "$log"
xargs -P "${CORES:-4}" -L1 ./diag.sh < diag/jobs-final
echo "runs done $?" >> "$log"
for pair in G-s:A-s G-c:A-c H-s:D-s H-c:D-c X-s:D-s; do
    a=${pair%%:*}; b=${pair#*:}
    n=$(find "diag/$a" -type f | wc -l)
    if diff -r "diag/$a" "diag/$b" > "diag/diff-$a-$b.txt"; then r=identical; else r=DIFFERENT; fi
    echo "$a vs $b: $n files, $r" >> "$log"
done
echo all-done >> "$log"

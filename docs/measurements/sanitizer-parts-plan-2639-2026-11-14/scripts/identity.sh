#!/bin/bash
# identity.sh TAG SANITIZER: the whole build's executable (src, main) against the split one's (split), under the 9700X's
# lock: function symbols (address, size, name) and the .text instructions with RIP-relative displacements and symbol
# names left out, the differing lines by kind, as the Release record's identity.txt (build-parallel-native-2026-11-10).
set -u
base=~/buster-fast-bench/2639-claude
tag=$1
sanitizer=$2
out=$base/results/$tag
mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-2639
export EXCLUSIVE_TITLE="#2639: the sanitizer builds' critical path"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2639
export OUT="$out" A="$base/src/build/cmake/native-$sanitizer-O3/Release/compiler" B="$base/split/build/cmake/native-$sanitizer-O3/Release/compiler"
~/buster-fast-bench/exclusive.sh timeout -k 10 900 bash -c '
    { date -Is; cat /var/lib/buster-9700x/owner; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -12; } > "$OUT/before.txt"
    sha256sum "$A" "$B" > "$OUT/sha256.txt"
    functions() { nm -S --defined-only "$1" | awk "\$3 ~ /^[tTwW]\$/ && \$4 !~ /\\.buster_split\$/ {print \$1, \$2, \$4}" | LC_ALL=C sort; }
    text() { objdump -d --no-show-raw-insn --no-addresses -j .text "$1" | sed -E -e "1,4d" -e "s/[[:space:]]*#.*\$//" -e "s/<[^>]*>//g" -e "s/[[:space:]]+/ /g" -e "s/^ //" -e "s/0x[0-9a-f]+\\(%rip\\)/D(%rip)/g"; }
    functions "$A" > "$OUT/a.functions"; functions "$B" > "$OUT/b.functions"
    text "$A" > "$OUT/a.text"; text "$B" > "$OUT/b.text"
    {
        echo "functions: $(wc -l < "$OUT/a.functions") and $(wc -l < "$OUT/b.functions"); address+size+name only in A: $(comm -23 "$OUT/a.functions" "$OUT/b.functions" | wc -l), only in B: $(comm -13 "$OUT/a.functions" "$OUT/b.functions" | wc -l)"
        echo "names only in A: $(comm -23 <(awk "{print \$3}" "$OUT/a.functions" | LC_ALL=C sort -u) <(awk "{print \$3}" "$OUT/b.functions" | LC_ALL=C sort -u) | wc -l), only in B: $(comm -13 <(awk "{print \$3}" "$OUT/a.functions" | LC_ALL=C sort -u) <(awk "{print \$3}" "$OUT/b.functions" | LC_ALL=C sort -u) | wc -l)"
        echo "same name, other size: $(join -1 3 -2 3 <(LC_ALL=C sort -k3 "$OUT/a.functions") <(LC_ALL=C sort -k3 "$OUT/b.functions") | awk "\$3 != \$5" | wc -l)"
        echo "allocated sections (name size address), A then B where they differ:"
        diff <(readelf -SW "$A" | sed -n "s/^ *\\[ *[0-9]*\\] //p" | awk "\$7 ~ /A/ {print \$1, \$5, \$3}") <(readelf -SW "$B" | sed -n "s/^ *\\[ *[0-9]*\\] //p" | awk "\$7 ~ /A/ {print \$1, \$5, \$3}")
        echo ".text instructions: $(wc -l < "$OUT/a.text") and $(wc -l < "$OUT/b.text"); differing lines by kind:"
        diff "$OUT/a.text" "$OUT/b.text" | grep "^[<>]" | sort | uniq -c | sort -rn | head -40
    } > "$OUT/identity.txt"
    join -1 3 -2 3 <(LC_ALL=C sort -k3 "$OUT/a.functions") <(LC_ALL=C sort -k3 "$OUT/b.functions") | awk "\$3 != \$5" > "$OUT/resized.txt"
    rm -f "$OUT/a.text" "$OUT/b.text"
    { date -Is; cat /proc/loadavg; } > "$OUT/after.txt"
' 2> "$out/exclusive.stderr"
echo "done $?" >> "$out/exclusive.stderr"

#!/bin/bash
# #2924 C12c-5 (a): the area's runners under MSan, ASan (with UBSan) and UBSan builds of head, in the session's container.
set -uo pipefail
tree=$1; out=$2
mkdir -p "$out"; : >> "$out/status.txt"
cd "$tree"
TC=$(tools/ci/session-toolchain.sh stage); export PATH="$TC:$PATH"
for s in memory address undefined; do
    if [ ! -x "$out/compiler-$s" ]; then
        BUSTER_SANITIZER=$s ./build.sh --config Release > "$out/build-$s.log" 2>&1 || { echo "build $s failed" >> "$out/status.txt"; continue; }
        exe=$(tail -1 "$out/build-$s.log" | sed -n 's/.*: \(build\/cmake\/[^ ]*\/compiler\), published.*/\1/p'); exe=${exe:-build/compiler}
        cp "$exe" "$out/compiler-$s"
    fi
    for r in "test-bindings" "test-parser-bindings" "test-environments" "test-checker-deferred" "test-checker --part 1/8" "test-checker --part 2/8" "test-checker --part 3/8" "test-checker --part 4/8" "test-checker --part 5/8" "test-checker --part 6/8" "test-checker --part 7/8" "test-checker --part 8/8"; do
        timeout 5400 "$out/compiler-$s" $r > "$out/$s-$(echo "$r" | tr " /" "__").log" 2>&1; echo "$s $r: $?" >> "$out/status.txt"
    done
done
echo done >> "$out/status.txt"

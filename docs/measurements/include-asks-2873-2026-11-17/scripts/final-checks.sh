#!/bin/bash
# final-checks.sh: the final tree's native Release build, then the includes' list, the heavy list and the parse of the
# compiler's own source, by run-list.sh and parse.sh; progress in progress.txt.
out=/home/user/keep/bench-files/final
tree=/home/user/buster-files
cd "$tree" || exit 1
echo "final-checks at $(git rev-parse --short HEAD) $(date -u +%H:%M)" >> "$out/progress.txt"
BUSTER_HOST_ARCH=native ./build.sh --config Release > "$out/build-native2.log" 2>&1
echo "native Release build: exit $?" >> "$out/progress.txt"
"$out/run-list.sh" "$tree" native "$out/includes.tests" native2-includes 3
"$out/run-list.sh" "$tree" native "$out/heavy.tests" native2-heavy 1
"$out/parse.sh" "$tree" native > "$out/native2-parse.log" 2>&1
echo "native2-parse: exit $?" >> "$out/progress.txt"
echo "final-checks done $(date -u +%H:%M)" >> "$out/progress.txt"

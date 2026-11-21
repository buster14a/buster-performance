#!/bin/bash
# checks-rows.sh: the rows pieces' checks (X's rows on the window; the shadow with --window-rows too) in the cloud
# container, in the worktree TREE at the commit under test: a native Release build; the whole test-checker; the shadow
# with C on the window on sqlite3.c, Lua, musl and the compiler's own source, with the default warnings and with -Wall
# -Wextra; the shadow's other modes on sqlite3.c and Lua; the self-check, the self-parse and the call graph; the
# ownership check; and the complete driver's (the inventory's headings that take the compiler's own source with
# -DBUSTER_COMPLETE_DRIVER=1, extracted from the tree's tools/ci/correctness.tests, and the workflow's parse). Progress
# in OUT/progress.txt. One heavy thing at a time: the container's 15 GB is one limit for every command.
set -u
tree=${TREE:-/home/user/buster}
out=${OUT:?OUT}
keep=/home/user/keep
mkdir -p "$out" "$out/fix"
cd "$tree" || exit 1
{ git rev-parse HEAD; git status --short; } > "$out/revision.txt"
echo "checks at $(git rev-parse --short HEAD) $(date -u +%H:%M)" >> "$out/progress.txt"
BUSTER_HOST_ARCH=native ./build.sh --config Release > "$out/build.log" 2>&1
echo "build status $?" >> "$out/progress.txt"
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
cp build/compiler "$out/compiler"
TREE=$tree $keep/checker.sh "$out/test-checker" "$out/compiler"
echo "checker done: $(grep -c 'status 0' "$out/test-checker/status.txt") of 8 parts with status 0" >> "$out/progress.txt"
TREE=$tree $keep/shadow-limited.sh "$out/shadow" "$out/compiler" "sqlite lua musl" 2 \
    "--passes 0 --window-rows --list 20" \
    "--passes 0 --window-rows -Wall -Wextra --list 20" \
    "--passes 0 --window-contexts --list 20" \
    "--passes 0 --window-contexts -Wall -Wextra --list 20"
TREE=$tree $keep/shadow-limited.sh "$out/shadow" "$out/compiler" "main" 1 \
    "--passes 0 --window-rows --list 20" \
    "--passes 0 --window-rows -Wall -Wextra --list 20"
echo "shadow done: $(grep -c 'status 0' "$out/shadow/status.txt") of 14 runs with status 0" >> "$out/progress.txt"
TREE=$tree $keep/shadow-limited.sh "$out/modes" "$out/compiler" "sqlite lua" 2 \
    "--passes 0" "--passes 0 --front" "--passes 0 --front-lean" "--passes 0 --front-types" "--passes 0 --front-facts" "--passes 0 --front-tests" \
    "--passes 0 --front-window" "--passes 0 --window-tests" "--passes 0 --facts" "--passes 0 --facts-lean" "--passes 0 --facts-loads"
echo "modes done: $(grep -c 'status 0' "$out/modes/status.txt") of $(grep -c 'status' "$out/modes/status.txt") runs with status 0" >> "$out/progress.txt"
./build/compiler -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror src/buster/compiler/main.c > "$out/self-check.txt" 2>&1
echo "self-check status $?" >> "$out/progress.txt"
./build/compiler parse -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char --predefines build/predefines.h src/buster/compiler/main.c > "$out/self-parse.txt" 2>&1
echo "self-parse status $?" >> "$out/progress.txt"
./build/compiler test-call-graph > "$out/test-call-graph.txt" 2>&1
echo "test-call-graph status $?" >> "$out/progress.txt"
./build.sh check-call-graph --config Release > "$out/check-call-graph.txt" 2>&1
echo "check-call-graph status $?" >> "$out/progress.txt"
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
cc -std=c17 -O2 -o "$out/br" tools/ci/build_regression.c && "$out/br" --ownership-only "$tree/build/compiler" > "$out/ownership.txt" 2>&1
echo "ownership status $?" >> "$out/progress.txt"
# The complete driver's: the lists from this tree's inventory.
python3 - "$out/fix" <<'PY'
import re, sys
text = open('tools/ci/correctness.tests').read()
blocks = re.split(r'(?m)^(?==\= )', text)
heavy_names = ("Compare main.c's checking and its functions and objects with clang's", "Compile main.c by -c, its referenced definitions and all of them, by both paths")
light, heavy = [], []
for b in blocks:
    if b.startswith('== ') and 'BUSTER_COMPLETE_DRIVER=1' in b:
        (heavy if any(b.startswith('== ' + n) for n in heavy_names) else light).append(b)
open(sys.argv[1] + '/light.tests', 'w').write(''.join(light))
open(sys.argv[1] + '/heavy.tests', 'w').write(''.join(heavy))
PY
export BUSTER_HOST_ARCH=native
mapfile -d '' -t host_flags < <(./build.sh print-host-flags)
clang -dM -E "${host_flags[@]}" -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
for list in light heavy; do
    start=$(date +%s)
    timeout 3000 ./build/compiler parallel --jobs 1 "$out/fix/$list.tests" > "$out/complete-$list.log" 2>&1
    echo "complete-$list: exit $? in $(( $(date +%s) - start )) s" >> "$out/progress.txt"
done
./build/compiler parse -fsyntax-only "${host_flags[@]}" -Isrc -fwrapv -funsigned-char --predefines build/predefines.h -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c > "$out/complete-parse.log" 2>&1
echo "complete-parse: exit $?" >> "$out/progress.txt"
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
echo "all done $(date -u +%H:%M)" >> "$out/progress.txt"

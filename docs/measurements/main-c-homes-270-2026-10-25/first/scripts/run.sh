#!/bin/bash
# run.sh: #270's A/B on exact commits, main 5863eeda (base, PR #424's base) against the PR's head 9b391d4b (head), each
# tree a `git archive` of its commit. Every build and every run takes the 9700X's lock for itself alone:
# 1. builds: 3 rounds of each tree with debug information (build.sh's default) and without it (BUSTER_DEBUG_INFO=0, the
#    9700X job's), the trees in an order that alternates by round; each build's wall, user and system time (bash's
#    `time`, the build's processes included), build.sh's own report, the executable's size and its functions. The last
#    builds, without debug information, are the A/B's executables.
# 2. one run: the generated code, every program of c-testsuite's declared subset compiled by both executables
#    (`--verify NAME.c -o program -lm`, as test-c-testsuite links them, and `-c`), compared byte for byte; and the
#    driver's command lines run once by each executable, which must exit with status 0.
# 3. ab --rounds 5 --cpu 2 --lock: the benchmarks whose code the homes move and the whole driver (time-runs), from the
#    base tree, whose sources and predefines are the inputs, each run pinned to CPU 2 and locked alone.
set -u
D=~/buster-fast-bench/build-270-claude/ab2
L=$D/run.log
export EXCLUSIVE_OWNER=claude-270
export EXCLUSIVE_TITLE="Build: main.c's compile is build.sh's critical path (#270)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/424
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
LOCK=~/buster-fast-bench/exclusive.sh
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
# The driver takes the benchmarks' options but --no-default-config, a clang option.
driver=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" --clang-features --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
self=(-march=native -Isrc -fwrapv -funsigned-char --predefines build/predefines.h src/buster/compiler/main.c)

echo "=== start $(date -Is)" >> "$L"
if [ ! -d "$D/c-testsuite/tests/single-exec" ]; then
    git init -q --template= "$D/c-testsuite"
    git -C "$D/c-testsuite" fetch -q --depth 1 https://github.com/c-testsuite/c-testsuite 5c7275656d751de0e68b2d340a95b5681858ed07
    git -C "$D/c-testsuite" checkout -q FETCH_HEAD
fi
echo "c-testsuite: $(git -C "$D/c-testsuite" rev-parse HEAD)" >> "$L"

build()
{
    echo "== build round $1 tree $2 debug $3 $(date -Is)" >> "$L"
    "$LOCK" bash -c 'cd "$1" && TIMEFORMAT="build wall: %R s, user %U s, system %S s" && time BUSTER_DEBUG_INFO=$2 ./build.sh &&
        echo "executable: $(stat -c %s build/compiler) bytes; $(size build/compiler | tail -1 | awk "{print \"text \" \$1 \", data \" \$2 \", bss \" \$3}"); $(nm build/compiler | grep -c " [tT] ") functions"' \
        _ "$D/$2" "$3" >> "$L" 2>&1 || echo "build failed: round $1 tree $2 debug $3" >> "$L"
}
for round in 1 2 3; do
    if [ $((round % 2)) -eq 1 ]; then trees=(base head); else trees=(head base); fi
    for debug in 1 0; do
        for tree in "${trees[@]}"; do
            build "$round" "$tree" "$debug"
        done
    done
done

clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > "$D/base/build/predefines.h"
echo "== identity $(date -Is)" >> "$L"
"$LOCK" bash -c '
    D=$1; out=$(mktemp -d)
    same=0; different=0; refused=0
    for name in $(grep -v "^#" "$D/base/tests/c-testsuite/subset.txt"); do
        for tree in base head; do
            mkdir -p "$out/$tree"
            (cd "$out/$tree" && "$D/$tree/build/compiler" --verify "$D/c-testsuite/tests/single-exec/$name.c" -o "$name" -lm > "$name.log" 2>&1; echo "status $?" >> "$name.log"
             "$D/$tree/build/compiler" -c "$D/c-testsuite/tests/single-exec/$name.c" -o "$name.o" >> "$name.log" 2>&1; echo "status $?" >> "$name.log")
        done
        for file in "$name" "$name.o" "$name.log"; do
            if [ ! -e "$out/base/$file" ] && [ ! -e "$out/head/$file" ]; then refused=$((refused + 1))
            elif cmp -s "$out/base/$file" "$out/head/$file"; then same=$((same + 1))
            else different=$((different + 1)); echo "differs: $file"; fi
        done
    done
    echo "identity: $same files the same, $different different, $refused not written"
    for tree in base head; do echo "$tree outputs: $(ls "$out/$tree" | grep -vc "\.")" executables, $(ls "$out/$tree" | grep -c "\.o$") objects; done
    rm -rf "$out"
    cd "$D/base"
    shift
    for tree in base head; do
        "$D/$tree/build/compiler" -fsyntax-only "$@" > /dev/null 2>&1; echo "$tree -fsyntax-only sqlite3.c: status $?"
        "$D/$tree/build/compiler" -fsyntax-only '"${self[*]}"' > /dev/null 2>&1; echo "$tree -fsyntax-only main.c: status $?"
    done' _ "$D" "${driver[@]}" "$C/sqlite/sqlite3.c" >> "$L" 2>&1

echo "== ab $(date -Is)" >> "$L"
cd "$D/base"
"$D/base/build/compiler" ab --rounds 5 --cpu 2 --lock "$LOCK" "$D/base" "$D/head" \
    -- benchmark-checker-source "${system[@]}" "$C/sqlite/sqlite3.c" \
    -- benchmark-checker-bindings --passes 5 "${system[@]}" "$C/sqlite/sqlite3.c" \
    -- benchmark-parser-bindings "${self[@]}" \
    -- benchmark-gnu "${self[@]}" \
    -- benchmark-assembler \
    -- benchmark-foreign-strings --counts 64,4096 --runs 3 \
    -- benchmark-debug \
    -- benchmark-lexer src \
    -- benchmark-x86-encoder --only x86_encode_64 \
    -- time-runs --runs 11 --list -fsyntax-only "${driver[@]}" "$C/sqlite/sqlite3.c" --list -fsyntax-only "${self[@]}" >> "$L" 2>&1
echo "ab status $?" >> "$L"
echo "done $(date -Is)" >> "$L"

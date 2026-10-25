#!/bin/bash
# run.sh: #270's requalification on the current pair, main 51ab0b63 (base, PR #424's base after its merge of main)
# against the PR's head 6847c1db (head), each tree a `git archive` of its commit. Every build and every run takes the
# 9700X's lock for itself alone:
# 1. builds: one round of each tree with debug information (build.sh's default), then three rounds without it
#    (BUSTER_DEBUG_INFO=0, the 9700X job's), the trees in an order that alternates by round; each build's wall, user and
#    system time (bash's `time`, the build's processes included), build.sh's own report, the executable's size and its
#    functions. The last builds, without debug information, are the A/B's executables.
# 2. one run: the generated code, every program of c-testsuite's declared subset compiled by both executables
#    (`--verify NAME.c -o program -lm`, as test-c-testsuite links them, and `-c`), compared byte for byte; and the
#    whole drivers' command lines run once by each executable, which must exit with status 0.
# 3. ab --rounds 5 --cpu 2 --lock: the lexer's and the assembler's benchmarks, whose code main changed since the first
#    study, the encoder's, and the whole drivers that run the homed entry points (time-runs: -E, parse and the
#    checker's -fsyntax-only on sqlite3.c, the direct path's compile and link and -c of c-testsuite's largest program),
#    from the base tree, whose sources are the inputs, each run pinned to CPU 2 and locked alone.
set -u
D=~/buster-fast-bench/build-270-claude/ab3
L=$D/run.log
export EXCLUSIVE_OWNER=claude-270
export EXCLUSIVE_TITLE="Build: main.c's compile is build.sh's critical path (#270)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/424
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
LOCK=~/buster-fast-bench/exclusive.sh
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
# The driver takes the benchmarks' options but --no-default-config, a clang option.
driver=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" --clang-features --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
program=$D/c-testsuite/tests/single-exec/00216.c

echo "=== start $(date -Is)" >> "$L"
if [ ! -d "$D/c-testsuite/tests/single-exec" ]; then
    git init -q --template= "$D/c-testsuite"
    git -C "$D/c-testsuite" fetch -q --depth 1 https://github.com/c-testsuite/c-testsuite 5c7275656d751de0e68b2d340a95b5681858ed07
    git -C "$D/c-testsuite" checkout -q FETCH_HEAD
fi
echo "c-testsuite: $(git -C "$D/c-testsuite" rev-parse HEAD)" >> "$L"
mkdir -p "$D/out"

build()
{
    echo "== build round $1 tree $2 debug $3 $(date -Is)" >> "$L"
    "$LOCK" bash -c 'cd "$1" && TIMEFORMAT="build wall: %R s, user %U s, system %S s" && time BUSTER_DEBUG_INFO=$2 ./build.sh &&
        echo "executable: $(stat -c %s build/compiler) bytes; $(size build/compiler | tail -1 | awk "{print \"text \" \$1 \", data \" \$2 \", bss \" \$3}"); $(nm build/compiler | grep -c " [tT] ") functions"' \
        _ "$D/$2" "$3" >> "$L" 2>&1 || echo "build failed: round $1 tree $2 debug $3" >> "$L"
}
build 1 base 1
build 1 head 1
for round in 1 2 3; do
    if [ $((round % 2)) -eq 1 ]; then trees=(head base); else trees=(base head); fi
    for tree in "${trees[@]}"; do
        build "$round" "$tree" 0
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
    for tree in base head; do echo "$tree outputs: $(ls "$out/$tree" | grep -vc "\.")" executables, $(ls "$out/$tree" | grep -c "\.o$") objects, $(cat "$out/$tree"/*.log | grep -c "^status 0$") zero statuses; done
    rm -rf "$out"
    cd "$D/base"
    shift
    program=$1
    shift
    for tree in base head; do
        "$D/$tree/build/compiler" -E -o /dev/null "$@" > /dev/null 2>&1; echo "$tree -E sqlite3.c: status $?"
        "$D/$tree/build/compiler" parse -fsyntax-only "$@" > /dev/null 2>&1; echo "$tree parse -fsyntax-only sqlite3.c: status $?"
        "$D/$tree/build/compiler" -fsyntax-only "$@" > /dev/null 2>&1; echo "$tree -fsyntax-only sqlite3.c: status $?"
        "$D/$tree/build/compiler" -o "$D/out/check" -lm "$program" > /dev/null 2>&1; echo "$tree compile and link 00216.c: status $?, the program: $("$D/out/check" > /dev/null 2>&1; echo $?)"
        "$D/$tree/build/compiler" -c -o "$D/out/check.o" "$program" > /dev/null 2>&1; echo "$tree -c 00216.c: status $?"
    done' _ "$D" "$program" "${driver[@]}" "$C/sqlite/sqlite3.c" >> "$L" 2>&1

echo "== ab $(date -Is)" >> "$L"
cd "$D/base"
"$D/base/build/compiler" ab --rounds 5 --cpu 2 --lock "$LOCK" "$D/base" "$D/head" \
    -- benchmark-lexer src \
    -- benchmark-assembler \
    -- benchmark-x86-encoder --only x86_encode_64 \
    -- time-runs --runs 21 --list -E -o /dev/null "${driver[@]}" "$C/sqlite/sqlite3.c" \
        --list parse -fsyntax-only "${driver[@]}" "$C/sqlite/sqlite3.c" \
        --list -fsyntax-only "${driver[@]}" "$C/sqlite/sqlite3.c" \
        --list -o "$D/out/program" -lm "$program" \
        --list -c -o "$D/out/program.o" "$program" >> "$L" 2>&1
echo "ab status $?" >> "$L"
echo "done $(date -Is)" >> "$L"

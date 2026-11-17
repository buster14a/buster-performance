#!/bin/bash
# #2924 phase C, the disassembler's PR: main's and the head's Release builds (native, the 9700X's), each under the
# lock; the head's test with the GNU objdump oracle (catalogue, generated stream, CI's raw corpus) and main's for
# comparison; then benchmark-x86-disassembler, main (its production path, --only batched) against the head, on the
# synthetic compiler and vector streams and the gate's compiler.text, three alternating processes each, pinned to CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the disassembler's PR" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p compilers logs
if [ ! -d src ]; then git clone -q https://github.com/buster14a/buster src || exit 1; fi
git -C src fetch -q origin main || exit 1
git -C src fetch -q "$D/c1.bundle" "+refs/heads/c1-disassembler:refs/heads/c1" || exit 1
main=$(git -C src rev-parse "${MAIN:-origin/main}")
head=$(git -C src rev-parse c1)
printf 'main %s\nhead %s\n' "$main" "$head" > logs/commits.txt
for side in main head; do
    git -C src checkout -q --detach "$(eval echo \$$side)"
    (cd src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build-$side.log" 2>&1) || { echo "build $side failed" >> logs/status.txt; exit 1; }
    cp src/build/compiler "compilers/$side"
done
sha256sum compilers/* > logs/compilers.sha256
clang -O3 -march=znver5 -c src/examples/disassembler/corpus.c -o corpus.o && objcopy -O binary -j .text corpus.o corpus.text
sha256sum corpus.text >> logs/compilers.sha256
for side in head main; do
    $L timeout -k 5 1200 ./compilers/$side test-x86-disassembler --objdump --file corpus.text > logs/test-objdump-$side.log 2>&1
    echo "test-objdump $side: $?" >> logs/status.txt
done
for stream in compiler vector text; do
    case $stream in compiler) args=();; vector) args=(--vector);; text) args=(--file ../2924-c-dis-claude/compiler.text);; esac
    for round in 1 2 3; do
        for side in main head; do
            only=(); [ $side = main ] && only=(--only batched)
            $L timeout -k 5 900 taskset -c 2 ./compilers/$side benchmark-x86-disassembler "${args[@]}" "${only[@]}" > logs/bench-$stream-$side-$round.log 2>&1
            echo "bench $stream $side $round: $?" >> logs/status.txt
        done
    done
done
date -u +%FT%TZ > logs/.done

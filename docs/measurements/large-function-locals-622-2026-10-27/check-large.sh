#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
(cd head; sha256sum --quiet -c ../head-source.sha256)
printf 'fixed source: '
cat head-revision.txt
date -u '+qualification UTC: %Y-%m-%dT%H:%M:%SZ'
uname -sm
lscpu | sed -n '/^Model name:/p'
clang --version | head -n 1
sha256sum base/build/compiler head/build/compiler large-20000.c large-32768.c large-40000.c
for blocks in 20000 32768 40000; do
    for mode in vector scalar; do
        options=()
        if [[ $mode == scalar ]]; then
            options+=(--scalar)
        fi
        if base/build/compiler "${options[@]}" --lanes 1 -fwrapv -c "large-$blocks.c" -o "base-$blocks-$mode.o" 2> "base-$blocks-$mode.err"; then
            [[ $blocks == 20000 ]]
            printf 'baseline: %s blocks, %s: accepted\n' "$blocks" "$mode"
        else
            [[ $blocks != 20000 ]]
            test ! -e "base-$blocks-$mode.o"
            grep -q 'code output capacity exhausted' "base-$blocks-$mode.err"
            printf 'baseline: %s blocks, %s: rejected at old local limit\n' "$blocks" "$mode"
        fi
        if [[ $blocks == 20000 ]]; then
            head/build/compiler "${options[@]}" --lanes 1 -fwrapv -c "large-$blocks.c" -o "head-$blocks-$mode-plain.o"
            cmp "base-$blocks-$mode.o" "head-$blocks-$mode-plain.o"
            printf 'fixed: %s blocks, %s: ordinary object identical to baseline\n' "$blocks" "$mode"
        fi
        head/build/compiler "${options[@]}" --lanes 1 --verify -g -fwrapv -c "large-$blocks.c" -o "head-$blocks-$mode.o"
        clang -fwrapv "head-$blocks-$mode.o" -o "head-$blocks-$mode"
        "./head-$blocks-$mode"
        printf 'fixed: %s blocks, %s: verified, linked and matched four loop-model inputs\n' "$blocks" "$mode"
    done
    cmp "head-$blocks-vector.o" "head-$blocks-scalar.o"
    printf 'fixed: %s blocks: scalar and vector objects identical with -g\n' "$blocks"
done
clang -O0 -fwrapv large-40000.c -o clang-40000
./clang-40000
printf 'clang: 40000 blocks: accepted and matched four loop-model inputs\n'
head/build/compiler --verify -g -fwrapv large-40000.c -o head-direct
./head-direct
head/build/compiler --scalar --verify -g -fwrapv large-40000.c -o head-direct-scalar
./head-direct-scalar
cmp head-direct head-direct-scalar
printf 'fixed: 40000 blocks: both direct executables matched the model and are identical with -g\n'

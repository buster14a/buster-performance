#!/bin/bash
# gates-steps.sh TREE ATREE STEP...: #447's correctness gates on the worktree TREE (release) and ATREE (its
# AddressSanitizer with UBSan build), each step in a lock hold of its own, in the order given: its output in
# logs/gate-TREE-STEP.log and its status in logs/gates-TREE.queue. Steps: fixtures (test-checker-deferred), c-testsuite
# (the 220 programs with --deferred 8 and the ids in another order), sqlite (the frozen sqlite3.c with --deferred 8
# and --symbols), musl-1 to musl-4 (all 1,524 C files of the frozen musl's src with its build's options, in four
# parts; a directory without C files is left out, which test-checker-corpus would refuse), asan-build, and asan-fixtures,
# asan-c-testsuite and asan-sqlite on ATREE's build.
set -u
D=~/buster-fast-bench/447-claude
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
M=$C/libc/musl
tree=$1
atree=$2
shift 2
export EXCLUSIVE_OWNER=claude-447 EXCLUSIVE_TITLE="#447 remaining work: correctness gates of $tree" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/447
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
gnu17=(--no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
musl=(--no-default-config --target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -pipe -I "$M/arch/x86_64" -I "$M/arch/generic" -I "$C/musl-generated/obj/src/internal" -I "$M/src/include" -I "$M/src/internal" -I "$C/musl-generated/obj/include" -I "$M/include")
part1=("$M/src/math")
part2=("$M/src/thread" "$M/src/stdio" "$M/src/unistd")
part3=("$M/src/network" "$M/src/string" "$M/src/complex" "$M/src/linux" "$M/src/signal" "$M/src/time" "$M/src/misc" "$M/src/ctype" "$M/src/process")
part4=()
for d in "$M"/src/*/; do
    [ -n "$(find "$d" -name '*.c' -print -quit)" ] || continue
    case " ${part1[*]} ${part2[*]} ${part3[*]} " in
        *" ${d%/} "*) ;;
        *) part4+=("${d%/}") ;;
    esac
done
step()
{
    local name=$1
    shift
    local begin
    begin=$(date -Is)
    ~/buster-fast-bench/exclusive.sh "$@" > "$D/logs/gate-$tree-$name.log" 2>&1
    echo "$begin $(date -Is) status=$? step=$name" >> "$D/logs/gates-$tree.queue"
}
R=$D/$tree/build/compiler
A=$D/$atree/build/compiler
for name in "$@"; do
    case "$name" in
        fixtures) (cd "$D/$tree" && step fixtures "$R" test-checker-deferred) ;;
        c-testsuite) (cd "$D/$tree" && step c-testsuite "$R" test-checker-corpus --clang clang --deferred 8 --id-order 153 "$D/c-testsuite/tests/single-exec") ;;
        sqlite) (cd "$D/$tree" && step sqlite "$R" test-checker-corpus --clang clang --deferred 8 --symbols "${gnu17[@]}" "$C/sqlite/sqlite3.c") ;;
        musl-1) (cd "$D/$tree" && step musl-1 "$R" test-checker-corpus --clang clang --deferred 8 "${musl[@]}" "${part1[@]}") ;;
        musl-2) (cd "$D/$tree" && step musl-2 "$R" test-checker-corpus --clang clang --deferred 8 "${musl[@]}" "${part2[@]}") ;;
        musl-3) (cd "$D/$tree" && step musl-3 "$R" test-checker-corpus --clang clang --deferred 8 "${musl[@]}" "${part3[@]}") ;;
        musl-4) (cd "$D/$tree" && step musl-4 "$R" test-checker-corpus --clang clang --deferred 8 "${musl[@]}" "${part4[@]}") ;;
        asan-build) (cd "$D/$atree" && step asan-build env BUSTER_SANITIZER=address ./build.sh) ;;
        asan-fixtures) (cd "$D/$atree" && step asan-fixtures "$A" test-checker-deferred) ;;
        asan-c-testsuite) (cd "$D/$atree" && step asan-c-testsuite "$A" test-checker-corpus --clang clang --deferred 8 "$D/c-testsuite/tests/single-exec") ;;
        asan-sqlite) (cd "$D/$atree" && step asan-sqlite "$A" test-checker-corpus --clang clang --deferred 8 "${gnu17[@]}" "$C/sqlite/sqlite3.c") ;;
        *) echo "$(date -Is) unknown step $name" >> "$D/logs/gates-$tree.queue" ;;
    esac
done

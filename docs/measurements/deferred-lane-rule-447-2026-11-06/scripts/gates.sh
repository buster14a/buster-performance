#!/bin/bash
# gates.sh: #447's correctness gates at the measured revision, each step in a lock hold of its own, its output in
# logs/gate-STEP.log and its status in logs/gates.queue. The release tree's fixtures and corpora with the deferred
# reader on 8 lanes (c-testsuite with the ids in another order and SQLite with --symbols, as the 9700X job runs them;
# the frozen musl's src, all 1,524 files with its build's options, in four parts), then an AddressSanitizer (with
# UBSan) build of the same revision in tree-asan and its fixtures, c-testsuite and SQLite with --deferred 8.
set -u
D=~/buster-fast-bench/447-claude
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
M=$C/libc/musl
export EXCLUSIVE_OWNER=claude-447 EXCLUSIVE_TITLE="#447 deferred lane-count acceptance: correctness gates" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/447
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
gnu17=(--no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
musl=(--no-default-config --target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -pipe -I "$M/arch/x86_64" -I "$M/arch/generic" -I "$C/musl-generated/obj/src/internal" -I "$M/src/include" -I "$M/src/internal" -I "$C/musl-generated/obj/include" -I "$M/include")
part1=("$M/src/math")
part2=("$M/src/thread" "$M/src/stdio" "$M/src/unistd")
part3=("$M/src/network" "$M/src/string" "$M/src/complex" "$M/src/linux" "$M/src/signal" "$M/src/time" "$M/src/misc" "$M/src/ctype" "$M/src/process")
part4=()
for d in "$M"/src/*/; do
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
    ~/buster-fast-bench/exclusive.sh "$@" > "$D/logs/gate-$name.log" 2>&1
    echo "$begin $(date -Is) status=$? step=$name" >> "$D/logs/gates.queue"
}
R=$D/tree/build/compiler
A=$D/tree-asan/build/compiler
cd "$D/tree" || exit 1
step fixtures "$R" test-checker-deferred
step c-testsuite "$R" test-checker-corpus --clang clang --deferred 8 --id-order 153 "$D/c-testsuite/tests/single-exec"
step sqlite "$R" test-checker-corpus --clang clang --deferred 8 --symbols "${gnu17[@]}" "$C/sqlite/sqlite3.c"
step musl-1 "$R" test-checker-corpus --clang clang --deferred 8 "${musl[@]}" "${part1[@]}"
step musl-2 "$R" test-checker-corpus --clang clang --deferred 8 "${musl[@]}" "${part2[@]}"
step musl-3 "$R" test-checker-corpus --clang clang --deferred 8 "${musl[@]}" "${part3[@]}"
step musl-4 "$R" test-checker-corpus --clang clang --deferred 8 "${musl[@]}" "${part4[@]}"
cd "$D/tree-asan" || exit 1
step asan-build env BUSTER_SANITIZER=address ./build.sh
step asan-fixtures "$A" test-checker-deferred
step asan-c-testsuite "$A" test-checker-corpus --clang clang --deferred 8 "$D/c-testsuite/tests/single-exec"
step asan-sqlite "$A" test-checker-corpus --clang clang --deferred 8 "${gnu17[@]}" "$C/sqlite/sqlite3.c"
echo "done $(date -Is)" >> "$D/logs/gates.queue"

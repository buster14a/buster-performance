#!/bin/bash
# #2924 phase C, branch sizing's PR, second head: the measured head plus cmake/BusterStartOrder.txt naming the checker
# unit's size_branches (Clang now inlines branch_sizing_run into it). Its Release build under the lock, where the
# function lands, and the timing of run.sh again: main, head2, main-again.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: branch sizing PR, start order" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs2
git -C src fetch -q "$D/head2.bundle" "+HEAD:refs/heads/head2" || exit 1
head2=$(git -C src rev-parse head2)
printf 'main 0e8342dd7f1be0c07b97e9c6ec8dc2413887ef06\nhead2 %s\n' "$head2" > logs2/commits.txt
git -C src checkout -q --detach "$head2"
(cd src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs2/build-head2.log" 2>&1) || { echo "build head2 failed" >> logs2/status.txt; exit 1; }
cp src/build/compiler compilers/head2
sha256sum compilers/* > logs2/compilers.sha256
readelf -SW compilers/head2 > logs2/head2-sections.txt
readelf -sW compilers/head2 | awk '$4 == "FUNC"' | grep -E " (size_branches|branch_sizing_run|branch_sizing_validate_branches)$" > logs2/head2-branch-sizing.txt
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$HOME/buster-fast-bench/2924-c-dis-claude/inputs/lua-5.4.8/src
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
out=/dev/shm/claude-2924-bs2
rm -rf "$out"; mkdir -p "$out"
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
B=(--build main "$D/compilers/main" --build head2 "$D/compilers/head2" --build main-again "$D/compilers/main")
(cd "$out" && "$D/compilers/main" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/main" \
    -- time-runs --runs 3 --copies 3 --directory "$out" "${B[@]}" \
    --list -c --lanes 1 "${S[@]}" -o "$out/sqlite3.o" \
    --list -fsyntax-only --lanes 1 "${S[@]}" \
    --list -c --lanes 1 "$lua"/*.c \
    --list -c --lanes 1 "${M[@]}" "${files[@]}" \
    > "$D/logs2/time.log" 2>&1)
echo "time: $?" >> logs2/status.txt
rm -rf "$out"
date -u +%FT%TZ > logs2/.done

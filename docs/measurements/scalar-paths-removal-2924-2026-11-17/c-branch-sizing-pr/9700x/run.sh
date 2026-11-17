#!/bin/bash
# #2924 phase C, branch sizing's PR on the 9700X: the head's Release build (main's is 2924-c1-pr-claude's, 0e8342dd7),
# then each run under the lock: test-branch-sizing --cross-check (GNU as 2.47) on both; benchmark-branch-sizing's
# size_branches and size_encode, main against the head, three alternating processes each; -c and -fsyntax-only of
# sqlite3.c, Lua and musl with ab around time-runs (main, head, main-again); and the two executables' disassembly, function
# by function (split.py and compare.py from b2-main-vs-head).
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: branch sizing's PR" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p compilers logs
if [ ! -d src ]; then git clone -q $HOME/buster-fast-bench/2924-c1-pr-claude/src src || exit 1; fi
git -C src fetch -q "$D/c2.bundle" "+refs/heads/c2-branch-sizing:refs/heads/c2" || exit 1
head=$(git -C src rev-parse c2)
cp $HOME/buster-fast-bench/2924-c1-pr-claude/compilers/main compilers/main
printf 'main 0e8342dd7f1be0c07b97e9c6ec8dc2413887ef06\nhead %s\n' "$head" > logs/commits.txt
git -C src checkout -q --detach "$head"
(cd src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build-head.log" 2>&1) || { echo "build head failed" >> logs/status.txt; exit 1; }
cp src/build/compiler compilers/head
sha256sum compilers/* > logs/compilers.sha256
for side in head main; do
    (cd src && $L timeout -k 5 900 ../compilers/$side test-branch-sizing --cross-check > "$D/logs/test-cross-$side.log" 2>&1)
    echo "test-cross $side: $?" >> logs/status.txt
done
for measure in size_branches size_encode; do
    for round in 1 2 3; do
        for side in main head; do
            $L timeout -k 5 900 taskset -c 2 ./compilers/$side benchmark-branch-sizing --measure $measure > logs/bench-$measure-$side-$round.log 2>&1
            echo "bench $measure $side $round: $?" >> logs/status.txt
        done
    done
done
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
{
    sha256sum compilers/* "$sqlite/sqlite3.c" "$lua"/*.c
    echo "musl units ${#files[@]}"
    cat "${files[@]}" | sha256sum
} > logs/inputs.txt
out=/dev/shm/claude-2924-bs
rm -rf "$out"; mkdir -p "$out/lua" "$out/musl"
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
B=(--build main "$D/compilers/main" --build head "$D/compilers/head" --build main-again "$D/compilers/main")
(cd "$out" && "$D/compilers/main" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/main" \
    -- time-runs --runs 3 --copies 3 --directory "$out" "${B[@]}" \
    --list -c --lanes 1 "${S[@]}" -o "$out/sqlite3.o" \
    --list -fsyntax-only --lanes 1 "${S[@]}" \
    --list -c --lanes 1 "$lua"/*.c \
    --list -c --lanes 1 "${M[@]}" "${files[@]}" \
    > "$D/logs/time.log" 2>&1)
echo "time: $?" >> logs/status.txt
rm -rf "$out"
for side in main head; do
    objdump -d --no-show-raw-insn compilers/$side > /dev/shm/claude-2924-bs-$side.s && python3 disassembly/split.py /dev/shm/claude-2924-bs-$side.s logs/$side.json
    rm -f /dev/shm/claude-2924-bs-$side.s
done
python3 disassembly/compare.py logs/main.json logs/head.json > logs/compare.txt
readelf -sW compilers/head | awk '$4 == "FUNC"' > logs/head-functions.txt
readelf -SW compilers/head > logs/head-sections.txt
date -u +%FT%TZ > logs/.done

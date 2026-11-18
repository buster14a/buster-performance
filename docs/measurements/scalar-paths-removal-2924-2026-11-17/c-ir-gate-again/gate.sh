#!/bin/bash
# #2924 C9c's gate: SSA promotion's vector path forced past its 16,384-cell bound (experiment knob) against the scalar
# twin, each function of the frozen sqlite3.c and Lua 5.4.8 timed by both paths (benchmark-ir-source --functions), two
# rounds each, Release, under the lock on CPU 2, every process from a fresh copy.
D=~/buster-fast-bench/2924-c-df-claude/c9cgate
cd "$D" || exit 1
S=$D/logs/status.txt
mkdir -p logs copies
rm -f "$S"
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: SSA promotion's gate" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
if [ ! -d src ]; then git clone -q --shared ../c7gate/src src || exit 1; fi
git -C src fetch -q https://github.com/buster14a/buster main claude/wonderful-wozniak-vbfba7 || { echo "fetch failed" >> "$S"; exit 1; }
git -C src fetch -q "$D/c9c.bundle" "+refs/heads/c9b:refs/heads/c9b" || { echo "bundle failed" >> "$S"; exit 1; }
git -C src checkout -q --detach refs/heads/c9b && git -C src reset -q --hard && git -C src clean -qfd -e build
(cd src && git apply "$D/c9c-knob.patch") || { echo "knob failed" >> "$S"; exit 1; }
git -C src log --oneline -1 > logs/commit.txt
(cd src && $L timeout -k 5 1800 ./build.sh --config Release > "$D/logs/build.log" 2>&1) || { echo "build failed" >> "$S"; exit 1; }
cp src/build/compiler compiler
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
SOURCE=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
lua=$D/../c3pr/inputs/lua-5.4.8/src
for round in 1 2; do
    for knob in 1 0; do
        cp compiler copies/run
        BUSTER_SSA_FORCE_VECTOR=$knob $L timeout -k 5 3000 taskset -c 2 ./copies/run benchmark-ir-source --functions "${SOURCE[@]}" > logs/sqlite-$knob-$round.log 2>&1
        echo "sqlite knob $knob round $round: $?" >> "$S"
        BUSTER_SSA_FORCE_VECTOR=$knob $L timeout -k 5 3000 taskset -c 2 ./copies/run benchmark-ir-source --functions "$lua"/*.c > logs/lua-$knob-$round.log 2>&1
        echo "lua knob $knob round $round: $?" >> "$S"
        rm -f copies/run
    done
done
echo done >> "$S"

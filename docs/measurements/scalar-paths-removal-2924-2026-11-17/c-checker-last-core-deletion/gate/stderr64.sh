#!/bin/bash
# The gate's one stderr difference: -c of the 64 groups' fixture by no bit and every bit, three times each, err kept.
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the checker core's last twins' gate, C12c-3 core-3" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
exe=/dev/shm/claude-2924-c12k3c-exe
rm -rf "$exe"; mkdir -p "$exe" logs/stderr64
cp src/build/compiler "$exe/file"
for m in 0 1 2 4 8 16 32 63; do mkdir -p "$exe/m$m"; ln "$exe/file" "$exe/m$m/compiler-areas$m"; done
out=/dev/shm/claude-2924-c12k3c; rm -rf "$out"; mkdir -p "$out"
for i in 1 2 3; do for m in 0 1 2 4 8 16 32 63; do
    (cd "$out" && $L timeout -k 5 300 taskset -c 2 "$exe/m$m/compiler-areas$m" -c --lanes 1 "$D/fixtures/overloadable-64.c" -o fixture.o > /dev/null 2> "$D/logs/stderr64/m$m-$i.err"; echo "m$m run $i: $? $(grep -vcE '^exclusive.sh: |^  (title|link): ' "$D/logs/stderr64/m$m-$i.err") lines" >> "$D/logs/stderr64/status.txt")
done; done
rm -rf "$out" "$exe"
echo done >> logs/stderr64/status.txt

#!/bin/bash
# #2924 C4, dominators' re-measurement on main (aa09d1a04's Release build; dominators unchanged through 295417ae7), each
# run under the lock on CPU 2: export sqlite3.c's CFGs (test-ir-source --dominators-cfg); benchmark-dominators --cfg on
# them with --outputs tree and all, --only scalar, vector and auto, three processes each in turn; and the synthetic
# shapes (both paths, analysis phase), three processes.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: dominators' re-measurement" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
C=$D/../c3pr/compilers/main
S=$D/../c3pr/src-main
mkdir -p logs
sha256sum "$C" > logs/compiler.sha256
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
rm -f "$D/sqlite.cfg"
(cd "$S" && $L timeout -k 5 1500 "$C" test-ir-source --dominators-cfg "$D/sqlite.cfg" --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c" > "$D/logs/export.log" 2>&1)
echo "export: $?" >> logs/status.txt
for round in 1 2 3; do
    for outputs in tree all; do
        for only in scalar vector auto; do
            $L timeout -k 5 900 taskset -c 2 "$C" benchmark-dominators --cfg "$D/sqlite.cfg" --outputs $outputs --only $only > logs/cfg-$outputs-$only-$round.log 2>&1
            echo "cfg $outputs $only $round: $?" >> logs/status.txt
        done
    done
    $L timeout -k 5 900 taskset -c 2 "$C" benchmark-dominators > logs/synthetic-$round.log 2>&1
    echo "synthetic $round: $?" >> logs/status.txt
done
rm -f "$D/sqlite.cfg"
date -u +%FT%TZ > logs/.done

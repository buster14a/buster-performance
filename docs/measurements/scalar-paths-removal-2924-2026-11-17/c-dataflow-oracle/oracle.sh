#!/bin/bash
# #2924 C3: the sweep-count oracle beside the scalar twin, on main 8bd7f27ec plus the oracle patch, over sqlite3.c's
# IR forms (test-ir-source runs IR dataflow's test on every form) and test-dataflow over seeds.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: dataflow's sweep oracle on sqlite" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p oracle
if [ ! -d oracle-src ]; then git clone -q src oracle-src || exit 1; fi
git -C oracle-src checkout -q --detach 8bd7f27ec && git -C oracle-src reset -q --hard && git -C oracle-src clean -qfd -e build && git -C oracle-src apply "$D/c3-oracle.patch" || { echo "patch failed" > oracle/status.txt; exit 1; }
(cd oracle-src && $L timeout -k 5 1500 ./build.sh > "$D/oracle/build.log" 2>&1) || { echo "build failed" >> oracle/status.txt; exit 1; }
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
(cd oracle-src && $L timeout -k 5 1500 ./build/compiler test-ir-source --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c" > "$D/oracle/ir-sqlite.log" 2>&1)
echo "ir sqlite: $?" >> oracle/status.txt
for seed in 11 12 13 14 15 16 17 18; do
    (cd oracle-src && $L timeout -k 5 600 ./build/compiler test-dataflow --seed $seed --count 64 >> "$D/oracle/test-dataflow.log" 2>&1)
    echo "test-dataflow $seed: $?" >> oracle/status.txt
done
date -u +%FT%TZ > oracle/.done

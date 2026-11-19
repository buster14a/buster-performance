#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C
record=$(cd "$(dirname "$0")" && pwd)
mkdir -p record
git rev-parse HEAD | tee record/base.txt
lscpu | rg 'Architecture|Model name|Hypervisor' | tee record/cpu.txt
# Use the hosted image's compiler and runtime together. Set the target from the qualified CPU.
export BUSTER_TOOLCHAIN=path BUSTER_HOST_ARCH=native BUSTER_DEBUG_INFO=0
clang --version | tee record/clang.txt
cmake --version
ninja --version
git apply "$record/fixture.patch"
git apply "$record/base-count.patch"
./build.sh --config Develop >record/build.log 2>&1 || { tail -90 record/build.log; exit 1; }
mkdir -p record/ir
BUSTER_WIDE_PHI_DUMP="$PWD/record/ir" ./build/compiler test-ir-optimize >record/test.log 2>&1 || { tail -100 record/test.log; exit 1; }
rg 'wide-phi|test-ir-optimize|failed|checks|passed' record/test.log | tail -40
sha256sum record/ir/* | tee record/ir.sha256
bash tools/ci/fetch-corpus.sh "$RUNNER_TEMP/corpus"
corpus="$RUNNER_TEMP/corpus"
options=(--tier1 --lanes=1 -c -w --predefines "$corpus/provenance/gnu17-pinned-predefines.txt"
         --clang-features --no-default-config --target=x86_64-linux-gnu -march=x86-64 -std=gnu17 -nostdinc
         -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include"
         -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE)
sha256sum "$corpus/sqlite/sqlite3.c" | tee record/source.sha256
BUSTER_WIDE_PHI_CENSUS=1 ./build/compiler "${options[@]}" "$corpus/sqlite/sqlite3.c" -o record/sqlite.o >record/compile.log 2>&1 || { tail -50 record/compile.log; exit 1; }
readelf -SW record/sqlite.o >record/sections.txt
objcopy --dump-section .text=record/sqlite.text record/sqlite.o
wc -c record/sqlite.text
sha256sum record/sqlite.text record/sqlite.o | tee record/object.sha256
awk '$1=="JT_JOIN"{ j[$2]++ } $1=="JT_CAND"{ c[$2]++; if($3){ e[$2]++; calls[$2]+=$3 } if($4){ t[$2]++ } } $1=="JT_FUNCTION"{ f++; scan+=$2; build+=$3; hit+=$4; lookup+=$5 }
END { print "function calls",f,"lookups",lookup,"pairs scanned",scan,"pairs indexed",build,"index hits",hit; for(n in j) print "fanin",n,"phi blocks",j[n],"candidates",c[n]+0,"evaluated",e[n]+0,"conditional predecessors evaluated",calls[n]+0,"threaded",t[n]+0 }' record/compile.log | sort -V | tee record/census.txt

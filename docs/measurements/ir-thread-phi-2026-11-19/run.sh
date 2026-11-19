#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C
record=$(cd "$(dirname "$0")" && pwd)
mkdir -p record/base/ir record/head/ir
git rev-parse HEAD | tee record/base.txt
lscpu | grep -E 'Architecture|Model name|Hypervisor' | tee record/cpu.txt
paths=$(bash tools/ci/session-toolchain.sh stage)
export PATH="$paths:$PATH" BUSTER_HOST_ARCH=native BUSTER_DEBUG_INFO=0
clang --version | tee record/clang.txt
bash tools/ci/fetch-corpus.sh "$RUNNER_TEMP/corpus"
corpus="$RUNNER_TEMP/corpus"
options=(--tier1 --tier1-report --lanes=1 -c -w --predefines "$corpus/provenance/gnu17-pinned-predefines.txt"
         -march=x86-64 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include"
         -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include"
         -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE)
sha256sum "$corpus/sqlite/sqlite3.c" | tee record/source.sha256
git apply "$record/fixture.patch"
for revision in base head; do
    if [[ "$revision" == head ]]; then git apply "$record/optimization.patch"; fi
    dest="record/$revision"
    git apply "$record/$revision-count.patch"
    ./build.sh --config Develop >"$dest/build.log" 2>&1 || { tail -80 "$dest/build.log"; exit 1; }
    BUSTER_WIDE_PHI_DUMP="$PWD/$dest/ir" ./build/compiler test-ir-optimize >"$dest/test.log" 2>&1 || { tail -90 "$dest/test.log"; exit 1; }
    grep -E 'wide-phi width|checks, .* failures' "$dest/test.log" | tee "$dest/fixtures.txt"
    BUSTER_WIDE_PHI_CENSUS=1 BUSTER_WIDE_PHI_IR="$PWD/$dest/sqlite.ir" ./build/compiler "${options[@]}" "$corpus/sqlite/sqlite3.c" -o "$dest/sqlite.o" >"$dest/compile.log" 2>&1 || { tail -60 "$dest/compile.log"; exit 1; }
    grep -Ev '^JT_(CAND|FUNCTION|JOIN) ' "$dest/compile.log" | tail -10 || true
    readelf -SW "$dest/sqlite.o" >"$dest/sections.txt"
    objcopy --dump-section ".text=$dest/sqlite.text" "$dest/sqlite.o"
    test -s "$dest/sqlite.text" && test -s "$dest/sqlite.ir"
    wc -c "$dest/sqlite.text" "$dest/sqlite.ir"
    sha256sum "$dest/sqlite.text" "$dest/sqlite.o" "$dest/sqlite.ir"
    awk '$1=="JT_JOIN"{ j[$2]++ } $1=="JT_CAND"{ c[$2]++; if($3){ e[$2]++; calls[$2]+=$3 } if($4){ t[$2]++ } } $1=="JT_FUNCTION"{ f++; scan+=$2; build+=$3; hit+=$4; lookup+=$5 }
    END { print "function calls",f,"lookups",lookup,"pairs scanned",scan,"pairs indexed",build,"index hits",hit; for(n in j) print "fanin",n,"phi blocks",j[n],"candidates",c[n]+0,"evaluated",e[n]+0,"conditional predecessors evaluated",calls[n]+0,"threaded",t[n]+0 }' "$dest/compile.log" | sort -V | tee "$dest/census.txt"
    git apply -R "$record/$revision-count.patch"
done
diff -rq record/base/ir record/head/ir
for f in sqlite.ir sqlite.text sqlite.o; do cmp "record/base/$f" "record/head/$f"; done
cmp record/base/census.txt record/head/census.txt || true
sha256sum record/head/ir/* | tee record/ir.sha256
echo 'PASS: all fixture IR, all threaded SQLite IR, SQLite .text, and the entire object are byte-identical.'
# The uninstrumented PR sources run under the native MemorySanitizer configuration.
export BUSTER_SANITIZER=memory BUSTER_SANITIZER_OPTIMIZATION=3
./build.sh --config Release >record/msan-build.log 2>&1 || { tail -80 record/msan-build.log; exit 1; }
llvm-nm build/compiler >record/msan-symbols.tmp
grep -m1 ' T __msan_init$' record/msan-symbols.tmp
rm record/msan-symbols.tmp
MSAN_OPTIONS=halt_on_error=1:exit_code=86 ./build/compiler test-ir-optimize >record/msan-test.log 2>&1 || { tail -100 record/msan-test.log; exit 1; }
tail -5 record/msan-test.log

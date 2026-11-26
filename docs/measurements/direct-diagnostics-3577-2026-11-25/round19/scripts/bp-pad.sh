#!/bin/bash
# bp-pad.sh: build p5 (bundle head) with BUSTER_EX_PAD = 1024, 2048, 3072 (BUSTER_BUILD_DEFINES; bins/compiler-p5pN),
# each under its own hold, then one hold: perf stat of main16, p4, p5 and the pads in rotation (3 rounds of 7).
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/work" || exit 1
for pad in 1024 2048 3072; do
  echo "== build p5p$pad $(date -u +%H:%M:%S)"
  EXCLUSIVE_TITLE="#3577 direct path: build p5 pad $pad" BUSTER_HOST_ARCH=znver5 BUSTER_BUILD_DEFINES=-DBUSTER_EX_PAD=$pad ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-p5p$pad.log" 2>&1
  st=$?; echo "status $st $(date -u +%H:%M:%S) $(tail -1 "$D/build-p5p$pad.log")"; [ $st = 0 ] || exit 1
  cp build/compiler "$D/bins/compiler-p5p$pad"; chmod +x "$D/bins/compiler-p5p$pad"
done
cd "$D" || exit 1
EXCLUSIVE_TITLE="#3577 direct path: measure pads" ~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-p.o)
  for r in 1 2 3; do
    for t in main16 p4 p5 p5p1024 p5p2048 p5p3072; do
      echo "== $r $t $(taskset -c 2 perf stat -r 7 -e cycles:u,instructions:u ./bins/compiler-$t "${flags[@]}" 2>&1 | grep -E "cycles|instructions" | awk "{print \$1}" | tr "\n" " ")"
    done
  done
' x "$sqlite"
echo DONE

#!/bin/bash
# bp-spad.sh: build p7 (bundle head) with BUSTER_SCRATCH_PAD = 0, 1920 (main's 4 KiB phase for the preprocessor's
# scratch buffers), 896 and 2944, each under its own hold; then one hold: perf stat of main16, p4 and the four in
# rotation (3 rounds of 7), and --time-stages of main16, p7s0 and p7s1920.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/repo" || exit 1
git fetch -q "$D/p7.bundle" || exit 1
H=$(git bundle list-heads "$D/p7.bundle" | head -1 | cut -c1-9)
git -C "$D/work" checkout -q -- . 2>/dev/null; git -C "$D/work" checkout -q --detach "$H" || exit 1
cd "$D/work" || exit 1
rm -f "$D"/bins/compiler-p5p*
for pad in 0 1920; do
  echo "== build p7s$pad $(git log --oneline -1 | cut -c1-40) $(date -u +%H:%M:%S)"
  EXCLUSIVE_TITLE="#3577 direct path: build p7 scratch pad $pad" BUSTER_HOST_ARCH=znver5 BUSTER_BUILD_DEFINES=-DBUSTER_SCRATCH_PAD=$pad ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-p7s$pad.log" 2>&1
  st=$?; echo "status $st $(date -u +%H:%M:%S) $(tail -1 "$D/build-p7s$pad.log")"; [ $st = 0 ] || exit 1
  cp build/compiler "$D/bins/compiler-p7s$pad"; chmod +x "$D/bins/compiler-p7s$pad"
done
cd "$D" || exit 1
EXCLUSIVE_TITLE="#3577 direct path: measure scratch pads" ~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-p.o)
  for r in 1 2 3; do
    for t in main16 p4 p7s0 p7s1920; do
      echo "== $r $t $(taskset -c 2 perf stat -r 7 -e cycles:u,instructions:u ./bins/compiler-$t "${flags[@]}" 2>&1 | grep -E "cycles|instructions" | awk "{print \$1}" | tr "\n" " ")"
    done
  done
  for i in $(seq 11); do
    for t in main16 p7s0 p7s1920; do
      taskset -c 2 ./bins/compiler-$t --time-stages "${flags[@]}" 2>&1 | awk -F"\t" -v T=$t "\$1 == \"time-stage\" && (\$2 == \"preprocess\" || \$2 == \"tier0\") {print T, \$2, \$3}"
    done
  done > stages-spad.txt
  for t in main16 p7s0 p7s1920; do for s in preprocess tier0; do
    awk -v T=$t -v S=$s "\$1 == T && \$2 == S {print \$3}" stages-spad.txt | sort -g | awk -v T=$t -v S=$s "{a[NR]=\$1} END {printf \"%s %-10s median %.3f\n\", T, S, a[int((NR+1)/2)]}"
  done; done
' x "$sqlite"
echo DONE

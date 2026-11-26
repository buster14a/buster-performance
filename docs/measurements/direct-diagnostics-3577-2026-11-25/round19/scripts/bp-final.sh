#!/bin/bash
# bp-final.sh: build the squashed head (p8.bundle) as the 9700X job builds, then one hold: measure-compile's
# instructions against tools/ci/compile-instructions.txt (3 runs), measure-compile against main 1e1ca2dd6 (21 runs),
# perf stat rotation of main16 and p8 (3 rounds of 7), and the stage split (11 interleaved runs).
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/repo" || exit 1
git fetch -q "$D/p8.bundle" || exit 1
H=$(git bundle list-heads "$D/p8.bundle" | head -1 | cut -c1-9)
git -C "$D/work" checkout -q -- . 2>/dev/null; git -C "$D/work" checkout -q --detach "$H" || exit 1
cd "$D/work" || exit 1
echo "== build p8 $(git log --oneline -1 | cut -c1-80) $(date -u +%H:%M:%S)"
EXCLUSIVE_TITLE="#3577 direct path: build the squashed head" BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-p8.log" 2>&1
st=$?; echo "status $st $(date -u +%H:%M:%S) $(tail -1 "$D/build-p8.log")"; [ $st = 0 ] || exit 1
cp build/compiler "$D/bins/compiler-p8"; chmod +x "$D/bins/compiler-p8"
./build/compiler --version > /dev/null || { echo "NO COMPILER"; exit 1; }
EXCLUSIVE_TITLE="#3577 direct path: measure the squashed head" ~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1; D=$2
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
  taskset -c 2 ./build/compiler measure-compile --runs 3 --instructions-baseline tools/ci/compile-instructions.txt -- "${flags[@]}" 2>&1 | grep -iE "^instructions"
  taskset -c 2 ./build/compiler measure-compile --runs 21 --reference $D/bins/compiler-main16 -- "${flags[@]}" 2>&1 | grep -E "median of|times,"
  cd $D
  for r in 1 2 3; do
    for t in main16 p8; do
      echo "== $r $t $(taskset -c 2 perf stat -r 7 -e cycles:u,instructions:u ./bins/compiler-$t "${flags[@]}" -o /tmp/3577-claude-f.o 2>&1 | grep -E "cycles|instructions" | awk "{print \$1}" | tr "\n" " ")"
    done
  done
  for i in $(seq 11); do
    for t in main16 p8; do
      taskset -c 2 ./bins/compiler-$t --time-stages "${flags[@]}" -o /tmp/3577-claude-f.o 2>&1 | awk -F"\t" -v T=$t "\$1 == \"time-stage\" && (\$2 == \"preprocess\" || \$2 == \"tier0\" || \$2 == \"total\") {print T, \$2, \$3}"
    done
  done > stages-p8.txt
  for t in main16 p8; do for s in preprocess tier0 total; do
    awk -v T=$t -v S=$s "\$1 == T && \$2 == S {print \$3}" stages-p8.txt | sort -g | awk -v T=$t -v S=$s "{a[NR]=\$1} END {printf \"%s %-10s median %.3f\n\", T, S, a[int((NR+1)/2)]}"
  done; done
  taskset -c 2 ./bins/compiler-p8 "${flags[@]}" -o /tmp/3577-claude-p8.o && echo "object $(sha256sum /tmp/3577-claude-p8.o | cut -c1-16)"
  taskset -c 2 ./bins/compiler-main16 "${flags[@]}" -o /tmp/3577-claude-m.o && echo "main object $(sha256sum /tmp/3577-claude-m.o | cut -c1-16)"
' x "$sqlite" "$D"
rm -f "$D"/bins/compiler-p7s* "$D"/bins/compiler-p1 "$D"/bins/compiler-p4 "$D"/bins/compiler-p5
df -h ~ | tail -1
echo DONE

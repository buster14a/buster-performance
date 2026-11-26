#!/bin/bash
# bp-pn.sh BUNDLE NAME [COMPARE...]: build the bundle's head as NAME in the work tree under its own hold, then one hold:
# perf stat of main16 and each COMPARE and NAME in rotation (3 rounds of 7), the stage split of main16 and NAME, and
# unthrottled cycle (-c 100000) and op (IBS -c 262144) profiles of NAME, 300 compiles each.
B=$1; NAME=$2; shift 2; CMP="$*"
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/repo" || exit 1
git fetch -q "$D/$B" || exit 1
H=$(git bundle list-heads "$D/$B" | head -1 | cut -c1-9)
git -C "$D/work" checkout -q -- . 2>/dev/null; git -C "$D/work" checkout -q --detach "$H" || exit 1
echo "== build $NAME $(git -C "$D/work" log --oneline -1 | cut -c1-80) $(date -u +%H:%M:%S)"
(cd "$D/work" && EXCLUSIVE_TITLE="#3577 direct path: build $NAME" BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-$NAME.log" 2>&1)
st=$?; echo "status $st $(date -u +%H:%M:%S) $(tail -1 "$D/build-$NAME.log")"; [ $st = 0 ] || exit 1
cp "$D/work/build/compiler" "$D/bins/compiler-$NAME" && chmod +x "$D/bins/compiler-$NAME"
cd "$D" || exit 1
./bins/compiler-$NAME --version > /dev/null || { echo "NO COMPILER"; exit 1; }
for t in $CMP; do cmp -s bins/compiler-$t bins/compiler-$NAME && echo "WARNING $NAME same as $t"; done
EXCLUSIVE_TITLE="#3577 direct path: measure $NAME" ~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1; NAME=$2; CMP=$3
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-p.o)
  for r in 1 2 3; do
    for t in main16 $CMP $NAME; do
      echo "== $r $t $(taskset -c 2 perf stat -r 7 -e cycles:u,instructions:u ./bins/compiler-$t "${flags[@]}" 2>&1 | grep -E "cycles|instructions" | awk "{print \$1}" | tr "\n" " ")"
    done
  done
  for i in $(seq 11); do
    for t in main16 $NAME; do
      taskset -c 2 ./bins/compiler-$t --time-stages "${flags[@]}" 2>&1 | awk -F"\t" -v T=$t "\$1 == \"time-stage\" && (\$2 == \"preprocess\" || \$2 == \"tier0\" || \$2 == \"total\") {print T, \$2, \$3}"
    done
  done > stages-$NAME.txt
  for t in main16 $NAME; do for s in preprocess tier0 total; do
    awk -v T=$t -v S=$s "\$1 == T && \$2 == S {print \$3}" stages-$NAME.txt | sort -g | awk -v T=$t -v S=$s "{a[NR]=\$1} END {printf \"%s %-10s median %.3f\n\", T, S, a[int((NR+1)/2)]}"
  done; done
  taskset -c 2 perf record -q -e cycles:u -c 100000 -o pu-cyc-$NAME.data -- bash -c "for i in \$(seq 300); do ./bins/compiler-\$0 \"\$@\"; done" $NAME "${flags[@]}" > /dev/null 2>&1 || echo "record failed"
  taskset -c 2 perf record -q -e ibs_op/cnt_ctl=1,swfilt=1/u -c 262144 -o pu-op-$NAME.data -- bash -c "for i in \$(seq 300); do ./bins/compiler-\$0 \"\$@\"; done" $NAME "${flags[@]}" > /dev/null 2>&1 || echo "record failed op"
' x "$sqlite" "$NAME" "$CMP"
for k in cyc op; do
  perf report -q -i pu-$k-$NAME.data --no-children --comm compiler-$NAME --sort symbol --stdio -F overhead,sample,symbol 2>/dev/null | grep -v "^$" > pu-$k-$NAME.txt
  perf report -q -i pu-$k-$NAME.data --no-children --comm compiler-$NAME --sort srcline --stdio -F overhead,sample,srcline 2>/dev/null | grep -v "^$" > pu-$k-lines-$NAME.txt
done
rm -f pu-cyc-$NAME.data pu-op-$NAME.data
echo DONE

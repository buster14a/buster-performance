#!/bin/bash
# bp-p23.sh: build p2 (d784e8675) and p3 (HEAD of the bundle) in the work tree, each under its own hold; then one hold:
# perf stat of main16, m16, p1, p2, p3 in rotation, the stage split, and an unthrottled cycle profile of p3.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/repo" || exit 1
git fetch -q "$D/p3.bundle" || exit 1
P3=$(git bundle list-heads "$D/p3.bundle" | head -1 | cut -c1-9)
build() { # SHA NAME
  git -C "$D/work" checkout -q -- . 2>/dev/null; git -C "$D/work" checkout -q --detach "$1" || return 1
  echo "== build $2 $(git -C "$D/work" log --oneline -1 | cut -c1-70) $(date -u +%H:%M:%S)"
  (cd "$D/work" && EXCLUSIVE_TITLE="#3577 direct path: build $2" BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-$2.log" 2>&1)
  local st=$?
  echo "status $st $(date -u +%H:%M:%S) $(tail -1 "$D/build-$2.log")"
  [ $st = 0 ] || return 1
  cp "$D/work/build/compiler" "$D/bins/compiler-$2" && chmod +x "$D/bins/compiler-$2"
  "$D/bins/compiler-$2" --version > /dev/null || { echo "NO COMPILER $2"; return 1; }
}
build d784e8675 p2 || exit 1
build "$P3" p3 || exit 1
cd "$D" || exit 1
for t in p1 p2 p3; do cmp -s bins/compiler-m16 bins/compiler-$t && echo "WARNING $t same as m16"; done
cmp -s bins/compiler-p2 bins/compiler-p3 && echo "WARNING p2 same as p3"
EXCLUSIVE_TITLE="#3577 direct path: measure p1-p3" ~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-p.o)
  for r in 1 2 3; do
    for t in main16 m16 p1 p2 p3; do
      echo "== $r $t $(taskset -c 2 perf stat -r 7 -e cycles:u,instructions:u ./bins/compiler-$t "${flags[@]}" 2>&1 | grep -E "cycles|instructions" | awk "{print \$1}" | tr "\n" " ")"
    done
  done
  for i in $(seq 11); do
    for t in main16 m16 p3; do
      taskset -c 2 ./bins/compiler-$t --time-stages "${flags[@]}" 2>&1 | awk -F"\t" -v T=$t "\$1 == \"time-stage\" && (\$2 == \"preprocess\" || \$2 == \"tier0\" || \$2 == \"total\") {print T, \$2, \$3}"
    done
  done > stages-p3.txt
  for t in main16 m16 p3; do for s in preprocess tier0 total; do
    awk -v T=$t -v S=$s "\$1 == T && \$2 == S {print \$3}" stages-p3.txt | sort -g | awk -v T=$t -v S=$s "{a[NR]=\$1} END {printf \"%s %-10s median %.3f\n\", T, S, a[int((NR+1)/2)]}"
  done; done
  taskset -c 2 perf record -q -e cycles:u -c 100000 -o pu-cyc-p3.data -- bash -c "for i in \$(seq 300); do ./bins/compiler-p3 \"\$@\"; done" _ "${flags[@]}" > /dev/null 2>&1 || echo "record failed p3"
' x "$sqlite"
perf report -q -i pu-cyc-p3.data --no-children --comm compiler-p3 --sort symbol --stdio -F overhead,sample,symbol 2>/dev/null | grep -v "^$" > pu-cyc-p3.txt
perf report -q -i pu-cyc-p3.data --no-children --comm compiler-p3 --sort srcline --stdio -F overhead,sample,srcline 2>/dev/null | grep -v "^$" > pu-cyc-lines-p3.txt
echo DONE

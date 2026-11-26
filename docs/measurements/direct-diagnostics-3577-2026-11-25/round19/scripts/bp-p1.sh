#!/bin/bash
# bp-p1.sh: build main 1e1ca2dd6 (base tree), the merge e53577ce1 and the push fix 66495b323 (work tree), each under its
# own hold, keep their binaries in bins/, then measure them against each other in one hold.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
mkdir -p "$D/bins"
cd "$D/repo" || exit 1
git fetch -q origin main claude/adoring-goodall-mr1480 || exit 1
git fetch -q "$D/p1.bundle" || exit 1
build() { # TREE SHA NAME
  git -C "$D/$1" checkout -q -- . 2>/dev/null; git -C "$D/$1" checkout -q --detach "$2" || return 1
  echo "== build $3 $(git -C "$D/$1" log --oneline -1 | cut -c1-70) $(date -u +%H:%M:%S)"
  (cd "$D/$1" && EXCLUSIVE_TITLE="#3577 direct path: build $3" BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-$3.log" 2>&1)
  echo "status $? $(date -u +%H:%M:%S) $(tail -1 "$D/build-$3.log")"
  cp "$D/$1/build/compiler" "$D/bins/compiler-$3" && chmod +x "$D/bins/compiler-$3"
  "$D/bins/compiler-$3" --version > /dev/null || { echo "NO COMPILER $3"; return 1; }
}
build base 1e1ca2dd6 main16 || exit 1
build work e53577ce1 m16 || exit 1
build work 66495b323 p1 || exit 1
cd "$D" || exit 1
EXCLUSIVE_TITLE="#3577 direct path: measure main, merge and push fix" ~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
  taskset -c 2 ./bins/compiler-p1 measure-compile --runs 21 --reference ./bins/compiler-m16 --reference ./bins/compiler-main16 -- "${flags[@]}" 2>&1 | grep -E "median of|times,"
  for i in $(seq 15); do
    for t in main16 m16 p1; do
      taskset -c 2 ./bins/compiler-$t --time-stages "${flags[@]}" -o /tmp/3577-claude-p.o 2>&1 | awk -F"\t" -v T=$t "\$1 == \"time-stage\" && (\$2 == \"preprocess\" || \$2 == \"tier0\" || \$2 == \"total\") {print T, \$2, \$3}"
    done
  done > stages-p1.txt
  for t in main16 m16 p1; do for s in preprocess tier0 total; do
    awk -v T=$t -v S=$s "\$1 == T && \$2 == S {print \$3}" stages-p1.txt | sort -g | awk -v T=$t -v S=$s "{a[NR]=\$1} END {printf \"%s %-10s median %.3f\n\", T, S, a[int((NR+1)/2)]}"
  done; done
  for t in main16 m16 p1; do
    echo "== stat $t"; taskset -c 2 perf stat -r 15 -e cycles:u,instructions:u ./bins/compiler-$t "${flags[@]}" -o /tmp/3577-claude-p.o 2>&1 | grep -E "cycles|instructions" | sed "s/  */ /g"
  done
' x "$sqlite"
echo DONE

#!/bin/bash
# prof.sh TREE OUT: time-stages, perf stat and a perf profile of -c sqlite3.c, one lock hold.
set -uo pipefail
tree=$(realpath "$1"); out=$(realpath -m "$2"); mkdir -p "$out"
export TMPDIR=$HOME/buster-fast-bench/droid-zen5/tmp
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
cat > "$out/inner.sh" <<INNER
set -u
cd "$out"
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
c=$tree/build/compiler
for i in 1 2 3; do taskset -c 2 \$c "\${options[@]}" -o sqlite3.o --time-stages 2> stages-\$i.txt; echo "stages \$i status \$?"; done
taskset -c 2 \$c "\${options[@]}" -o sqlite3.o --lanes 1 --time-stages 2> stages-l1.txt; echo "stages lanes1 status \$?"
events=task-clock,page-faults,cycles:u,instructions:u,cycles:k,instructions:k,branch-misses:u
taskset -c 2 perf stat -r 11 -e "\$events" -o stat.txt -- \$c "\${options[@]}" -o sqlite3.o; echo "stat status \$?"
taskset -c 2 perf stat -r 11 -e "\$events" -o stat-l1.txt -- \$c "\${options[@]}" --lanes 1 -o sqlite3.o; echo "stat l1 status \$?"
taskset -c 2 perf record -q -F 20000 -o perf.data -- bash -c 'for run in 1 2 3 4 5; do "\$@" > /dev/null 2>&1 || exit 1; done' compile \$c "\${options[@]}" --lanes 1 -o sqlite3.o; echo "record status \$?"
INNER
EXCLUSIVE_OWNER=droid-zen5 EXCLUSIVE_TITLE="Droid: Zen 5 AVX-512 kernel optimization" EXCLUSIVE_LINK="https://github.com/buster14a/buster" \
  ~/buster-fast-bench/exclusive.sh bash "$out/inner.sh"
cd "$out"
perf report -i perf.data --stdio --no-children --sort dso --percent-limit 0.5 > dso.txt 2>/dev/null
perf report -i perf.data --stdio --no-children --sort symbol --percent-limit 0.2 > symbol.txt 2>/dev/null
echo done

#!/bin/bash
# A cycles profile of 20 compiles of sqlite3.c by each compiler, CPU 2. Usage: prof.sh OUT NAME...
set -u
out=$HOME/buster-fast-bench/1340-truth/results/$1; shift
bin=$HOME/buster-fast-bench/1340-truth/bin
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
rm -rf "$out"; mkdir -p "$out"; cd "$out"
{ date -u; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head; } > before.txt
O=(--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$S" "$S/sqlite3.c")
for n in "$@"; do
  cat > loop-$n.sh <<EOT
#!/bin/bash
for i in \$(seq 20); do $bin/compiler-$n ${O[@]} -o x.o || echo fail; done
EOT
  chmod +x loop-$n.sh
  taskset -c 2 perf record -q -e cycles:u -c 100003 -o perf-$n.data ./loop-$n.sh > /dev/null 2> err-$n.txt
  perf report -i perf-$n.data --stdio --sort symbol 2> /dev/null | grep -v "^#" | grep -v "^$" | head -400 > report-$n.txt
  rm -f perf-$n.data x.o
done
{ date -u; cat /proc/loadavg; } > after.txt
echo done > complete

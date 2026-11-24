#!/bin/bash
# The annotated cycles of one function over 20 compiles of sqlite3.c, CPU 2. Usage: annotate.sh OUT NAME SYMBOL
set -u
out=$HOME/buster-fast-bench/1340-truth/results/$1
bin=$HOME/buster-fast-bench/1340-truth/bin
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
rm -rf "$out"; mkdir -p "$out"; cd "$out"
{ date -u; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head; } > before.txt
O=(--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$S" "$S/sqlite3.c")
cat > loop.sh <<EOT
#!/bin/bash
for i in \$(seq 20); do $bin/compiler-$2 ${O[@]} -o x.o || echo fail; done
EOT
chmod +x loop.sh
taskset -c 2 perf record -q -e cycles:u -c 20011 -o perf.data ./loop.sh > /dev/null 2> err.txt
perf annotate -i perf.data --stdio -s "$3" 2> /dev/null > annotate.txt
rm -f perf.data x.o
{ date -u; cat /proc/loadavg; } > after.txt
echo done > complete

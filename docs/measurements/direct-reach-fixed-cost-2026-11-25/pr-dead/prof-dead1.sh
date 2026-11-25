#!/bin/bash
# prof-dead1.sh: perf record of 30 sqlite3.c compiles by each of atom1 and dead1 on CPU 2, cycles and instructions by
# symbol, for #3592's step 6d.
set -uo pipefail
here=$HOME/buster-fast-bench/direct-designs-np4nn5
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
unit=(--lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include"
      -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c")
tmp=$(mktemp -d /dev/shm/pf-np4nn5.XXXXXX)
for n in atom1 dead1; do
  cat > "$tmp/run-$n.sh" <<EOS
#!/bin/bash
for i in \$(seq 30); do taskset -c 2 $here/bin/compiler-$n ${unit[*]} -o $tmp/out-$n.o > /dev/null 2>&1; done
EOS
  chmod +x "$tmp/run-$n.sh"
  perf record -q -e cycles:u,instructions:u -c 20011 -o "$tmp/$n.data" -- "$tmp/run-$n.sh" > /dev/null 2>&1
  perf report --stdio -i "$tmp/$n.data" --sort sym --comms compiler-$n > "$here/results/prof-dead1-$n.txt" 2> "$here/results/prof-dead1-$n.err"
done
rm -rf "$tmp"

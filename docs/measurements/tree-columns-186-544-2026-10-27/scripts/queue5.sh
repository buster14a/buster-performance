#!/bin/bash
# queue5.sh: three holds of the lock, each about a minute:
#   1. head3's build (without -g) and the -c A/B main vs head3 (measure.sh's own lock call nests);
#   2. benchmark-parser --only stages by head3 on sqlite3.c, the libc corpus and main.c, one process each;
#   3. main's build with -g, then perf record of 5 `-c` compiles of the frozen sqlite3.c.
base=~/buster-fast-bench/tree-186-544-claude
cd $base
cat > hold1.sh <<'H1'
#!/bin/bash
cd ~/buster-fast-bench/tree-186-544-claude/head3 && BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2>&1 && tail -1 build.log
cd ~/buster-fast-bench/tree-186-544-claude && ./measure.sh main head3 ab4 > ab4.txt 2>&1
H1
cat > hold2.sh <<'H2'
#!/bin/bash
base=~/buster-fast-bench/tree-186-544-claude
out=$base/parser3
mkdir -p $out
exe=$base/head3/build/compiler
SQLITE=~/buster-fast-bench/refine-claude/inputs/sqlite3.c
LIBC="$(cat ~/buster-fast-bench/parser-claude/inputs/libc.txt | tr '\n' ' ')"
MAINC="-march=native -I$base/main/src -fwrapv -funsigned-char --predefines $base/parser1/predefines.h $base/main/src/buster/compiler/main.c"
taskset -c 2 $exe benchmark-parser --only stages $SQLITE > "$out/sqlite3-head3.txt" 2>&1
taskset -c 2 $exe benchmark-parser --only stages $LIBC > "$out/libc-head3.txt" 2>&1
taskset -c 2 $exe benchmark-parser --only stages $MAINC > "$out/mainc-head3.txt" 2>&1
H2
cat > hold3.sh <<'H3'
#!/bin/bash
base=~/buster-fast-bench/tree-186-544-claude
cd $base && rm -rf main-g && cp -r main main-g && rm -rf main-g/build
(cd main-g && ./build.sh > build.log 2>&1)
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
exe=$base/main-g/build/compiler
perf record -F 20000 -o $base/walk.data -- bash -c "for i in 1 2 3 4 5; do taskset -c 2 $exe -c --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c -o /dev/null; done" > $base/perf-record.log 2>&1
H3
chmod +x hold1.sh hold2.sh hold3.sh
./lock.sh ./hold1.sh > hold1.log 2>&1
./lock.sh ./hold2.sh > hold2.log 2>&1
./lock.sh ./hold3.sh > hold3.log 2>&1
perf report -i walk.data --no-children --sort symbol --stdio 2> /dev/null | grep -v '^#' | head -40 > walk-symbols.txt
perf report -i walk.data --no-children --symbols check_input_expressions --sort srcline --stdio 2> /dev/null | grep -v '^#' | grep -v '^$' > walk-lines.txt
echo done > queue5.done

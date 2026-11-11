#!/bin/bash
set -e
export LC_ALL=C
B=$HOME/buster-fast-bench/1447-c2-claude; T=$B/trees; M=$B/m
cd $T
for pair in base4:66e05fbfba750aad1639887e87c38f89fdc9de79 gate:d0c1ee08e080a87eecb73017fd9d12324a1dcf82; do
  name=${pair%%:*}; rev=${pair#*:}
  [ -d $name ] || git clone -q --reference base1 https://github.com/buster14a/buster $name
  git -C $name fetch -q origin main claude/segment-arrow-lookup-gate
  git -C $name checkout -q $rev; git -C $name rev-parse HEAD > $name/COMMIT
  ~/buster-fast-bench/exclusive.sh bash -c "cd $T/$name && BUSTER_DEBUG_INFO=0 ./build.sh" > $M/build-$name.log 2>&1
  sha256sum $name/build/compiler >> $M/receipt.txt
done
CORPUS=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
cat > $B/gate-perf.sh <<'IN'
#!/bin/bash
export LC_ALL=C
B=$HOME/buster-fast-bench/1447-c2-claude; T=$B/trees; M=$B/m
CORPUS=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
SQLITE=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$CORPUS/sqlite" "$CORPUS/sqlite/sqlite3.c")
MAINC=(-c -march=native "-I$T/base1/src" -fwrapv -funsigned-char -fno-strict-aliasing "$T/base1/src/buster/compiler/main.c")
export SOURCE_DATE_EPOCH=1792454400; unset CPATH C_INCLUDE_PATH
out=$M/gate-perf.tsv; echo -e "round\ttree\tinput\tinstructions\tcycles\tmsec" > $out
for r in 1 2 3; do for t in base4 gate; do for input in sqlite main; do
  if [ $input = sqlite ]; then args=("${SQLITE[@]}"); else args=("${MAINC[@]}"); fi
  f=$M/g-$r-$t-$input.csv
  perf stat -x, -e instructions:u,cycles:u,task-clock -o $f taskset -c 2 $T/$t/build/compiler -o $M/gate-$t-$input.o "${args[@]}" > /dev/null 2>&1
  echo -e "$r\t$t\t$input\t$(grep instructions $f | cut -d, -f1)\t$(grep cycles $f | cut -d, -f1)\t$(grep task-clock $f | cut -d, -f1)" >> $out
done; done; done
sha256sum $M/gate-*.o > $M/gate-objects.sha256
IN
chmod +x $B/gate-perf.sh
~/buster-fast-bench/exclusive.sh $B/gate-perf.sh
cat $M/gate-perf.tsv $M/gate-objects.sha256

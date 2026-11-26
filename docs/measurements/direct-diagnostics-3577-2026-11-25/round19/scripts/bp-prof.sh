#!/bin/bash
# bp-prof.sh NAME: unthrottled cycle (-c 100000) and op (IBS -c 262144) profiles of bins/compiler-NAME, 300 compiles each.
NAME=$1
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597 EXCLUSIVE_TITLE="#3577 direct path: profiles of $NAME"
cd "$D" || exit 1
cat > prof-run.sh << 'EOR'
#!/bin/bash
NAME=$1; sqlite=$2
flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-p.o)
for i in $(seq 300); do ./bins/compiler-$NAME "${flags[@]}"; done
EOR
chmod +x prof-run.sh
~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  taskset -c 2 perf record -q -e cycles:u -c 100000 -o pu-cyc-$1.data -- ./prof-run.sh $1 $2 > /dev/null 2>&1 || echo "record failed cyc"
  taskset -c 2 perf record -q -e ibs_op/cnt_ctl=1,swfilt=1/u -c 262144 -o pu-op-$1.data -- ./prof-run.sh $1 $2 > /dev/null 2>&1 || echo "record failed op"
' x "$NAME" "$sqlite"
for k in cyc op; do
  perf report -q -i pu-$k-$NAME.data --no-children --comm compiler-$NAME --sort symbol --stdio -F overhead,sample,symbol 2>/dev/null | grep -v "^$" > pu-$k-$NAME.txt
  perf report -q -i pu-$k-$NAME.data --no-children --comm compiler-$NAME --sort srcline --stdio -F overhead,sample,srcline 2>/dev/null | grep -v "^$" > pu-$k-lines-$NAME.txt
  echo "$k: $(wc -l < pu-$k-$NAME.txt) symbols, $(awk '{s+=$2} END {print s}' pu-$k-$NAME.txt) samples"
done
rm -f pu-cyc-$NAME.data pu-op-$NAME.data
echo DONE

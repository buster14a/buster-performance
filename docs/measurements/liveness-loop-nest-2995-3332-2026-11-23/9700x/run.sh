#!/bin/bash
# PR #3332 (#2995 nested loops' liveness) on the 9700X: main 1b9821a (base) vs PR head 8b01bc9 (new), Release.
# One hold per run.
D=~/buster-fast-bench/3332-claude
cd $D
export EXCLUSIVE_OWNER=claude-3332 EXCLUSIVE_TITLE="PR 3332 merge-ready (liveness loop nests, #2995)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3332
X=~/buster-fast-bench/exclusive.sh
mkdir -p nests results inputs
[ -d inputs/sqlite ] || cp -r ~/buster-fast-bench/1296-codex-20261105/corpus/sqlite inputs/sqlite
[ -d inputs/lua-5.4.8 ] || cp -r ~/buster-fast-bench/1360-claude/inputs/lua-5.4.8 inputs/lua-5.4.8
for t in base new; do
  if [ ! -x $t/build/compiler ]; then
    (cd $D/$t && $X bash -c 'cat /proc/loadavg; BUSTER_DEBUG_INFO=0 ./build.sh --config Release') > results/build-$t.log 2>&1
    echo "$t build rc=$?" >> results/status.txt
  fi
done
for n in 256 500 1000 2000 4000 8000; do
  python3 -c "n=$n; print('int main(void){volatile int a=1;int r=0;' + ''.join('for(int i%d=0;i%d<a;i%d++)' % (i,i,i) for i in range(n)) + 'r++;return r!=1;}')" > nests/loop-$n.c
done
python3 -c "n=4000; print('int main(void){volatile int a=1;int r=0;int*p=&r;' + ''.join('for(int i%d=0;i%d<a;i%d++)' % (i,i,i) for i in range(n)) + '*p+=1;return r!=1;}')" > nests/ptr-4000.c
python3 -c "n=4000; print('int main(void){volatile int a=1;int r=0;' + ''.join('for(int i%d=0;i%d<a;i%d++){if(i%d==3)break;' % (i,i,i,i) for i in range(n)) + 'r++;'+'}'*n+'return r!=1;}')" > nests/brk-4000.c
cat > one.sh <<'EOS'
#!/bin/bash
# one.sh BUILD FILE LIMIT: one timed --tier1 -c compile on CPU 2, with the load before and after.
{ echo "== $1 $2 $(date -u +%FT%TZ) load $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> results/load.log
TIMEFORMAT=%R
t=$( { time taskset -c 2 timeout -k 5 $3 $1/build/compiler -w --tier1 -c $2 -o /dev/shm/claude-3332-$1.o > /dev/null 2>&1; echo "rc=$?" > /dev/shm/claude-3332-rc; } 2>&1 )
echo -e "$1\t$(basename $2 .c)\t$(cat /dev/shm/claude-3332-rc)\t$t" >> results/nests.tsv
echo "   after: load $(cat /proc/loadavg)" >> results/load.log
EOS
chmod +x one.sh
# All of one rep's short nests in one hold; the long base runs one per hold.
for rep in 1 2 3; do
  $X bash -c 'for n in 256 500 1000 2000; do for t in base new; do ./one.sh $t nests/loop-$n.c 150; done; done; for n in 4000 8000; do ./one.sh new nests/loop-$n.c 150; done; for f in ptr-4000 brk-4000; do ./one.sh new nests/$f.c 150; done'
  if [ $rep = 1 ]; then
    for f in loop-4000 loop-8000 ptr-4000 brk-4000; do $X ./one.sh base nests/$f.c 150; done
  fi
done
for i in 1 2 3 4 5; do for t in base new; do
  $X bash -c "cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; taskset -c 2 $t/build/compiler benchmark-dataflow; echo rc=\$?; cat /proc/loadavg" > results/benchmark-dataflow-$t-$i.txt 2>&1
done; done
$X bash -c "cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; taskset -c 2 $D/new/build/compiler time-runs --runs 11 --warmups 1 --build base $D/base/build/compiler --build new $D/new/build/compiler --list -w --tier1 -c $D/inputs/sqlite/sqlite3.c -o /dev/shm/claude-3332-sqlite3.o; cat /proc/loadavg" > results/time-runs-sqlite.txt 2>&1
$X bash -c "cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cd /dev/shm && mkdir -p claude-3332-lua && cd claude-3332-lua && taskset -c 2 $D/new/build/compiler time-runs --runs 11 --warmups 1 --build base $D/base/build/compiler --build new $D/new/build/compiler --list -w --tier1 -c $(ls $D/inputs/lua-5.4.8/src/*.c | tr '\n' ' '); cat /proc/loadavg" > results/time-runs-lua.txt 2>&1
rm -rf /dev/shm/claude-3332-*
echo done > results/DONE

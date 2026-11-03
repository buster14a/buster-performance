#!/bin/bash
# round-review.sh MAIN HEAD (#1203 review): build both trees, then, each in its own hold of the lock: the Lua link by 1, 2, 4 and 8 lanes
# (11 runs) with strace counts by 1 and 8; synth by 1 and 8 lanes (5 runs) and sqlite3.c -c on CPU 2 (11 runs); and the
# 9700X step's benchmark-check-units (head's) of each build. Logs in logs/round-HEAD/.
set -u
D=$HOME/buster-fast-bench/1128-claude
main=$1; head=$2
R=$D/logs/review-$head
mkdir -p $R
X=(env EXCLUSIVE_OWNER=claude-1128 EXCLUSIVE_TITLE=solve-1128-review-fixes EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1203)
S=$R/status
: > $S
for t in $main $head; do
  (cd $D/$t && find . -type f ! -path './build/*' -print0 | LC_ALL=C sort -z | xargs -0 sha256sum) > $R/host-manifest-$t.txt
  cd $D/$t && "${X[@]}" ~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh > $R/build-$t.log 2>&1
  echo "build $t $?" >> $S
done
M=$D/$main/build/compiler; H=$D/$head/build/compiler
{ uname -r; clang --version | head -1; strace -V | head -1; cat /proc/sys/vm/overcommit_memory; cat /sys/kernel/mm/transparent_hugepage/enabled; sha256sum $M $H; } > $R/receipts.txt 2>&1
cat > $R/inner-lua.sh <<INNER
#!/bin/bash
cd $D/lua
L=(-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -w)
lists=()
for n in 1 2 4 8; do lists+=(--list "\${L[@]}" --lanes \$n -o $D/out/lua *.c -lm -ldl); done
taskset -c 0-7 $M time-runs --runs 11 --warmups 1 --build main $M --build head $H "\${lists[@]}"
for b in main head; do for n in 1 8; do
  exe=$M; [ \$b = head ] && exe=$H
  taskset -c 0-7 strace -f -c -o $R/strace-\$b-\$n.txt \$exe "\${L[@]}" --lanes \$n -o $D/out/lua-\$b-\$n *.c -lm -ldl
  echo "strace \$b \$n status \$?"
done; done
sha256sum $D/out/lua-main-1 $D/out/lua-main-8 $D/out/lua-head-1 $D/out/lua-head-8
INNER
chmod +x $R/inner-lua.sh
"${X[@]}" ~/buster-fast-bench/exclusive.sh $R/inner-lua.sh > $R/lua.log 2>&1
echo "lua $?" >> $S
C=$HOME/buster-fast-bench/corpus-391e729af658
cat > $R/inner-synth.sh <<INNER
#!/bin/bash
cd $D/synth
taskset -c 0-7 $M time-runs --runs 5 --warmups 1 --build main $M --build head $H --list --lanes 1 -o $D/out/synth \$(ls unit_*.c | sort -V) --list --lanes 8 -o $D/out/synth \$(ls unit_*.c | sort -V)
cd $D
sqlite=(--predefines $C/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include $C/sqlite/sqlite3.c)
taskset -c 2 $M time-runs --runs 11 --warmups 1 --build main $M --build head $H --list -c -o $D/out/sqlite3.o "\${sqlite[@]}"
sha256sum $C/sqlite/sqlite3.c
INNER
chmod +x $R/inner-synth.sh
"${X[@]}" ~/buster-fast-bench/exclusive.sh $R/inner-synth.sh > $R/synth.log 2>&1
echo "synth $? " >> $S
cat > $R/inner-bench.sh <<INNER
#!/bin/bash
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
options=(--predefines "\$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "\$corpus/headers/usr/lib/clang/23/include" -isystem "\$corpus/headers/usr/local/include" -isystem "\$corpus/headers/usr/include")
for b in main head; do
  exe=$M; [ \$b = head ] && exe=$H
  echo "== benchmark-check-units of \$b"
  $H benchmark-check-units --executable \$exe --lanes 1,2,4,8 --runs 5 -- "\${options[@]}"
  echo "status \$?"
done
INNER
chmod +x $R/inner-bench.sh
"${X[@]}" ~/buster-fast-bench/exclusive.sh $R/inner-bench.sh > $R/bench.log 2>&1
echo "bench $?" >> $S
echo done >> $S

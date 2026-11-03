#!/bin/bash
# round-tables1.sh: build head-tables1, then (each in its own hold) the Lua link by 1, 2, 4 and 8 lanes with strace counts,
# and synth by 1 and 8 lanes with sqlite3.c -c, main-b70deb47 against head-tables1.
set -u
D=$HOME/buster-fast-bench/1128-claude
X=(env EXCLUSIVE_OWNER=claude-1128 EXCLUSIVE_TITLE=solve-1128-units-arenas EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1128)
S=$D/logs/round-tables1.status
cd $D/head-tables1 && "${X[@]}" ~/buster-fast-bench/exclusive.sh ./build.sh > $D/logs/build-head-tables1.log 2>&1
echo "build $?" > $S
main=$D/main-b70deb47/build/compiler; head=$D/head-tables1/build/compiler
cat > $D/logs/inner-lua-tables1.sh <<INNER
#!/bin/bash
cd $D/lua
L=(-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -w)
uname -r; cat /proc/sys/vm/overcommit_memory; cat /sys/kernel/mm/transparent_hugepage/enabled
lists=()
for n in 1 2 4 8; do lists+=(--list "\${L[@]}" --lanes \$n -o $D/out/lua *.c -lm -ldl); done
taskset -c 0-7 $main time-runs --runs 11 --warmups 1 --build main $main --build head $head "\${lists[@]}"
for b in main head; do for n in 1 8; do
  exe=$main; [ \$b = head ] && exe=$head
  taskset -c 0-7 strace -f -c -o $D/logs/strace-tables1-\$b-\$n.txt \$exe "\${L[@]}" --lanes \$n -o $D/out/lua-\$b-\$n *.c -lm -ldl
done; done
sha256sum $D/out/lua-main-1 $D/out/lua-main-8 $D/out/lua-head-1 $D/out/lua-head-8
INNER
chmod +x $D/logs/inner-lua-tables1.sh
"${X[@]}" ~/buster-fast-bench/exclusive.sh $D/logs/inner-lua-tables1.sh > $D/logs/lua-tables1.log 2>&1
echo "lua $?" >> $S
C=$HOME/buster-fast-bench/corpus-391e729af658
cat > $D/logs/inner-synth-tables1.sh <<INNER
#!/bin/bash
cd $D/synth
taskset -c 0-7 $main time-runs --runs 5 --warmups 1 --build main $main --build head $head --list --lanes 1 -o $D/out/synth \$(ls unit_*.c | sort -V) --list --lanes 8 -o $D/out/synth \$(ls unit_*.c | sort -V)
cd $D
sqlite=(--predefines $C/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include $C/sqlite/sqlite3.c)
taskset -c 2 $main time-runs --runs 11 --warmups 1 --build main $main --build head $head --list -c -o $D/out/sqlite3.o "\${sqlite[@]}"
INNER
chmod +x $D/logs/inner-synth-tables1.sh
"${X[@]}" ~/buster-fast-bench/exclusive.sh $D/logs/inner-synth-tables1.sh > $D/logs/synth-tables1.log 2>&1
echo "synth $?" >> $S
echo done >> $S

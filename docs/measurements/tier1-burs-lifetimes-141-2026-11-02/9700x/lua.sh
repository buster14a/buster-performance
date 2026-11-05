#!/usr/bin/env bash
# lua.sh OUT TREE...: Lua 5.4.8's interpreter built by each tree's --tier1 (and clang -O0 as the outputs' oracle), each
# build's --tier1-report per file (BUSTER lvm.c's rows among them), each of the five scripts' output against clang
# -O0's, then 11 rounds of every build in a rotating order, a round one hold of the lock, CPU 2; perf stat of each run.
. ~/buster-fast-bench/claude-141-takeover/common.sh
out=$PWD/$1
shift
trees=("$@")
mkdir -p $out
lua_files=""
for f in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do
    lua_files="$lua_files $LUA/$f.c"
done
cp $LUA_SCRIPTS/*.lua $out/
"$lock" bash -c "cd $out && taskset -c 2 clang -O0 -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o lua-clang0 $lua_files -lm -ldl > build-clang0.txt 2>&1; echo \"exit \$?\" >> build-clang0.txt"
for t in "${trees[@]}"; do
    "$lock" bash -c "cd $out && taskset -c 2 $PWD/$t/build/compiler --tier1 --tier1-report -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o lua-$t $lua_files -lm -ldl > build-$t.txt 2>&1; echo \"exit \$?\" >> build-$t.txt"
    "$lock" bash -c "cd $out && taskset -c 2 $PWD/$t/build/compiler --tier1 --tier1-report -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o $RUNDIR/lvm.o $LUA/lvm.c > report-lvm-$t.txt 2>&1"
done
scripts=(calls tables strings arithmetic closures)
"$lock" bash -c "cd $out && for s in ${scripts[*]}; do for c in clang0 ${trees[*]}; do [ -x lua-\$c ] && taskset -c 2 ./lua-\$c \$s.lua > \$s-\$c.out 2>&1; echo \"\$s \$c \$?\" >> status.txt; done; done"
"$lock" bash -c "cd $out && for s in ${scripts[*]}; do for c in ${trees[*]}; do echo \"\$s \$c \$(cmp \$s-clang0.out \$s-\$c.out > /dev/null 2>&1 && echo same || echo differs)\"; done; done > compare.txt"
cat > $out/round.sh <<ROUND
#!/usr/bin/env bash
# round.sh ROUND: each build's run of every script, the builds in an order rotating by ROUND; a line per run: the round,
# the script, the build and the microseconds from before the run's fork to after its wait.
cd "\$(dirname "\$0")"
compilers=(${trees[*]})
n=\${#compilers[@]}
for s in calls tables strings arithmetic closures; do
    for i in \$(seq 0 \$((n - 1))); do
        c=\${compilers[\$(( (\$1 + i) % n ))]}
        [ -x lua-\$c ] || continue
        start=\$EPOCHREALTIME
        taskset -c 2 ./lua-\$c \$s.lua > /dev/null 2>&1
        end=\$EPOCHREALTIME
        echo "\$1 \$s \$c \$(( \${end/./} - \${start/./} ))"
    done
done
ROUND
chmod +x $out/round.sh
: > $out/times.txt
for r in $(seq 0 10); do
    "$lock" bash -c "$out/round.sh $r >> $out/times.txt"
done
for c in "${trees[@]}"; do
    "$lock" bash -c "cd $out && for s in ${scripts[*]}; do taskset -c 2 perf stat -x, -e instructions:u,cycles:u -o stat-\$s-$c.txt -- ./lua-$c \$s.lua > /dev/null 2>&1; done"
done
echo done > $out/done

#!/bin/bash
# prof9700.sh: build main-b70deb47, then perf record its Lua link by 8 lanes (3 runs) and 1 lane (1 run) on CPUs 0-7, each in one hold.
set -u
D=$HOME/buster-fast-bench/1128-claude
X="EXCLUSIVE_OWNER=claude-1128 EXCLUSIVE_TITLE=solve-1128-units-arenas EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1128"
cd $D/main-b70deb47 && env $X ~/buster-fast-bench/exclusive.sh ./build.sh > $D/logs/build-main-b70deb47.log 2>&1
echo "build $?" > $D/logs/prof-main-b70deb47.status
cat > $D/logs/inner-prof-main-b70deb47.sh <<'INNER'
#!/bin/bash
D=$HOME/buster-fast-bench/1128-claude
cd $D/lua
for r in 1 2 3; do taskset -c 0-7 perf record -q -F 25000 -g -o $D/logs/perf-main-b70deb47-8-$r.data $D/main-b70deb47/build/compiler -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -w --lanes 8 -o $D/out/lua-p *.c -lm -ldl; done
taskset -c 0-7 perf record -q -F 25000 -g -o $D/logs/perf-main-b70deb47-1-1.data $D/main-b70deb47/build/compiler -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -w --lanes 1 -o $D/out/lua-p *.c -lm -ldl
for n in 1 8; do taskset -c 0-7 $D/main-b70deb47/build/compiler -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -w --lanes $n --time-stages -o $D/out/lua-p *.c -lm -ldl 2>&1 | grep -E 'time-stage\tlanes|time-stage\ttotal|user-ms|system-ms'; done
INNER
chmod +x $D/logs/inner-prof-main-b70deb47.sh
env $X ~/buster-fast-bench/exclusive.sh $D/logs/inner-prof-main-b70deb47.sh > $D/logs/prof-main-b70deb47.log 2>&1
echo "prof $?" >> $D/logs/prof-main-b70deb47.status
for f in $D/logs/perf-main-b70deb47-*.data; do perf script -i $f -F comm,tid,ip,sym 2>/dev/null | awk -f $D/scripts/classify.awk | sort -rn > ${f%.data}.classified; done
echo done >> $D/logs/prof-main-b70deb47.status

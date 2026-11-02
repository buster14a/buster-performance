#!/bin/bash
# profile.sh TAG TREE LANES: perf record of the Lua link (5 runs, kernel callchains) on CPUs 0-7, in one hold.
set -u
D=$HOME/buster-fast-bench/1128-claude
tag=$1; exe=$D/$2/build/compiler; lanes=$3
mkdir -p $D/out $D/logs
cat > $D/logs/inner-prof-$tag.sh <<INNER
#!/bin/bash
cd $D/lua
for r in 1 2 3 4 5; do
  taskset -c 0-7 perf record -q -F 25000 -g -o $D/logs/perf-$tag-\$r.data $exe -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -w --lanes $lanes -o $D/out/lua-p *.c -lm -ldl
done
INNER
chmod +x $D/logs/inner-prof-$tag.sh
EXCLUSIVE_OWNER=claude-1128 EXCLUSIVE_TITLE="solve #1128 profile $tag" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1128 \
    ~/buster-fast-bench/exclusive.sh $D/logs/inner-prof-$tag.sh > $D/logs/profile-$tag.log 2>&1
for r in 1 2 3 4 5; do perf report -i $D/logs/perf-$tag-$r.data --children --sort sym --stdio -q -g none 2>/dev/null > $D/logs/report-$tag-$r.txt; done
perf report -i $D/logs/perf-$tag-1.data --no-children --sort sym --stdio -q -g none 2>/dev/null > $D/logs/self-$tag-1.txt
echo done

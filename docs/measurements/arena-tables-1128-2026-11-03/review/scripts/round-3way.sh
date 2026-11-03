#!/bin/bash
# round-3way.sh MAIN HEAD VARIANT (#1203 review): build VARIANT, then, each in its own hold of the lock: the Lua link by
# 1 and 8 lanes (11 runs), and synth by 1 and 8 lanes (5 runs) with sqlite3.c -c on CPU 2 (11 runs), the three builds
# interleaved by time-runs. Logs in logs/3way-VARIANT/.
set -u
D=$HOME/buster-fast-bench/1128-claude
main=$1; head=$2; variant=$3
R=$D/logs/3way-$variant
mkdir -p $R
X=(env EXCLUSIVE_OWNER=claude-1128 EXCLUSIVE_TITLE=solve-1128-review-fixes EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1203)
S=$R/status
: > $S
(cd $D/$variant && find . -type f ! -path './build/*' -print0 | LC_ALL=C sort -z | xargs -0 sha256sum) > $R/host-manifest-$variant.txt
cd $D/$variant && "${X[@]}" ~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh > $R/build-$variant.log 2>&1
echo "build $variant $?" >> $S
M=$D/$main/build/compiler; H=$D/$head/build/compiler; V=$D/$variant/build/compiler
sha256sum $M $H $V > $R/receipts.txt 2>&1
cat > $R/inner-lua.sh <<INNER
#!/bin/bash
cd $D/lua
L=(-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -w)
taskset -c 0-7 $M time-runs --runs 11 --warmups 1 --build main $M --build head $H --build variant $V --list "\${L[@]}" --lanes 1 -o $D/out/lua *.c -lm -ldl --list "\${L[@]}" --lanes 8 -o $D/out/lua *.c -lm -ldl
INNER
chmod +x $R/inner-lua.sh
"${X[@]}" ~/buster-fast-bench/exclusive.sh $R/inner-lua.sh > $R/lua.log 2>&1
echo "lua $?" >> $S
C=$HOME/buster-fast-bench/corpus-391e729af658
cat > $R/inner-synth.sh <<INNER
#!/bin/bash
cd $D/synth
taskset -c 0-7 $M time-runs --runs 5 --warmups 1 --build main $M --build head $H --build variant $V --list --lanes 1 -o $D/out/synth \$(ls unit_*.c | sort -V) --list --lanes 8 -o $D/out/synth \$(ls unit_*.c | sort -V)
cd $D
sqlite=(--predefines $C/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include $C/sqlite/sqlite3.c)
taskset -c 2 $M time-runs --runs 11 --warmups 1 --build main $M --build head $H --build variant $V --list -c -o $D/out/sqlite3.o "\${sqlite[@]}"
INNER
chmod +x $R/inner-synth.sh
"${X[@]}" ~/buster-fast-bench/exclusive.sh $R/inner-synth.sh > $R/synth.log 2>&1
echo "synth $?" >> $S
echo done >> $S

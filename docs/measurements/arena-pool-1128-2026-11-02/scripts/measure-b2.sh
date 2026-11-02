#!/bin/bash
# measure-b2.sh TAG MAIN HEAD: in one hold, synth's 512 units linked by --lanes 1 and 8 on CPUs 0-7 (5 runs), and the
# frozen sqlite3.c by -c alone on CPU 2 (11 runs), main and head interleaved (time-runs). Writes logs/measure-TAG.done.
set -u
D=$HOME/buster-fast-bench/1128-claude
tag=$1; main=$D/$2/build/compiler; head=$D/$3/build/compiler
C=$HOME/buster-fast-bench/corpus-391e729af658
cat > $D/logs/inner-$tag.sh <<INNER
#!/bin/bash
set -u
echo "main: \$(cat $D/$2/COMMIT) head: \$(cat $D/$3/COMMIT)"
[ -f $D/synth/unit_0.c ] || $main test-check-units --generate $D/synth > /dev/null
cd $D/synth
taskset -c 0-7 $main time-runs --runs 5 --warmups 1 --build main $main --build head $head --list --lanes 1 -o $D/out/synth \$(ls unit_*.c | sort -V) --list --lanes 8 -o $D/out/synth \$(ls unit_*.c | sort -V)
cd $D
sqlite=(--predefines $C/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include $C/sqlite/sqlite3.c)
taskset -c 2 $main time-runs --runs 11 --warmups 1 --build main $main --build head $head --list -c -o $D/out/sqlite3.o "\${sqlite[@]}"
INNER
chmod +x $D/logs/inner-$tag.sh
EXCLUSIVE_OWNER=claude-1128 EXCLUSIVE_TITLE="solve #1128 measure $tag" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1128 \
    ~/buster-fast-bench/exclusive.sh $D/logs/inner-$tag.sh > $D/logs/measure-$tag.log 2>&1
echo "exit $?" >> $D/logs/measure-$tag.log
touch $D/logs/measure-$tag.done

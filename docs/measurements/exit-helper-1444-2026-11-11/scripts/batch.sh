#!/bin/sh
# #1444's exit helper: 400 processes of one input, J at a time (xargs -P J), base, lanes and head alternated, 5 rounds,
# under perf stat on every CPU: the elapsed time and every CPU's unhalted cycles (the compiles', their kernel work and
# the helpers' and kworkers' teardowns). One hold.
#   batch.sh TAG
. ~/buster-fast-bench/1444-claude-exit/env.sh
cd $d/inputs
tag=$1
cat > $d/batch-inner.sh <<'INNER'
#!/bin/sh
d=~/buster-fast-bench/1444-claude-exit
tag=$1
for input in tiny.c hello.c; do
    i=0
    : > $d/list-$input
    while [ $i -lt 400 ]; do echo $input >> $d/list-$input; i=$((i + 1)); done
done
for jobs in 1 8 16; do
    for input in tiny.c hello.c; do
        round=1
        while [ $round -le 5 ]; do
            for build in base lanes head; do
                perf stat -a -e cycles,instructions -o $d/results/batch-$build-$input-j$jobs-$round-$tag.txt -- xargs -a $d/list-$input -P $jobs -I{} $d/shifts-$build/compiler-0 -c {} -o /dev/null
            done
            round=$((round + 1))
        done
    done
done
INNER
chmod +x $d/batch-inner.sh
mkdir -p $d/results
~/buster-fast-bench/exclusive.sh $d/batch-inner.sh $tag > $d/results/batch-$tag.log 2>&1
echo done > $d/results/batch-$tag.done

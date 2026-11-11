#!/bin/sh
# #1444: many small compiles at once, as a build runs them: 400 processes of one input, J at a time (xargs -P J), base
# and head alternated, 5 rounds, under perf stat on every CPU: the elapsed time, and the unhalted cycles of every CPU (the
# compiles' work and the kernel's for them, the kworkers that tear down address spaces among it). One hold.
#   batch.sh TAG
d=~/buster-fast-bench/1444-claude-lanes
cd $d/inputs
export EXCLUSIVE_OWNER=claude-1444-lanes EXCLUSIVE_TITLE="Start fewer lanes for a small compile (#1444)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1444
tag=$1
cat > $d/batch-inner.sh <<'INNER'
#!/bin/sh
d=~/buster-fast-bench/1444-claude-lanes
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
            for build in base head; do
                perf stat -a -e cycles,instructions -o $d/results/batch-$build-$input-j$jobs-$round-$tag.txt -- xargs -a $d/list-$input -P $jobs -I{} $d/shifts-$build/compiler-0 -c {} -o /dev/null
            done
            round=$((round + 1))
        done
    done
done
INNER
chmod +x $d/batch-inner.sh
~/buster-fast-bench/exclusive.sh $d/batch-inner.sh $tag > $d/results/batch-$tag.log 2>&1
echo done > $d/results/batch-$tag.done

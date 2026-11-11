#!/bin/sh
# #1444: perf stat of base's and head's placement-0 executables, alternated in blocks of 100 processes, 4 blocks each:
# elapsed, user and system time, task clock, user and kernel cycles, faults and switches. One hold.
#   kstat.sh TAG
d=~/buster-fast-bench/1444-claude-lanes
cd $d/inputs
export EXCLUSIVE_OWNER=claude-1444-lanes EXCLUSIVE_TITLE="Start fewer lanes for a small compile (#1444)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1444
tag=$1
cat > $d/kstat-inner.sh <<'INNER'
#!/bin/sh
d=~/buster-fast-bench/1444-claude-lanes
tag=$1
for case in tiny hello; do
    case $case in
        tiny) set -- -c tiny.c -o /dev/null ;;
        hello) set -- -c hello.c -o /dev/null ;;
    esac
    for block in 1 2 3 4; do
        for build in base head; do
            perf stat -r 100 -e duration_time,user_time,system_time,task-clock,cycles:u,cycles:k,instructions:u,page-faults,context-switches,cpu-migrations -o $d/results/kstat-$build-$case-$block-$tag.txt $d/shifts-$build/compiler-0 "$@"
        done
    done
done
INNER
chmod +x $d/kstat-inner.sh
~/buster-fast-bench/exclusive.sh $d/kstat-inner.sh $tag > $d/results/kstat-$tag.log 2>&1
echo done > $d/results/kstat-$tag.done

#!/bin/sh
# #1444's exit helper: strace -f -c of one process, perf stat -r (task clock, switches, faults, user and kernel cycles)
# and a --time-stages report, per build (base, lanes, head) and input. One hold.
#   counts.sh TAG
. ~/buster-fast-bench/1444-claude-exit/env.sh
cd $d/inputs
tag=$1
cat > $d/counts-inner.sh <<'INNER'
#!/bin/sh
d=~/buster-fast-bench/1444-claude-exit
q=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
tag=$1
for build in base lanes head; do
    C=$d/shifts-$build/compiler-0
    for case in empty tiny two hello medium units sqlite; do
        case $case in
            empty) set -- -fsyntax-only empty.c; runs=200 ;;
            tiny) set -- -c tiny.c -o /dev/null; runs=200 ;;
            two) set -- -c two.c -o /dev/null; runs=200 ;;
            hello) set -- -c hello.c -o /dev/null; runs=200 ;;
            medium) set -- -c medium.c -o /dev/null; runs=100 ;;
            units) set -- -c a.c b.c c.c d.c; runs=100 ;;
            sqlite) set -- -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$q $q/sqlite3.c -o $d/sqlite.o; runs=10 ;;
        esac
        strace -f -c -o $d/results/strace-$build-$case-$tag.txt $C "$@"
        perf stat -r $runs -e task-clock,context-switches,cpu-migrations,page-faults,cycles:u,cycles:k,instructions:u -o $d/results/perf-$build-$case-$tag.txt $C "$@"
    done
done
INNER
chmod +x $d/counts-inner.sh
mkdir -p $d/results
~/buster-fast-bench/exclusive.sh $d/counts-inner.sh $tag > $d/results/counts-$tag.log 2>&1
echo done > $d/results/counts-$tag.done

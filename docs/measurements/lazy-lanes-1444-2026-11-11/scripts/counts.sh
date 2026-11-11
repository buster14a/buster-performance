#!/bin/sh
# #1444: the system calls (strace -f -c, threads created by clone3, futex calls) and perf stat's software counters
# (context switches, migrations, faults) and user cycles and instructions, of base's and head's placement-0
# executables, for each input; one hold of the 9700X's lock for all of it (about a minute).
#   counts.sh TAG
set -e
d=~/buster-fast-bench/1444-claude-lanes
cd $d/inputs
export EXCLUSIVE_OWNER=claude-1444-lanes EXCLUSIVE_TITLE="Start fewer lanes for a small compile (#1444)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1444
tag=$1
q=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
mkdir -p $d/results
cat > $d/counts-inner.sh <<'INNER'
#!/bin/sh
d=~/buster-fast-bench/1444-claude-lanes
q=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
tag=$1
for build in base head; do
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
        perf stat -r $runs -e task-clock,context-switches,cpu-migrations,page-faults,cycles:u,instructions:u -o $d/results/perf-$build-$case-$tag.txt $C "$@"
        $C --time-stages "$@" > /dev/null 2> $d/results/stages-$build-$case-$tag.txt || true
    done
done
INNER
chmod +x $d/counts-inner.sh
~/buster-fast-bench/exclusive.sh $d/counts-inner.sh $tag > $d/results/counts-$tag.log 2>&1
echo done > $d/results/counts-$tag.done

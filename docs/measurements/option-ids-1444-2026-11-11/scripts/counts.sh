#!/bin/sh
# #1444 item 5: perf stat's user instructions and cycles, task clock and page faults of base's and head's placement-0
# executables, for each input, pinned to CPU 2; one hold of the 9700X's lock for all of it.
#   counts.sh TAG
set -e
d=~/buster-fast-bench/1444-claude-options
cd $d/inputs
export EXCLUSIVE_OWNER=claude-1444-options EXCLUSIVE_TITLE="Table-driven option matching for compiles (#1444)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1444
tag=$1
mkdir -p $d/results
cat > $d/counts-inner.sh <<'INNER'
#!/bin/sh
d=~/buster-fast-bench/1444-claude-options
q=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
tag=$1
for round in 1 2; do
    for build in base head; do
        C=$d/shifts-$build/compiler-0
        for case in empty preprocess tiny hello native sqlite; do
            case $case in
                empty) set -- -fsyntax-only empty.c; runs=300 ;;
                preprocess) set -- -E -P empty.c -o /dev/null; runs=300 ;;
                tiny) set -- -c tiny.c -o /dev/null; runs=300 ;;
                hello) set -- -c hello.c -o /dev/null; runs=200 ;;
                native) set -- -fsyntax-only -march=native -fwrapv -funsigned-char empty.c; runs=300 ;;
                sqlite) set -- -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$q $q/sqlite3.c -o $d/sqlite.o; runs=10 ;;
            esac
            taskset -c 2 perf stat -r $runs -e task-clock,page-faults,cycles:u,instructions:u -o $d/results/perf-$build-$case-r$round-$tag.txt $C "$@"
        done
    done
done
INNER
chmod +x $d/counts-inner.sh
~/buster-fast-bench/exclusive.sh $d/counts-inner.sh $tag > $d/results/counts-$tag.log 2>&1
echo done > $d/results/counts-$tag.done

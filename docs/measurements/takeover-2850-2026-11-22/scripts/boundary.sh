#!/bin/bash
# boundary.sh TREE ROUNDS: the body boundary's readings on the frozen sqlite3.c, one lane on CPU 2, each run under the
# lock: a recording (untimed), then in turn --time-stages of the ordinary compile and of the compile with every eligible
# body supplied from the recording, and of the supplied compile with half of them (BUSTER_BOUNDARY_SELECT=2:0, 2:1).
# Every run's object is hashed: they must be one.
set -euo pipefail
dir="$HOME/buster-fast-bench/2850-claude-5a14"
tree=$1; rounds=$2
cc="$dir/trees/$tree/build/compiler"
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
out="$dir/results/boundary-$tree"
rm -rf "$out"; mkdir -p "$out/recording"
export EXCLUSIVE_OWNER=claude-2850-5a14 EXCLUSIVE_TITLE="#2850 redesign: the body boundary, bodies supplied from a recording" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
real="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sq $sq/sqlite3.c"
"$HOME/buster-fast-bench/exclusive.sh" bash -c "cd '$out' && BUSTER_BOUNDARY_RECORD='$out/recording' taskset -c 2 '$cc' --lanes 1 -c $real -o recorded.o > /dev/null 2> recorded.stderr; sha256sum recorded.o > recorded.sha" 2>> "$out/lock.log"
one()
{
    local name=$1 environment=$2
    "$HOME/buster-fast-bench/exclusive.sh" bash -c "
        cd '$out'
        $environment taskset -c 2 '$cc' --lanes 1 -c $real -o x.o > /dev/null 2>&1
        $environment taskset -c 2 '$cc' --lanes 1 -c $real -o x.o --time-stages 2> '$name.stages'
        sha256sum x.o | cut -d' ' -f1 > '$name.sha'
        rm -f x.o
    " 2>> "$out/lock.log"
}
for i in $(seq 1 "$rounds"); do
    one "whole-$i" ""
    one "supplied-$i" "BUSTER_BOUNDARY_SUPPLY=$out/recording"
    one "half0-$i" "BUSTER_BOUNDARY_SUPPLY=$out/recording BUSTER_BOUNDARY_SELECT=2:0"
    one "half1-$i" "BUSTER_BOUNDARY_SUPPLY=$out/recording BUSTER_BOUNDARY_SELECT=2:1"
    one "supplied-$i-b" "BUSTER_BOUNDARY_SUPPLY=$out/recording"
    one "whole-$i-b" ""
done
cat "$out"/*.sha | sort | uniq -c > "$out/objects.txt"
echo done > "$out/complete"

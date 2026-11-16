#!/bin/bash
# run2.sh: the faults that the first round (run.sh: the tests, and sqlite3.c and Lua with every warning) showed on
# nothing, again where that round did not look: sqlite3.c and Lua with the default warnings (with every warning a
# comparison is always sent to the census's code, which hides the faults of its other conditions), and musl with both.
# A line a fault in mutations2.txt.
set -u
dir=~/.cache/claude-2524o/faults
cd ~/.cache/claude-2524o/wt-faults
names=$(python3 $dir/knobs.py . list)
hidden=$(sed -n 's/^fault \([0-9]*\) (.*): tests 0 failures; sqlite3.c: status 0, 0 differ; Lua: status 0, 0 differ$/\1/p' $dir/mutations.txt)
for n in $hidden; do
    name=$(echo "$names" | sed -n "${n}p" | cut -f2)
    line="fault $n ($name):"
    for spec in "sqlite default" "lua default" "musl default" "musl wall"; do
        set -- $spec
        options=""; [ "$2" = wall ] && options="-Wall -Wextra"
        BUSTER_NODE_TESTS_FAULT=$n ~/.cache/claude-2524s/shapes-local.sh ./build/compiler $1 --front-own-tests --verify $options > $dir/second-$n.log 2>&1; status=$?
        differ=$(sed -n 's/.*compared-with-the-census.s-code differences=\([0-9]*\) .*/\1/p' $dir/second-$n.log)
        line="$line $1 $2: status $status, ${differ:-?} differ;"
    done
    echo "$line" >> $dir/mutations2.txt
    rm -f $dir/second-$n.log
done
echo "done" >> $dir/mutations2.txt

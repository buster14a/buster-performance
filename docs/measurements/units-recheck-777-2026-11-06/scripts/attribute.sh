#!/bin/bash
# Whose is main's one-lane slowdown against #763: each corpus's units by one command on one lane (-c) against the same
# units compiled one process each, one after another, at the tree and at #763, on CPU 2 (time-runs, rotated order).
# Where the tree's extra time is the same in both shapes, it is each unit's compile's, not the units' path's.
# Then --time-stages of each one command, at each tree.
# Usage: attribute.sh TREE BASE [lua|synth|musl]...
. $(dirname $0)/common.sh
TREE=${1:?tree}
BASE=${2:?base tree}
shift 2
H=$W/$TREE/build/compiler
B=$W/$BASE/build/compiler
OUT=$W/attribute-$TREE
mkdir -p $OUT
P="taskset -c 2"

shapes() {
    # $1 corpus name, $2 flags, $3 units, $4 runs
    local name=$1 flags=$2 units=$3 runs=$4 d=$OUT/$1
    rm -rf $d && mkdir -p $d/h1 $d/hn $d/b1 $d/bn && cd $d
    echo "== $name: $(echo $units | wc -w) units; lists 1 one command by $TREE, 2 processes by $TREE, 3 one command by $BASE, 4 processes by $BASE (-c, one lane, CPU 2)"
    local lists=()
    lists+=(--list -c "cd $d/h1 && rm -f *.o && $P $H --lanes 1 -c $flags $units")
    lists+=(--list -c "cd $d/hn && rm -f *.o && for u in $units; do $P $H -c $flags \$u || exit 1; done")
    lists+=(--list -c "cd $d/b1 && rm -f *.o && $P $B --lanes 1 -c $flags $units")
    lists+=(--list -c "cd $d/bn && rm -f *.o && for u in $units; do $P $B -c $flags \$u || exit 1; done")
    mkdir -p sh sb
    # Each unit's stages as a process of its own (a command of several units reports its units' run as one stage,
    # `lanes`), summed over the units, three times by each tree, in the same hold as the time-runs.
    cat > stages.sh <<EOS
for r in 1 2 3; do
    for u in $units; do (cd $d/sh && $P $H --time-stages -c $flags \$u 2>&1 | sed -n "s/^time-stage\t\([a-z0-9.-]*\)\t\([0-9.]*\).*/$TREE \$r \\1 \\2/p"); done
    for u in $units; do (cd $d/sb && $P $B --time-stages -c $flags \$u 2>&1 | sed -n "s/^time-stage\t\([a-z0-9.-]*\)\t\([0-9.]*\).*/$BASE \$r \\1 \\2/p"); done
done
EOS
    printf '%s\n' "$H time-runs --executable /bin/sh --runs $runs \"\$@\" > runs.log 2>&1" "echo time-runs status \$?" "bash stages.sh > stages.raw 2>&1" "echo stages status \$?" > hold.sh
    lock bash hold.sh "${lists[@]}"
    statuses runs.log; results < runs.log
    for x in h1 hn b1 bn; do echo "$x: $(ls $x/*.o 2> /dev/null | wc -l) objects"; done
    local differ=0; for o in h1/*.o; do cmp -s $o hn/$(basename $o) || differ=$((differ + 1)); done; echo "$TREE: one command's objects differing from its processes': $differ"
    differ=0; for o in b1/*.o; do cmp -s $o bn/$(basename $o) || differ=$((differ + 1)); done; echo "$BASE: one command's objects differing from its processes': $differ"
    echo "stages: each stage's ms summed over the units, by tree and repetition (stages.raw)"
    awk '{ sum[$1" "$3] += $4; rep[$1" "$3" "$2] += $4 } END { for (k in sum) print k, sum[k] / 3 }' stages.raw | sort -k2,2 -k1,1 | awk '{ printf "%s %s %.2f\n", $1, $2, $3 }' > stages.sum
    join -j 1 <(awk -v t=$TREE '$1 == t { print $2, $3 }' stages.sum | sort) <(awk -v t=$BASE '$1 == t { print $2, $3 }' stages.sum | sort) | awk '$2 + $3 > 0.5 { printf "  %-28s %10.2f %10.2f %+9.2f\n", $1, $2, $3, $2 - $3 }'
}

lua() {
    local src=$HOME/buster-fast-bench/units-152-claude/inputs/lua-5.4.8/src
    shapes lua "-std=gnu99 -U__ELF__ -DLUA_COMPAT_5_3 -DLUA_USE_LINUX" "$(cd $src && ls *.c | grep -v '^luac.c$' | sed "s|^|$src/|" | tr '\n' ' ')" ${RUNS_LUA:-11}
}
synth() {
    shapes synth "" "$(ls $HOME/buster-fast-bench/units-152-claude/explore/synth/unit_*.c | tr '\n' ' ')" ${RUNS_SYNTH:-5}
}
musl() {
    local m=$HOME/buster-fast-bench/refine-claude/inputs/musl
    shapes musl "-std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -I$m/arch/x86_64 -I$m/arch/generic -I$m/obj/src/internal -I$m/src/include -I$m/src/internal -I$m/obj/include -I$m/include" "$(tr '\n' ' ' < $W/scripts/musl-units-763.txt)" ${RUNS_MUSL:-5}
}
for corpus in "$@"; do $corpus; done
echo attribute-finished

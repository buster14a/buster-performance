#!/bin/bash
# The compiler's speed under each code-changing variant, after the queue named by $1 ends: each variant built clean in
# the prototype clone (its build time is a result too), its four placements linked, then compared with the baseline's
# placements by time-runs, every build and every comparison its own hold of the lock.
#   base              today's build (the `src` clone)
#   p48-i100          the prototype as queue-part.sh measured it: 48 content-defined parts, bodies of at most 100 imported
#   p48-i0            no imported bodies but always_inline's
#   p48-i300          bodies of at most 300 instructions imported
#   p16-i100          16 parts (the other units in proportion)
#   p48c-i100         48 balanced contiguous parts instead of content-defined ones
#   whole-optnone     today's structure with the three largest units' test functions optnone and noinline
#   p48-i100-optnone  the prototype with them so
d=$HOME/buster-fast-bench/2040-claude
cd "$d" || exit 2
echo $$ > queue-variants.pid
while kill -0 "$(cat "${1:-queue-part}.pid" 2>/dev/null)" 2>/dev/null; do sleep 5; done
mkdir -p placements
cat results/maps/main_unit_checker.tests.csv results/maps/main_unit_backend.tests.csv results/maps/main_unit_frontend.tests.csv | sort -u > scratch/all.tests.csv
shifts="main_unit_checker.c 0 1088 2112 3136"
lock() { scripts/lock.sh "$@"; }
RUN_SHIFTS="$d/placements/base $shifts" lock scripts/run.sh variants src shifts-base none - 1
variant()
{
    local name=$1 presplit=$2 flags=$3 clean=$4
    export BUSTER_PRESPLIT="$presplit" BUSTER_PRESPLIT_FLAGS="$flags"
    [ "$clean" = 0 ] || lock scripts/run.sh variants part "clean-$name" clean - 1
    RUN_SHIFTS="$d/placements/$name $shifts" lock scripts/run.sh variants part "shifts-$name" none - 1
    unset BUSTER_PRESPLIT BUSTER_PRESPLIT_FLAGS
    lock scripts/ab.sh "sqlite-$name" sqlite 5 2 "base=$d/placements/base" "$name=$d/placements/$name" "base-again=$d/placements/base"
}
optnone="-mllvm -forceattrs-csv-path=$d/scratch/all.tests.csv"
variant p48-i100 "48 24 100" "" 0
variant p48-i0 "48 24 0" "" 1
variant p48-i300 "48 24 300" "" 1
variant whole-optnone "" "$optnone" 1
for name in p48-i100 whole-optnone; do
    lock scripts/ab.sh "syntax-$name" syntax 3 0 "base=$d/placements/base" "$name=$d/placements/$name" "base-again=$d/placements/base"
done
variant p16-i100 "16 24 100" "" 1
variant p48c-i100 "48 0 100" "" 1
variant p48-i100-optnone "48 24 100" "$optnone" 1
echo done >> results/variants.txt

#!/bin/bash
# The scenarios of the prototype (the `part` clone: main c5f0efb2 with prototype/presplit.patch; every large unit split
# before LLVM's optimizer into content-defined parts, BUSTER_PRESPLIT="48 24 100"), each build its own hold of the lock,
# after the queue named by $1 ends. The same edits as the baseline's, at three levels of debug information, since a
# part's bitcode holds the line numbers and the source files' checksums of what it refers to:
#   part      -g as the build has it (DWARF 5, whose file entries carry each source file's MD5)
#   part-g4   -g -gdwarf-4 (no checksums): an edit that moves no line, and one that moves every line of its file
#   part-g0   no debug information (BUSTER_DEBUG_INFO=0, as CI builds)
d=$HOME/buster-fast-bench/2040-claude
cd "$d" || exit 2
echo $$ > queue-part.pid
while kill -0 "$(cat "${1:-queue-compile}.pid" 2>/dev/null)" 2>/dev/null; do sleep 5; done
one() { scripts/lock.sh scripts/run.sh "$@"; }
restore() { scripts/lock.sh bash -c "cd $d/part && git diff --stat -- src >> $d/logs/part-edits.diffstat && git checkout -q -- src"; }
edits()
{
    local set=$1 rep=$2
    one $set part backend append differential.c $rep
    one $set part codegen append tier0.c $rep
    one $set part frontend append c_parser_impl.c $rep
    one $set part test-private append c_checker_driver_test.c $rep
    one $set part test-shared append c_checker_test.c $rep
    one $set part header guarded host_isa.h $rep
}
export BUSTER_PRESPLIT="48 24 100"
for rep in 1 2 3; do one part part clean clean - $rep; done
one part part noop none - 1
for rep in 1 2; do
    one part part checker append c_check_input.c $rep
    edits part $rep
done
restore
export BUSTER_PRESPLIT="48 24 100 -gdwarf-4"
one part-g4 part switch none - 1
for rep in 1 2; do
    one part-g4 part checker append c_check_input.c $rep
    one part-g4 part test-private append c_checker_driver_test.c $rep
    one part-g4 part checker-top prepend c_check_input.c $rep
done
restore
export BUSTER_PRESPLIT="48 24 100" BUSTER_DEBUG_INFO=0
for rep in 1 2; do one part-g0 part clean clean - $rep; done
one part-g0 part noop none - 1
for rep in 1 2 3; do
    one part-g0 part checker append c_check_input.c $rep
    one part-g0 part checker-top prepend c_check_input.c $rep
    [ $rep = 3 ] || edits part-g0 $rep
done
restore
unset BUSTER_DEBUG_INFO
one part part restore none - 0
echo done >> results/part.txt

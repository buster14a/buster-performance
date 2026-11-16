#!/bin/bash
# Builds each #2891 mutant in its own copy of HEAD (git archive), Release without debug information, one after another.
S=/root/.cache/claude-2891
M=$S/mutants
L=src/buster/compiler/c_check_program_lower.c
N=src/buster/compiler/c_check_node_machine_contexts.c
mutate() {
    local name=$1 file=$2 old=$3 new=$4
    rm -rf "$M/$name"; mkdir -p "$M/$name"
    git -C /home/user/buster archive HEAD | tar x -C "$M/$name"
    python3 "$M/make.py" "$M/$name/$file" "$old" "$new" || { echo "$name: mutation failed" >> "$M/summary.txt"; return; }
    (cd "$M/$name" && BUSTER_DEBUG_INFO=0 nice -n 15 ./build.sh --config Release > build.log 2>&1); echo "$name build status $?" >> "$M/summary.txt"
    rm -rf "$M/$name/build/cmake/native/Release/CMakeFiles"
}
: > "$M/summary.txt"
# The value's first operand left a value (today's path): its join stays.
mutate value $L "        if (!reuse && check_lower_branch_condition(program, a))" "        if (!reuse && check_lower_branch_condition(program, a) && node == UINT32_MAX)"
# The first operand's branch with the wrong sense: an `||`'s taken where false.
mutate sense $L ".value = alternate, .address = op == CHECK_OP_LOGICAL_OR });" ".value = alternate, .address = op == CHECK_OP_LOGICAL_AND });"
# Only the values: a conditional's condition back to a value (#2883's tests).
mutate conditional $L "        if (!reuse && check_lower_branch_condition(program, a))" "        if (!conditional && !reuse && check_lower_branch_condition(program, a))"
# The node machine takes the value whose first operand is branches (#2883's rule alone).
mutate machine $N "    const bool shape = a < r && b < r && (!conditional || (c < r && a != b)) && !node_machine_branch_condition(machine, a);" "    const bool shape = a < r && b < r && (!conditional || (c < r && a != b && !node_machine_branch_condition(machine, a)));"
echo done >> "$M/summary.txt"

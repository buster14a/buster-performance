#!/bin/bash
# Builds each mutant in its own copy of HEAD (git archive), Release without debug information, one after another.
S=/tmp/claude-0/-home-user-buster/c45a68bf-d025-5d42-ba16-5bb54ca5630c/scratchpad
M=$S/mutants
L=src/buster/compiler/c_check_program_lower.c
P=src/buster/compiler/c_check_program_batch.c
mutate() {
    local name=$1 file=$2 old=$3 new=$4
    rm -rf "$M/$name"; mkdir -p "$M/$name"
    git -C /home/user/buster archive HEAD | tar x -C "$M/$name"
    python3 "$M/make.py" "$M/$name/$file" "$old" "$new" || { echo "$name: mutation failed" >> "$M/summary.txt"; return; }
    (cd "$M/$name" && BUSTER_DEBUG_INFO=0 nice -n 15 ./build.sh --config Release > build.log 2>&1); echo "$name build status $?" >> "$M/summary.txt"
    rm -rf "$M/$name/build/cmake/native/Release/CMakeFiles"
}
: > "$M/summary.txt"
mutate statement $L "    const bool taken = branch && check_lower_branch_condition(writer->program, node);" "    const bool taken = branch && check_lower_branch_condition(writer->program, node) && node == UINT32_MAX;"
mutate order $L "            check_lower_branch_operand(writer, node, 1, conversions[1].type, sense, target);
            check_lower_branch_operand(writer, node, 0, conversions[0].type, sense, target);" "            check_lower_branch_operand(writer, node, 0, conversions[0].type, sense, target);
            check_lower_branch_operand(writer, node, 1, conversions[1].type, sense, target);"
mutate past $L "check_lower_branch_operand(writer, node, 0, conversions[0].type, !sense, past);" "check_lower_branch_operand(writer, node, 0, conversions[0].type, sense, past);"
mutate not $L "op == CHECK_OP_NOT ? !sense : sense, target);" "op == CHECK_OP_NOT ? sense : sense, target);"
mutate conditional $L "if (conditional && !reuse && check_lower_branch_condition(program, a))" "if (conditional && !reuse && check_lower_branch_condition(program, a) && node == UINT32_MAX)"
mutate plain $P "        else if (op == CHECK_OP_CONDITION && check_lower_condition_branches(writer, node))" "        else if (op == CHECK_OP_CONDITION && node == UINT32_MAX && check_lower_condition_branches(writer, node))"
echo done >> "$M/summary.txt"

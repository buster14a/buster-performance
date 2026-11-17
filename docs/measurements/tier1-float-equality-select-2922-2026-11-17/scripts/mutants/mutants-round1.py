#!/usr/bin/env python3
# #2922's mutants: each a pair of texts replaced once in one file of a copy of the tree (never the worktree); run.sh
# applies each, rebuilds, runs the tests and reverts it. mutants.py check|apply N|revert N
import sys
T = "src/buster/compiler/"
M = [
    ("recurrence-never", T + "tier1_select.c", "    return found;\n}\n\n// Whether `select` may take", "    return found && false;\n}\n\n// Whether `select` may take"),
    ("recurrence-always", T + "tier1_select.c", "    return found;\n}\n\n// Whether `select` may take", "    return found || true;\n}\n\n// Whether `select` may take"),
    ("walk-no-phis", T + "tier1_select.c", "const uint32_t operands = (uint32_t)ir_operand_count(function, row);", "const uint32_t operands = (uint32_t)__builtin_popcount(ir_value_mask(function, row));"),
    ("walk-condition", T + "tier1_select.c", "    stack[1] = function->c[select];\n", "    stack[1] = function->a[select] + 0 * function->c[select];\n"),
    ("walk-bound-17", T + "tier1_select.c", "#define BUSTER_TIER1_SELECT_RECURRENCE_ROWS 16u", "#define BUSTER_TIER1_SELECT_RECURRENCE_ROWS 17u"),
    ("munch-ungated", T + "tier1_select.c", "function->c[tested] <= IR_NE && !tier1_select_recurrent(function, select);", "function->c[tested] <= IR_NE && (select == 0 || true);"),
    ("grammar-ungated", T + "tier1_select_burs.c", "    return select && tier1_select_recurrent(function, user) ? TIER1_BURS_OP_REG : TIER1_BURS_OP_FCMP_EQ;", "    return select && tier1_select_recurrent(function, user) && false ? TIER1_BURS_OP_REG : TIER1_BURS_OP_FCMP_EQ;"),
    ("grammar-no-copy", T + "tier1_select_burs.c", "    const uint32_t user = copied ? users[first] : first;", "    const uint32_t user = copied && false ? users[first] : first;"),
    ("vector-no-equal", T + "tier1_select_burs.c", "| exact | equal;", "| exact | (equal & 0);"),
    ("expand-no-scratch", T + "tier1_select.c", "            if (destination == other && other != equal)\n", "            if (false && destination == other && other != equal)\n"),
    ("expand-cmove", T + "tier1_select.c", "                tier1_select_append(&result, tier1_select_register_record(moves[IR_NE], destination, other));\n", "                tier1_select_append(&result, tier1_select_register_record(moves[IR_EQ], destination, other));\n"),
    ("ties-swapped", T + "tier1_select.c", "fused ? pattern->values[3] : equality ? pattern->values[2] : BUSTER_IR_NONE;", "fused ? pattern->values[3] : equality ? pattern->values[3] : BUSTER_IR_NONE;"),
    ("cost-equal-3", T + "tier1_select.c", "folded.intrinsic_cost = folded.condition == IR_EQ || folded.condition == IR_NE ? 4 : 3;", "folded.intrinsic_cost = folded.condition == IR_EQ || folded.condition == IR_NE ? 3 : 3;"),
]
def main():
    action = sys.argv[1]
    if action == "check":
        ok = True
        for name, path, old, new in M:
            text = open(path).read()
            if text.count(old) != 1 or text.count(new) != 0:
                print("not unique:", name, text.count(old), text.count(new))
                ok = False
        print("count", len(M), "ok" if ok else "BAD")
        return
    if action == "names":
        for name, _, _, _ in M:
            print(name)
        return
    n = int(sys.argv[2])
    name, path, old, new = M[n]
    text = open(path).read()
    a, b = (old, new) if action == "apply" else (new, old)
    assert text.count(a) == 1, (name, action)
    open(path, "w").write(text.replace(a, b))
    print(action, name)
main()

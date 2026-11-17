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
    ("walk-no-revisit", T + "tier1_select.c", "known = seen[k] == row && (seen_operated[k] || !through);", "known = seen[k] == row && (seen_operated[k] || !through || true);"),
    ("walk-copy-operation", T + "tier1_select.c", "const bool passed = through || (op != IR_PHI && op != IR_COPY);", "const bool passed = through || (op != IR_PHI && op != IR_PHI);"),
    ("walk-every-operation", T + "tier1_select.c", "const bool passed = through || (op != IR_PHI && op != IR_COPY);", "const bool passed = through || (op != IR_PHI || true) || op != IR_COPY;"),
    ("walk-through-select", T + "tier1_select.c", "                depth += value != select ? 1 : 0;\n", "                depth += value != select ? 1 : 1;\n"),
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

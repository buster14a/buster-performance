#!/usr/bin/env python3
# apply.py TREE MUTANT: one of #989's review's mutants applied to TREE's sources, an exact replacement that must match
# once.
import sys

MUTANTS = {
    # tier1_select_request's guard: a request on a full node writes its fields.
    "request": ("src/buster/compiler/tier1_select.c",
                "if (row != BUSTER_X86_CHOICE_NO_ROW && result->count < BUSTER_TIER1_SELECT_RECORDS_PER_NODE)",
                "if (row != BUSTER_X86_CHOICE_NO_ROW)"),
    # The selector's emitter takes an overflowed node.
    "emit": ("src/buster/compiler/tier1_select.c",
             "                if (selected.overflowed)\n                {\n                    error = TIER1_SELECT_ERROR_INVALID;",
             "                if (selected.overflowed && count == 0)\n                {\n                    error = TIER1_SELECT_ERROR_INVALID;"),
    # The straight-line consumer takes an overflowed node.
    "straight": ("src/buster/compiler/tier1_emit.c",
                 "if (selected.overflowed || (returns && (selected.count == 0 || selected.records[selected.count - 1].form != X86_FORM_RET)))",
                 "if (returns && (selected.count == 0 || selected.records[selected.count - 1].form != X86_FORM_RET))"),
    # The CFG consumer's conditional branch takes an overflowed node.
    "branch": ("src/buster/compiler/tier1_emit_cfg.c",
               "error = !selected_records.overflowed && selected_records.count >= 2 &&",
               "error = selected_records.count >= 2 &&"),
    # The CFG consumer's other nodes take an overflowed node.
    "cfg": ("src/buster/compiler/tier1_emit_cfg.c",
            "error = selected_records.overflowed ? TIER1_EMIT_INVALID : error;",
            "error = selected_records.overflowed ? error : error;"),
    # An immediate's fit off by one at the sign boundary: a 64-bit add of 2^31 as an imm32, which no form encodes.
    "fit": ("src/buster/compiler/tier1_select.c",
            "        if (have_constant && tier1_select_immediate_fits(width, immediate))\n        {\n            Tier1SelectPattern folded = base;\n            folded.rule = TIER1_RULE_IMMEDIATE;",
            "        if (have_constant && (tier1_select_immediate_fits(width, immediate) || immediate == UINT64_C(0x80000000)))\n        {\n            Tier1SelectPattern folded = base;\n            folded.rule = TIER1_RULE_IMMEDIATE;"),
}

tree, name = sys.argv[1], sys.argv[2]
path, old, new = MUTANTS[name]
full = tree + "/" + path
with open(full) as f:
    text = f.read()
count = text.count(old)
if count != 1:
    sys.exit(f"{name}: {count} matches in {path}")
with open(full, "w") as f:
    f.write(text.replace(old, new))
print(f"{name}: applied to {path}")

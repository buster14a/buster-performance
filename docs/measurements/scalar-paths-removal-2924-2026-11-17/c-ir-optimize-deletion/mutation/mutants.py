# Mutants of the verified optimizer's kept scalar passes (#2924 C9g), on the deletion's tree. (name, file, old, new);
# old occurs once. Round 2 rebuilt l2 and s2, which failed to build in round 1 (unused variables), as noted below.
MUTANTS = [
    ("t1-cycle-start", "ir_optimize.c", "                for (uint32_t i = next_minimum[node]; i < length; i += 1)\n", "                for (uint32_t i = next_minimum[node] + 1; i < length; i += 1)\n"),
    ("t2-cycle-min", "ir_optimize.c", "                    if (next[i] < representative)\n", "                    if (next[i] > representative)\n"),
    ("t3-path-last", "ir_optimize.c", "            for (uint32_t i = 0; i < length; i += 1)\n            {\n                current[next[i]] = representative;", "            for (uint32_t i = 0; i + 1 < length; i += 1)\n            {\n                current[next[i]] = representative;"),
    ("l1-rank-back", "ir_optimize_layout.c", "? 3 + adjacent + 2 * back : 0;", "? 3 + adjacent + back : 0;"),
    # Round 1: "? 3 + 2 * back : 0;" (unused variable); round 2:
    ("l2-rank-adjacent", "ir_optimize_layout.c", "? 3 + adjacent + 2 * back : 0;", "? 3 + (adjacent & 0) + 2 * back : 0;"),
    ("i1-identity-last", "ir_optimize.c", "    for (uint32_t lane = 0; lane < count; lane += 1)\n    {\n        candidates |= (uint64_t)(ir_optimize_identity_kinds", "    for (uint32_t lane = 0; lane + 1 < count; lane += 1)\n    {\n        candidates |= (uint64_t)(ir_optimize_identity_kinds"),
    ("f1-fold-last", "ir_optimize.c", "        for (uint32_t i = 0; i < batch.count; i += 1)\n        {\n            if ((active & (UINT32_C(1) << i)) != 0 && ir_optimize_fold_one(", "        for (uint32_t i = 0; i + 1 < batch.count; i += 1)\n        {\n            if ((active & (UINT32_C(1) << i)) != 0 && ir_optimize_fold_one("),
    ("f2-fold-active", "ir_optimize.c", "            if ((active & (UINT32_C(1) << i)) != 0 && ir_optimize_fold_one(", "            if (ir_optimize_fold_one("),
    ("d1-dce-seed", "ir_optimize.c", "        if (work->live[i] != 0)\n        {\n            ir_optimize_enqueue(work, i);", "        if (work->live[i] != 0 && i != 0)\n        {\n            ir_optimize_enqueue(work, i);"),
    ("s1-float-lanes", "ir_optimize_simd.c", "    for (uint32_t lane = 0; result && lane < bits / width; lane += 1)", "    for (uint32_t lane = 0; result && lane + 1 < bits / width; lane += 1)"),
    # Round 1: "result = predicate <= IR_GE;" (unused variables); round 2:
    ("s2-float-compare", "ir_optimize_simd.c", "            result = (a_nan || b_nan || !subnormal) && predicate <= IR_GE;", "            result = (a_nan || b_nan || !subnormal || true) && predicate <= IR_GE;"),
]

M = [
 ("s00", "static void ir_sroa_uses(IrSroaWork* work)", "static void ir_sroa_uses(IrSroaWork* work)"),
 ("s01", "if (work->ir.dominators.rpo_index[work->ir.cfg.instruction_blocks[i]] != BUSTER_DOMINATOR_NONE)\n                {\n                    const uint32_t lane", "if (true)\n                {\n                    const uint32_t lane"),
 ("s02", "batch.forwarded[lane] = work->roots[i] == root;", "batch.forwarded[lane] = work->roots[i] != BUSTER_IR_NONE;"),
 ("s03", "    ir_sroa_flush_uses(work, &batch);\n}", "    batch.count = 0;\n    ir_sroa_flush_uses(work, &batch);\n}"),
 ("s04", "            work->refused[batch->root[lane]] = 1;", "            work->refused[batch->root[lane]] = lane == 15;"),
 ("s05", "            work->returned[batch->root[lane]] = 1;", "            work->returned[batch->root[lane]] = lane == 15;"),
 ("s06", "batch.position[lane] = use.operand;", "batch.position[lane] = 0;"),
 ("s07", "    for (uint32_t lane = 0; lane < batch->count; lane += 1)\n    {\n        if ((escaped", "    for (uint32_t lane = 0; lane + 1 < batch->count; lane += 1)\n    {\n        if ((escaped"),
]

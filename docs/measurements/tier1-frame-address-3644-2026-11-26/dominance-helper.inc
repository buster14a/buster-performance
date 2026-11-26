// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
static bool tier1_terminal_dominance(Tier1EmitTest* test, const IrFunction* function, IrDominance* dominance)
{
    IrCfg cfg;
    bool ready = ir_build_cfg(function, &test->output, &test->scratch, &cfg) == IR_OK;
    if (ready)
    {
        const DominatorCfg graph = {
            .block_count = cfg.block_count,
            .edge_count = cfg.edge_count,
            .entry = 0,
            .successor_offsets = cfg.successor_offsets,
            .successors = cfg.successors,
            .predecessor_offsets = cfg.predecessor_offsets,
            .predecessors = cfg.predecessors,
        };
        DominatorOptions options = dominators_options();
        options.outputs = 0;
        Dominators result;
        ready = dominators_analyze(&test->output, &test->scratch, &graph, options, &result) == DOMINATOR_OK;
        if (ready)
        {
            *dominance = (IrDominance){
                .enter = result.preorder,
                .leave = result.subtree_end,
                .block_count = result.block_count,
            };
        }
    }
    return ready;
}

// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See the buster repository's LICENSE and LICENSING.md.
//
// Temporary #2553 resolver fixtures. Include after tier1_cfg_test.c. Expectations are named graph shapes, not a
// second implementation of the bounded resolver. Guard cases place the final CSR successor row at a protected page.

static void tier1_cfg_test_latch_models(Tier1CfgTestTally* tally, Arena* output, Arena* scratch)
{
    static const struct
    {
        const char* name;
        uint32_t expected;
        uint32_t modeled_blocks;
    } cases[] = {
        { "a direct multiway branch models its earliest handler", 1, 0x0030 },
        { "one forward step reaches the multiway branch", 1, 0x0070 },
        { "a latch default edge before the forward edge is allowed", 1, 0x0070 },
        { "a latch default edge after the forward edge is allowed", 1, 0x0070 },
        { "two distinct forward branches have no single convention", BUSTER_TIER1_CFG_NONE, 0 },
        { "a no-phi unconditional backward trampoline returns to the latch", 1, 0x0078 },
        { "a guard self-edge is not a return to the latch", BUSTER_TIER1_CFG_NONE, 0 },
        { "a return to the latch without forward progress stops", BUSTER_TIER1_CFG_NONE, 0 },
        { "a dead end has no dispatcher model", BUSTER_TIER1_CFG_NONE, 0 },
        { "a later step that returns to a non-latch block stops", BUSTER_TIER1_CFG_NONE, 0 },
        { "a multiway branch without an earlier handler is refused", BUSTER_TIER1_CFG_NONE, 0 },
        { "the latch itself is not an earlier handler", BUSTER_TIER1_CFG_NONE, 0 },
        { "a join with fewer than three predecessors is ineligible", BUSTER_TIER1_CFG_NONE, 0 },
        { "a latch with no successor is ineligible", BUSTER_TIER1_CFG_NONE, 0 },
        { "a latch with two successors is ineligible", BUSTER_TIER1_CFG_NONE, 0 },
        { "a latch whose successor is earlier is ineligible", BUSTER_TIER1_CFG_NONE, 0 },
        { "a latch whose successor is itself is ineligible", BUSTER_TIER1_CFG_NONE, 0 },
        { "a dispatcher at the eighth inspected block is reached", 1, 0x1ff0 },
        { "a dispatcher beyond the eighth inspected block is not reached", BUSTER_TIER1_CFG_NONE, 0 },
        { "a single backward edge to a handler is not a dispatcher", BUSTER_TIER1_CFG_NONE, 0 },
        { "a backward block with two successors is not a trampoline", BUSTER_TIER1_CFG_NONE, 0 },
        { "a backward block that defines a phi is not a trampoline", BUSTER_TIER1_CFG_NONE, 0 },
        { "a backward block whose one successor is not the latch is refused", BUSTER_TIER1_CFG_NONE, 0 },
        { "a backward block with no successors is refused", BUSTER_TIER1_CFG_NONE, 0 },
        { "successive forward guards may each return to the latch", 1, 0x00f0 },
        { "the backward trampoline also works in the second successor lane", 1, 0x0078 },
    };
    for (uint32_t variant = 0; variant < BUSTER_ARRAY_LENGTH(cases); variant += 1)
    {
        const uint64_t saved = output->length;
        Tier1CfgTestBuilder builder = { 0 };
        builder.block_count = 16;
        for (uint32_t b = 0; b < builder.block_count; b += 1)
        {
            builder.instructions[b] = 1;
        }
        const uint32_t latch = 4;
        const uint32_t header = 5;
        tier1_cfg_test_edge(&builder, 0, header);
        tier1_cfg_test_edge(&builder, 1, latch);
        tier1_cfg_test_edge(&builder, 2, latch);
        if (variant != 12 && variant != 22 && variant != 23)
        {
            tier1_cfg_test_edge(&builder, 3, latch);
        }
        if (variant == 22 || variant == 23)
        {
            // Keep the latch eligible while the backward target's own successor is absent or leads elsewhere.
            tier1_cfg_test_edge(&builder, 8, latch);
        }
        if (variant != 13)
        {
            tier1_cfg_test_edge(&builder, latch, variant == 15 ? 3 : variant == 16 ? latch : header);
        }
        if (variant == 14)
        {
            tier1_cfg_test_edge(&builder, latch, 6);
        }
        uint32_t dispatch = header;
        if ((variant >= 1 && variant <= 6) || variant >= 20)
        {
            dispatch = 6;
            if (variant == 2 || variant == 5 || variant == 6 || (variant >= 20 && variant != 25))
            {
                tier1_cfg_test_edge(&builder, header, variant == 2 || variant == 24 ? latch : variant == 5 || variant >= 20 ? 3 : header);
            }
            tier1_cfg_test_edge(&builder, header, dispatch);
            if (variant == 25)
            {
                tier1_cfg_test_edge(&builder, header, 3);
            }
            if (variant == 3 || variant == 4)
            {
                tier1_cfg_test_edge(&builder, header, variant == 3 ? latch : 7);
            }
            if (variant == 4)
            {
                // Both alternatives would reach a valid model. Picking either would conceal an ambiguous branch.
                tier1_cfg_test_edge(&builder, 7, 3);
                tier1_cfg_test_edge(&builder, 7, 1);
                tier1_cfg_test_edge(&builder, 7, 2);
            }
            if (variant == 5)
            {
                // Position width is not an instruction-emptiness contract; the resolver only requires no phis.
                builder.instructions[3] = 4;
            }
            if (variant == 20 || variant == 22)
            {
                tier1_cfg_test_edge(&builder, 3, 2);
            }
            if (variant == 24)
            {
                tier1_cfg_test_edge(&builder, 6, latch);
                tier1_cfg_test_edge(&builder, 6, 7);
                dispatch = 7;
            }
        }
        else if (variant == 7 || variant == 19)
        {
            tier1_cfg_test_edge(&builder, header, variant == 7 ? latch : 1);
            dispatch = BUSTER_TIER1_CFG_NONE;
        }
        else if (variant == 8)
        {
            dispatch = BUSTER_TIER1_CFG_NONE;
        }
        else if (variant == 9)
        {
            tier1_cfg_test_edge(&builder, header, 6);
            tier1_cfg_test_edge(&builder, 6, header);
            dispatch = BUSTER_TIER1_CFG_NONE;
        }
        else if (variant == 17 || variant == 18)
        {
            const uint32_t links = variant == 17 ? 7 : 8;
            for (uint32_t link = 0; link < links; link += 1)
            {
                tier1_cfg_test_edge(&builder, header + link, header + link + 1);
            }
            dispatch = header + links;
        }
        if (dispatch != BUSTER_TIER1_CFG_NONE)
        {
            // Deliberately unsorted handler targets: firsts is the graph's earliest successor, not its first CSR entry.
            tier1_cfg_test_edge(&builder, dispatch, variant == 10 ? 8 : variant == 11 ? 7 : 3);
            tier1_cfg_test_edge(&builder, dispatch, variant == 10 ? 6 : variant == 11 ? latch : 1);
            tier1_cfg_test_edge(&builder, dispatch, variant == 10 ? 7 : variant == 11 ? 6 : 2);
        }
        if (variant == 21)
        {
            const uint32_t operands[2] = { BUSTER_TIER1_CFG_NONE, BUSTER_TIER1_CFG_NONE };
            tier1_cfg_test_phi(&builder, 3, BUSTER_TIER1_ALLOCATE_GPR, operands);
        }
        Tier1CfgInput input = { 0 };
        const bool built = tier1_cfg_test_build(&builder, output, &input) && tier1_cfg_input_valid(&input, scratch);
        tier1_cfg_test_expect(tally, built, "latch-model named fixture has a valid CFG");
        if (built)
        {
            uint32_t firsts[16];
            for (uint32_t b = 0; b < input.block_count; b += 1)
            {
                firsts[b] = tier1_cfg_test_first_successor(&input, b);
            }
            const uint32_t model = tier1_cfg_latch_model(&input, firsts, latch, NULL);
            if (model != cases[variant].expected)
            {
                printf("latch-model case %u: got=%u expected=%u\n", variant, model, cases[variant].expected);
            }
            tier1_cfg_test_expect(tally, model == cases[variant].expected, cases[variant].name);
            uint32_t models[16];
            for (uint32_t b = 0; b < input.block_count; b += 1)
            {
                // Earlier latch discoveries may already have published another convention in this shared column.
                models[b] = 7;
            }
            const uint32_t published = tier1_cfg_latch_model(&input, firsts, latch, models);
            bool propagated = published == model;
            for (uint32_t b = 0; b < input.block_count; b += 1)
            {
                const uint32_t expected = ((cases[variant].modeled_blocks >> b) & 1) != 0 ? cases[variant].expected : 7;
                propagated = propagated && models[b] == expected;
            }
            tier1_cfg_test_expect(tally, propagated, "only a complete valid path publishes its model to the latch, forward route and trampoline");
        }
        arena_pop_to(output, saved);
    }
    for (uint32_t count = 0; count <= 2; count += 1)
    {
        const uint64_t saved = output->length;
        Tier1CfgTestBuilder builder = { 0 };
        builder.block_count = 6;
        for (uint32_t b = 0; b < builder.block_count; b += 1)
        {
            builder.instructions[b] = 1;
        }
        tier1_cfg_test_edge(&builder, 0, 5);
        tier1_cfg_test_edge(&builder, 1, 4);
        tier1_cfg_test_edge(&builder, 2, 4);
        tier1_cfg_test_edge(&builder, 3, 4);
        tier1_cfg_test_edge(&builder, 4, 5);
        if (count >= 1)
        {
            tier1_cfg_test_edge(&builder, 5, 4);
        }
        if (count == 2)
        {
            tier1_cfg_test_edge(&builder, 5, 3);
        }
        Tier1CfgInput input = { 0 };
        const bool built = tier1_cfg_test_build(&builder, output, &input) && tier1_cfg_input_valid(&input, scratch);
        tier1_cfg_test_expect(tally, built, "guarded latch-model fixture has a valid CFG");
        if (built)
        {
            uint32_t firsts[6];
            for (uint32_t b = 0; b < input.block_count; b += 1)
            {
                firsts[b] = tier1_cfg_test_first_successor(&input, b);
            }
            DominatorTestGuard guard = dominator_test_guard(input.successors, (uint64_t)input.edge_count * sizeof(uint32_t));
            tier1_cfg_test_expect(tally, guard.mapping != NULL, "latch-model successor CSR ends at a protected page");
            if (guard.mapping != NULL)
            {
                input.successors = guard.data;
                // Block 5 is the last CSR row. With count zero its row pointer is inaccessible; with one or two
                // successors the mask must suppress every read after precisely those entries.
                tier1_cfg_test_expect(tally, tier1_cfg_latch_model(&input, firsts, 4, NULL) == BUSTER_TIER1_CFG_NONE,
                                      "latch-model zero/one/two successor row stays within its guarded bound");
                munmap(guard.mapping, guard.mapping_bytes);
            }
        }
        arena_pop_to(output, saved);
    }
}

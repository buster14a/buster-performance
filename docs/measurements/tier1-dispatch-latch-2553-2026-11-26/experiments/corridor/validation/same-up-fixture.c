// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
static void tier1_cfg_test_same_up_latch(Tier1CfgTestTally* tally, Arena* output, Arena* scratch, bool cold_first, bool majority)
{
    static Tier1CfgTestBuilder builder;
    memset(&builder, 0, sizeof(builder));
    builder.block_count = 8;
    for (uint32_t b = 0; b < builder.block_count; b += 1)
    {
        builder.instructions[b] = 4;
    }
    builder.registers[BUSTER_TIER1_ALLOCATE_GPR] = 7;
    builder.scratch[BUSTER_TIER1_ALLOCATE_GPR] = 11;
    tier1_cfg_test_edge(&builder, 0, 6);
    if (cold_first)
    {
        tier1_cfg_test_edge(&builder, 4, 5);
    }
    tier1_cfg_test_edge(&builder, 1, 5);
    tier1_cfg_test_edge(&builder, 2, 5);
    tier1_cfg_test_edge(&builder, 3, 5);
    tier1_cfg_test_edge(&builder, 3, 4);
    if (!cold_first)
    {
        tier1_cfg_test_edge(&builder, 4, 5);
    }
    tier1_cfg_test_edge(&builder, 5, 6);
    tier1_cfg_test_edge(&builder, 6, 1);
    tier1_cfg_test_edge(&builder, 6, 2);
    tier1_cfg_test_edge(&builder, 6, 3);
    tier1_cfg_test_edge(&builder, 6, 7);
    const uint32_t all = builder.registers[BUSTER_TIER1_ALLOCATE_GPR];
    const uint32_t start = tier1_cfg_test_value(&builder, 0, 0, BUSTER_TIER1_ALLOCATE_GPR, 1);
    const uint32_t carried = builder.value_count + 3;
    // A phi keeps the cold path's range separate: an exit hint names an interval's closing register, which must be
    // the hot predecessor's here, not the closing after a merged continuation has moved it in the cold block.
    const uint32_t cold_operands[] = {
        carried,
    };
    const uint32_t held = tier1_cfg_test_phi(&builder, 4, BUSTER_TIER1_ALLOCATE_GPR, cold_operands);
    builder.allowed[held] = 1;
    const uint32_t recipe = tier1_cfg_test_value(&builder, 4, 2, BUSTER_TIER1_ALLOCATE_GPR, all);
    builder.remat[recipe] = 1;
    uint32_t latch_operands[4] = { 0 };
    const uint32_t first_hot = cold_first ? 1 : 0;
    latch_operands[cold_first ? 0 : 3] = carried;
    for (uint32_t j = 0; j < 3; j += 1)
    {
        latch_operands[first_hot + j] = majority || j != 2 ? carried : BUSTER_TIER1_CFG_NONE;
    }
    const uint32_t joined = tier1_cfg_test_phi(&builder, 5, BUSTER_TIER1_ALLOCATE_GPR, latch_operands);
    const uint32_t header_operands[] = {
        start,
        joined,
    };
    const bool numbered = tier1_cfg_test_phi(&builder, 6, BUSTER_TIER1_ALLOCATE_GPR, header_operands) == carried;
    tier1_cfg_test_definition_use(&builder, start);
    tier1_cfg_test_definition_use(&builder, held);
    tier1_cfg_test_definition_use(&builder, recipe);
    for (uint32_t b = 1; b <= 3; b += 1)
    {
        tier1_cfg_test_use(&builder, carried, b, 0, true);
    }
    tier1_cfg_test_use(&builder, carried, 4, 1, true);
    tier1_cfg_test_use(&builder, carried, 4, 3, true);
    tier1_cfg_test_use(&builder, held, 4, 3, true);
    tier1_cfg_test_use(&builder, carried, 6, 0, true);
    tier1_cfg_test_use(&builder, carried, 7, 0, true);
    const uint64_t saved = output->length;
    Tier1CfgInput input = { 0 };
    const bool built = numbered && tier1_cfg_test_build(&builder, output, &input);
    tier1_cfg_test_expect(tally, built, "dispatch-latch fixture builds");
    if (built)
    {
        const uint64_t mark = output->length;
        Tier1CfgAllocation result = { 0 };
        const Tier1CfgError error = tier1_cfg_allocate(&input, output, scratch, &result);
        Tier1CfgCheck check;
        const bool allocated = error == TIER1_CFG_OK && tier1_cfg_verify(&input, &result, scratch, &check);
        tier1_cfg_test_expect(tally, allocated, "the independent checker accepts the dispatch-latch fixture");
        uint32_t locations[4] = { 0 };
        uint8_t kinds[4] = { 0 };
        const bool found = allocated && tier1_cfg_location(&result, carried, input.block_starts[1], &locations[0], &kinds[0]) &&
                           tier1_cfg_location(&result, carried, input.block_starts[4] + 2, &locations[1], &kinds[1]) &&
                           tier1_cfg_location(&result, joined, input.block_starts[5], &locations[2], &kinds[2]) &&
                           tier1_cfg_location(&result, recipe, input.definitions[recipe], &locations[3], &kinds[3]);
        const bool registers = found && kinds[0] == BUSTER_TIER1_ALLOCATE_REGISTER && kinds[1] == BUSTER_TIER1_ALLOCATE_REGISTER && kinds[2] == BUSTER_TIER1_ALLOCATE_REGISTER && kinds[3] == BUSTER_TIER1_ALLOCATE_REGISTER;
        tier1_cfg_test_expect(tally, registers && locations[0] != locations[1], "the cold path moves the loop value, so the settled-place alternate cannot choose its convention");
        tier1_cfg_test_expect(tally, registers && locations[0] != locations[3], "the cold recipe and the handlers use different registers");
        tier1_cfg_test_expect(tally, registers && locations[2] == locations[majority ? 0 : 3], majority ? "a latch keeps the loop value's convention on its repeated unchanged inputs" : "without a strict majority the latch keeps the ordinary predecessor's convention");
        uint32_t moved = 0;
        for (uint32_t b = 1; allocated && b <= 3; b += 1)
        {
            moved += tier1_cfg_test_edge_moves(&input, &result, b, 5);
        }
        moved += allocated ? tier1_cfg_test_edge_moves(&input, &result, 5, 6) : 0;
        tier1_cfg_test_expect(tally, allocated && (majority ? moved == 0 : moved != 0), majority ? "the dispatch loop's unchanged handler and latch edges move nothing" : "undefined operands do not turn a tied convention into a majority");
        arena_pop_to(output, mark);
        tier1_cfg_test_case(tally, &input, output, scratch, "dispatch latch", true, 0, 0, true);
    }
    arena_pop_to(output, saved);
}


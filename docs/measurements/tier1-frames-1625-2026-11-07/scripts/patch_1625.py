#!/usr/bin/env python3
# #1625's measurement patch, never committed: with BUSTER_MEASURE_1625 set, each function Tier 1 compiles prints a line
# to stderr of its frame (tier1_frame.c's maximum_stack_bytes, object, payload and outgoing bytes), its spill slots, its
# general call-save rows (the CFG consumer's call_save_mask after tier1_emit_cfg_saves) and their lower bound shared
# among themselves (the most general registers any one call or fixed-register sequence saves, by the same covering
# rule as tier1_emit_fragment_saved), its mask and vector rows, its callee-saved pushes, and its calls.
import sys
root = sys.argv[1]

def edit(path, old, new):
    p = root + '/' + path
    s = open(p).read()
    if s.count(old) != 1:
        sys.exit('patch_1625: %s: %d matches' % (path, s.count(old)))
    open(p, 'w').write(s.replace(old, new))

edit('src/buster/compiler/tier1_emit.c', '''    uint32_t callee_used;
    uint32_t crossing_values;''', '''    uint32_t callee_used;
    uint32_t crossing_values;
    uint32_t measure_call_bound;''')

edit('src/buster/compiler/tier1_emit_cfg.c', '''    emitted->prepared.call_save_mask = general_saved & columns;
    emitted->prepared.mask_save_mask = saved & BUSTER_TIER1_EMIT_MASK_REGISTERS;''', '''    emitted->prepared.call_save_mask = general_saved & columns;
    uint32_t measure_bound = 0;
    const uint32_t measure_total = saves.call_count > saves.offsets[BUSTER_TIER1_EMIT_GENERAL_REGISTERS] ? saves.call_count : saves.offsets[BUSTER_TIER1_EMIT_GENERAL_REGISTERS];
    for (uint32_t c = 0; ok && saves.positions != 0 && c < measure_total; c += 1)
    {
        const uint32_t p = saves.positions[c];
        // A call's position saves any column; a fixed-register sequence's only its register.
        uint32_t candidates = c < saves.call_count ? columns : 0;
        for (uint32_t r = 0; c >= saves.call_count && r < BUSTER_TIER1_EMIT_GENERAL_REGISTERS; r += 1)
        {
            candidates |= saves.offsets[r] <= c && c < saves.offsets[r + 1] ? 1u << r : 0;
        }
        uint32_t at = 0;
        for (uint32_t i = 0; i < cfg->intervals.count; i += 1)
        {
            const uint32_t own = emitted->cfg_input.definitions[cfg->intervals.values[i]];
            for (uint32_t f = allocation->fragment_offsets[i]; cfg->intervals.classes[i] == BUSTER_TIER1_ALLOCATE_GPR && f < allocation->fragment_offsets[i + 1]; f += 1)
            {
                const uint32_t reg = allocation->registers[f];
                const bool caller = allocation->kinds[f] == BUSTER_TIER1_ALLOCATE_REGISTER && reg < BUSTER_TIER1_EMIT_GENERAL_REGISTERS && ((columns >> reg) & 1) != 0 &&
                                    ((emitted->callee_registers >> reg) & 1) == 0;
                at |= caller && allocation->starts[f] <= p && p < allocation->ends[f] && p != own ? 1u << reg : 0;
            }
        }
        const uint32_t n = (uint32_t)__builtin_popcount(at & candidates & general_saved & columns);
        measure_bound = n > measure_bound ? n : measure_bound;
    }
    emitted->measure_call_bound = measure_bound;
    emitted->prepared.mask_save_mask = saved & BUSTER_TIER1_EMIT_MASK_REGISTERS;''')

edit('src/buster/compiler/c_check_tier1.c', '''        if (emitted.frame_event_count != 0)
        {
            memcpy(frames, emitted.frame_events, (uint64_t)emitted.frame_event_count * sizeof(EmissionFrameEvent));
        }''', '''        if (getenv("BUSTER_MEASURE_1625") != NULL)
        {
            fprintf(stderr, "measure-1625\\tframe=%u\\tobjects=%u\\tpayload=%u\\toutgoing=%u\\tspills=%u\\tcall_rows=%u\\tbound=%u\\tmask_rows=%u\\tvector_rows=%u\\tpushed=%u\\tcalls=%u\\n",
                    emitted.frame.maximum_stack_bytes, emitted.frame.object_bytes, emitted.frame.payload_bytes, emitted.frame.outgoing_bytes, emitted.allocation.spill_count,
                    (unsigned)__builtin_popcount(emitted.prepared.call_save_mask), emitted.measure_call_bound, (unsigned)__builtin_popcount(emitted.prepared.mask_save_mask),
                    (unsigned)__builtin_popcount(emitted.prepared.vector_save_mask), (unsigned)__builtin_popcount(emitted.frame.saved_registers), emitted.prepared.call_count);
        }
        if (emitted.frame_event_count != 0)
        {
            memcpy(frames, emitted.frame_events, (uint64_t)emitted.frame_event_count * sizeof(EmissionFrameEvent));
        }''')
print('patch_1625: applied')

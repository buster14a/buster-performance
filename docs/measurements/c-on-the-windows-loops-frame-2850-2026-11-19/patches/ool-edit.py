#!/usr/bin/env python3
# ool-edit.py TREE: an experiment on top of views-edit.py's: the loop's scalar parts (the strides, the rule on the
# conversions, a type's space, the far lanes' loads and the range under a record that isn't evaluated) each in a
# function of its own that keeps every register, called under one test of its mask: no loop inside the step.
import sys
p = sys.argv[1] + '/src/buster/compiler/c_check_node_machine_window.c'
t = open(p).read()
def rep(old, new, count=1):
    global t
    assert t.count(old) == count, (t.count(old), old[:90])
    t = t.replace(old, new)
rep("""static __attribute__((noinline, aligned(64))) void node_contexts_window_loop(""", """// EXPERIMENT (the loop's scalar parts out of line, each keeping every register).
static __attribute__((noinline, preserve_all)) uint64_t node_contexts_x_strides(const struct NodeFactsReader* state, uint32_t x, uint64_t pointed, uint64_t* asked)
{
    uint64_t kept = pointed;
    for (uint64_t pending = pointed; pending != 0; pending &= pending - 1)
    {
        const uint32_t lane = (uint32_t)_tzcnt_u64(pending);
        kept &= ~((uint64_t)(node_contexts_stride(state, x + lane, asked) ? 0 : 1) << lane);
    }
    return kept;
}

static __attribute__((noinline, cold, preserve_all)) uint64_t node_contexts_x_converted(const struct NodeFactsReader* state, uint32_t x, uint64_t lanes)
{
    uint64_t asked_binary = 0;
    for (uint64_t pending = lanes; pending != 0; pending &= pending - 1)
    {
        const uint32_t lane = (uint32_t)_tzcnt_u64(pending);
        asked_binary |= (uint64_t)(node_contexts_converted(state, x + lane) ? 1 : 0) << lane;
    }
    return asked_binary;
}

static __attribute__((noinline, cold, preserve_all)) uint64_t node_contexts_x_spaced(const struct NodeFactsReader* state, const NodeFront* front, uint32_t x, uint64_t masked)
{
    uint64_t spaced = 0;
    for (uint64_t pending = masked; pending != 0; pending &= pending - 1)
    {
        const uint32_t lane = (uint32_t)_tzcnt_u64(pending);
        const TypeId stored = state->facts.records[x + lane - front->window_left[x + lane]].type;
        spaced |= (uint64_t)(check_lower_segment_override(state->facts.machine->types, stored) != 0 ? 1 : 0) << lane;
    }
    return spaced;
}

typedef struct NodeContextsDeadX NodeContextsDeadX;
struct NodeContextsDeadX
{
    uint64_t dead;
    uint64_t dead_low;
};

static __attribute__((noinline, preserve_all)) NodeContextsDeadX node_contexts_x_dead(const NodeFront* front, uint32_t x, uint64_t lanes, uint64_t dead, uint32_t dead_low)
{
    for (uint64_t pending = lanes; pending != 0; pending &= pending - 1)
    {
        const uint32_t lane = (uint32_t)_tzcnt_u64(pending);
        const uint32_t size = front->sizes[x + lane];
        const uint32_t low = x + lane + 1 - (size < x + lane + 1 ? size : x + lane + 1);
        const uint64_t below = (UINT64_C(1) << lane) - 1;
        dead |= low <= x ? below : below & (~UINT64_C(0) << (low - x));
        dead_low = low < x && low < dead_low ? low : dead_low;
    }
    return (NodeContextsDeadX){ .dead = dead, .dead_low = dead_low };
}

static __attribute__((noinline, preserve_all)) void node_contexts_x_far(const struct NodeFactsReader* state, const NodeFront* front, const NodeContextsTables* tables, uint32_t x,
                                                                      uint64_t far_up, uint64_t far_left, uint8_t far_bytes[BUSTER_NODE_CONTEXTS_FAR_ROWS][64])
{
FAR_LOOPS}

static __attribute__((noinline, aligned(64))) void node_contexts_window_loop(""")
start = t.index("            for (uint64_t pending = far_up; pending != 0; pending &= pending - 1)\n")
end = t.index("            consumer_classes = _mm512_mask_loadu_epi8(consumer_classes, far_up, far_bytes[BUSTER_NODE_CONTEXTS_FAR_CONSUMER_CLASS]);\n")
far_loops = t[start:end]
t = t[:start] + "            node_contexts_x_far(state, front, tables, x, far_up, far_left, far_bytes);\n" + t[end:]
# The far loops' text, one level out.
far_out = '\n'.join((line[8:] if line.startswith('        ') else line) for line in far_loops.rstrip('\n').split('\n')) + '\n'
t = t.replace("FAR_LOOPS", far_out)
rep("""        for (uint64_t pending = pointed; pending != 0; pending &= pending - 1)
        {
            const uint32_t lane = (uint32_t)_tzcnt_u64(pending);
            pointed &= ~((uint64_t)(node_contexts_stride(state, x + lane, &asked) ? 0 : 1) << lane);
            strides += 1;
        }
""", """        strides += (uint64_t)_mm_popcnt_u64(pointed);
        if (pointed != 0)
        {
            pointed = node_contexts_x_strides(state, x, pointed, &asked);
        }
""")
rep("""        uint64_t asked_binary = 0;
        for (uint64_t pending = free & placed & numeric & ~both_scalar & ((is_sum & ~either_pointer) | is_binary); pending != 0; pending &= pending - 1)
        {
            const uint32_t lane = (uint32_t)_tzcnt_u64(pending);
            asked_binary |= (uint64_t)(node_contexts_converted(state, x + lane) ? 1 : 0) << lane;
            converted += 1;
        }
""", """        uint64_t asked_binary = 0;
        const uint64_t asking = free & placed & numeric & ~both_scalar & ((is_sum & ~either_pointer) | is_binary);
        converted += (uint64_t)_mm_popcnt_u64(asking);
        if (__builtin_expect(asking != 0, 0))
        {
            asked_binary = node_contexts_x_converted(state, x, asking);
        }
""")
start = t.index("        if (__builtin_expect(extended, 0))\n        {\n            for (uint64_t pending = update_masked;")
end = t.index("        const __mmask64 made_update = _cvtu64_mask64(update_masked & ~spaced")
t = t[:start] + """        if (__builtin_expect(extended, 0))
        {
            spaced = node_contexts_x_spaced(state, front, x, update_masked);
        }
""" + t[end:]
rep("""        for (uint64_t pending = placed & ~evaluates & ~is_value; pending != 0; pending &= pending - 1)
        {
            const uint32_t lane = (uint32_t)_tzcnt_u64(pending);
            const uint32_t size = front->sizes[x + lane];
            const uint32_t low = x + lane + 1 - (size < x + lane + 1 ? size : x + lane + 1);
            const uint64_t below = (UINT64_C(1) << lane) - 1;
            dead |= low <= x ? below : below & (~UINT64_C(0) << (low - x));
            dead_low = low < x && low < dead_low ? low : dead_low;
        }
""", """        const uint64_t unevaluated = placed & ~evaluates & ~is_value;
        if (unevaluated != 0)
        {
            const NodeContextsDeadX ranges = node_contexts_x_dead(front, x, unevaluated, dead, dead_low);
            dead = ranges.dead;
            dead_low = (uint32_t)ranges.dead_low;
        }
""")
open(p, 'w').write(t)

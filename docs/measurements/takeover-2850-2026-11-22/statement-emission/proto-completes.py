#!/usr/bin/env python3
# proto-completes.py TREE: a throwaway prototype for the prediction of the statement emission's cut (#2850), applied to
# a checkout of main: check_control_completes keeps its answers by statement for one body's or one region's phase, and
# a loop's break scan runs only where its answer is read. PROTO_NO_MEMO=1 turns the keeping off in the same binary;
# PROTO_COUNTS=1 prints the walk's visits and its computed statements at each program run's end. Not the piece's code.
import sys, pathlib

tree = pathlib.Path(sys.argv[1])
program = tree / 'src/buster/compiler/c_check_program.c'
reach = tree / 'src/buster/compiler/c_check_program_reach.c'


def replace(text, old, new, count=1):
    assert text.count(old) == count, (old[:70], text.count(old))
    return text.replace(old, new)


p = program.read_text()
p = replace(p, '''    // CheckProgramOptions.enterable_work, or null.
    uint64_t* enterable_work;
''', '''    // CheckProgramOptions.enterable_work, or null.
    uint64_t* enterable_work;
    uint16_t* completes;
    uint64_t completes_visits;
    uint64_t completes_misses;
''')
p = replace(p, '''    writer->opening = opening;
    writer->closing = closing;
    check_control_children(writer, opening, closing);
''', '''    writer->opening = opening;
    writer->closing = closing;
    {
        static int off = -1;
        if (off < 0)
        {
            off = getenv("PROTO_NO_MEMO") != NULL;
        }
        if (off == 0 && writer->completes == NULL)
        {
            writer->completes = calloc((uint64_t)writer->parser->tokens.count + 1, sizeof(uint16_t));
        }
        else if (off == 0 && opening <= closing)
        {
            memset(writer->completes + opening, 0, ((uint64_t)closing - opening + 1) * sizeof(uint16_t));
        }
    }
    check_control_children(writer, opening, closing);
''')
p = replace(p, '''            writer->region_final = source->final_statement;
''', '''            writer->region_final = source->final_statement;
            uint32_t proto_low = 0;
            uint32_t proto_high = 0;
            check_control_extent(writer, source->block, &proto_low, &proto_high);
            if (writer->completes != NULL && proto_low <= proto_high)
            {
                memset(writer->completes + proto_low, 0, ((uint64_t)proto_high - proto_low + 1) * sizeof(uint16_t));
            }
''')
p = replace(p, '''            check_control_end(writer, source->closing);
            writer->region_final = BUSTER_CHECK_NONE;
''', '''            check_control_end(writer, source->closing);
            writer->region_final = BUSTER_CHECK_NONE;
            if (writer->completes != NULL && proto_low <= proto_high)
            {
                memset(writer->completes + proto_low, 0, ((uint64_t)proto_high - proto_low + 1) * sizeof(uint16_t));
            }
''')
p = replace(p, '''    arena_release(&run->extents.arena);
''', '''    arena_release(&run->extents.arena);
    if (getenv("PROTO_COUNTS") != NULL)
    {
        fprintf(stderr, "completes: visits=%llu computed=%llu\\n", (unsigned long long)run->writer.completes_visits,
                (unsigned long long)run->writer.completes_misses);
    }
''')
program.write_text(p)

r = reach.read_text()
r = replace(r, '''    bool skip_final;
    bool then_ip;
};
''', '''    bool skip_final;
    bool then_ip;
    uint32_t key;
    bool key_entered;
    bool keyed;
};

static inline void check_control_completes_keep(uint16_t* memo, const CheckReachFrame* frame, uint32_t targets, bool result)
{
    if (memo != NULL)
    {
        const uint32_t bit = targets | (frame->entered ? 1u : 0u);
        memo[frame->token] |= (uint16_t)((1u << bit) | ((result ? 1u : 0u) << (8 + bit)));
        const uint32_t first = targets | (frame->key_entered ? 1u : 0u);
        memo[frame->key] |= (uint16_t)((1u << first) | ((result ? 1u : 0u) << (8 + first)));
    }
}
''')
r = replace(r, '''    bool overflow = token == BUSTER_CHECK_NONE;
    if (!overflow)
    {
        stack[0] = (CheckReachFrame){ .token = token, .step = CHECK_REACH_STATEMENT, .entered = entered };
''', '''    bool overflow = token == BUSTER_CHECK_NONE;
    uint16_t* const memo = writer->completes;
    const uint32_t targets = (stop == BUSTER_CHECK_NONE ? 2u : 0u) | (repeat == BUSTER_CHECK_NONE ? 4u : 0u);
    if (!overflow)
    {
        stack[0] = (CheckReachFrame){ .token = token, .step = CHECK_REACH_STATEMENT, .entered = entered };
''')
r = replace(r, '''        else if (have && frame->step == CHECK_REACH_IF_ELSE)
        {
            result = frame->then_ip || result;
            depth -= 1;
        }
        else if (frame->step == CHECK_REACH_STATEMENT)
        {
            const uint8_t role = writer->parser->tree.roles[frame->token];
            bool leaf_result = true;
            if (check_control_reach_leaf(writer, frame->token, stop, repeat, &leaf_result))
            {
                result = leaf_result;
                have = true;
                depth -= 1;
            }
''', '''        else if (have && frame->step == CHECK_REACH_IF_ELSE)
        {
            result = frame->then_ip || result;
            check_control_completes_keep(memo, frame, targets, result);
            depth -= 1;
        }
        else if (frame->step == CHECK_REACH_STATEMENT)
        {
            if (!frame->keyed)
            {
                frame->key = frame->token;
                frame->key_entered = frame->entered;
                frame->keyed = true;
            }
            const uint32_t bit = targets | (frame->entered ? 1u : 0u);
            const uint8_t role = writer->parser->tree.roles[frame->token];
            bool leaf_result = true;
            writer->completes_visits += 1;
            if (memo != NULL && ((uint32_t)memo[frame->token] >> bit & 1u) != 0)
            {
                result = ((uint32_t)memo[frame->token] >> (8 + bit) & 1u) != 0;
                check_control_completes_keep(memo, frame, targets, result);
                have = true;
                depth -= 1;
            }
            else if (++writer->completes_misses != 0 && check_control_reach_leaf(writer, frame->token, stop, repeat, &leaf_result))
            {
                result = leaf_result;
                check_control_completes_keep(memo, frame, targets, result);
                have = true;
                depth -= 1;
            }
''')
r = replace(r, '''                if (falls || (folded && first == BUSTER_CHECK_NONE))
                {
                    // No else, or `if (0)` with no else: control continues after the if.
                    result = true;
                    have = true;
                    depth -= 1;
                }
''', '''                if (falls || (folded && first == BUSTER_CHECK_NONE))
                {
                    // No else, or `if (0)` with no else: control continues after the if.
                    result = true;
                    check_control_completes_keep(memo, frame, targets, result);
                    have = true;
                    depth -= 1;
                }
''')
r = replace(r, '''            if (!pushed && !overflow)
            {
                result = frame->ip;
                have = true;
                depth -= 1;
            }
''', '''            if (!pushed && !overflow)
            {
                result = frame->ip;
                check_control_completes_keep(memo, frame, targets, result);
                have = true;
                depth -= 1;
            }
''')
r = replace(r, '''            const bool always = check_control_reach_always(writer, expression, false);
            const bool breaks = check_control_reach_breaks(writer, token, body);
            result = !always || breaks;
''', '''            const bool always = check_control_reach_always(writer, expression, false);
            result = !always || check_control_reach_breaks(writer, token, body);
''')
r = replace(r, '''        const bool breaks = check_control_reach_breaks(writer, token, body);
        result = !absent || breaks;
''', '''        result = !absent || check_control_reach_breaks(writer, token, body);
''')
reach.write_text(r)
print('applied')

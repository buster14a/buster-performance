# Applies the local experiment knobs (not for the branch) to a tree's c_preprocessor.c: BUSTER_PP_PRINT_PREFETCH (0 none,
# 1 each spelling's first byte) and BUSTER_PP_PRINT_BUFFER (log2 of the buffer's bytes).
import sys
p = sys.argv[1] + '/src/buster/compiler/c_preprocessor.c'
s = open(p).read()
def rep(old, new):
    global s
    assert s.count(old) == 1, (old, s.count(old))
    s = s.replace(old, new)
rep("""// For pp_print_spellings, by kind""", """static int pp_print_knob_prefetch = -1;
static int pp_print_knob_buffer = -1;
static void pp_print_knobs(void)
{
    if (pp_print_knob_prefetch < 0)
    {
        const char* text = getenv("BUSTER_PP_PRINT_PREFETCH");
        pp_print_knob_prefetch = text != 0 ? atoi(text) : 0;
        text = getenv("BUSTER_PP_PRINT_BUFFER");
        pp_print_knob_buffer = text != 0 ? atoi(text) : 20;
    }
}

// For pp_print_spellings, by kind""")
rep("""    result = result && empty == 0;
    // The classes' characters by kind""", """    result = result && empty == 0;
    if (result && pp_print_knob_prefetch != 0)
    {
        const uint64_t which = pp_print_knob_prefetch == 3 ? identifiers & valid : pp_print_knob_prefetch == 4 ? others : valid;
        for (uint64_t bits = which; bits != 0; bits &= bits - 1)
        {
            __builtin_prefetch(spellings[__builtin_ctzll(bits)], 0, 3);
        }
    }
    // The classes' characters by kind""")
rep("""    const uint64_t capacity = 1ull << 20;
    uint8_t* buffer = arena_push(scratch.arena, capacity + 64, 64);""", """    pp_print_knobs();
    const uint64_t capacity = 1ull << pp_print_knob_buffer;
    uint8_t* buffer = arena_push(scratch.arena, capacity + 64, 64);""")
open(p, 'w').write(s)

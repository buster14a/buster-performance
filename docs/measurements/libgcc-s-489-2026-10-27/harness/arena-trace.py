import sys
p = sys.argv[1]
s = open(p).read()
old = """        result = (void*)aligned;
        arena->length = begin + size;
    }
    return result;
}
"""
new = """        result = (void*)aligned;
        arena->length = begin + size;
        arena_trace(arena);
    }
    return result;
}
"""
assert s.count(old) == 1
s = s.replace(old, new)
hook = """static void* arena_push(Arena* arena, uint64_t size, uint64_t alignment)
{"""
trace = """#include <execinfo.h>
static struct { uint8_t* base; uint64_t high; } arena_trace_table[256];
static void arena_trace(Arena* arena)
{
    unsigned i = 0;
    while (i < 256 && arena_trace_table[i].base != 0 && arena_trace_table[i].base != arena->base) i += 1;
    if (i < 256)
    {
        arena_trace_table[i].base = arena->base;
        uint64_t old = arena_trace_table[i].high;
        if (arena->length > old)
        {
            arena_trace_table[i].high = arena->length;
            uint64_t t0 = old < (64u << 10) ? 0 : (old - (64u << 10)) / (2u << 20) + 1;
            uint64_t t1 = arena->length <= (64u << 10) ? 0 : (arena->length - (64u << 10) - 1) / (2u << 20) + 1;
            if (t1 > t0)
            {
                void* frames[12];
                int n = backtrace(frames, 12);
                fprintf(stderr, "ARENA %p crossed to %llu bytes (huge page %llu):", (void*)arena->base, (unsigned long long)arena->length, (unsigned long long)t1);
                for (int f = 1; f < n; f += 1) fprintf(stderr, " %p", frames[f]);
                fprintf(stderr, "\\n");
            }
        }
    }
}
"""
assert s.count(hook) == 1
s = s.replace(hook, trace + hook)
open(p, "w").write(s)

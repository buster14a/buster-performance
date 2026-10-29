# The diagnostic of 3-diag3.sh, not a change of item 2: the deferred state's own arenas in base pages.
import sys
p = sys.argv[1]
s = open(p).read()
a = """static void check_deferred_arena(Arena* arena, uint64_t capacity)
{
    if (arena->base == 0)
    {
        *arena = arena_reserve(capacity);
    }
    arena_pop_to(arena, 0);
}"""
b = """static void check_deferred_arena(Arena* arena, uint64_t capacity)
{
    if (arena->base == 0)
    {
        *arena = arena_reserve(capacity);
        if (arena->base != 0)
        {
            madvise(arena->base - arena->mapping_offset, arena_mapping_bytes(capacity), MADV_NOHUGEPAGE);
        }
    }
    arena_pop_to(arena, 0);
}"""
assert s.count(a) == 1
open(p, 'w').write(s.replace(a, b))

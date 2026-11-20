import sys
root = '/home/user/wt-2546/src/buster/compiler/'
def edit(name, pairs):
    p = root + name
    s = open(p).read()
    for old, new in pairs:
        assert s.count(old) == 1, (name, old)
        s = s.replace(old, new)
    open(p, 'w').write(s)
edit('lane.c', [
("""// Linux's MADV_POPULATE_WRITE (5.14), which the C library's headers may not name.
#define BUSTER_ARENA_MADV_POPULATE_WRITE 23
""", """// Linux's MADV_POPULATE_WRITE (5.14), which the C library's headers may not name.
#define BUSTER_ARENA_MADV_POPULATE_WRITE 23
static int mutant_2546_value = -2;
static int mutant_2546(void)
{
    if (mutant_2546_value == -2)
    {
        const char* text = getenv("M2546");
        mutant_2546_value = text != 0 ? atoi(text) : 0;
    }
    return mutant_2546_value;
}
#define M2546(k) (mutant_2546() == (k))
"""),
("""    const uintptr_t begin = (uintptr_t)bytes & ~(uintptr_t)(BUSTER_ARENA_PAGE_BYTES - 1);
    if (size != 0)
    {
        madvise((void*)begin, (uintptr_t)bytes + size - begin, BUSTER_ARENA_MADV_POPULATE_WRITE);
    }""", """    const uintptr_t begin = M2546(2) ? (uintptr_t)bytes : (uintptr_t)bytes & ~(uintptr_t)(BUSTER_ARENA_PAGE_BYTES - 1);
    if (size != 0 || M2546(1))
    {
        madvise((void*)begin, M2546(3) ? size : (uintptr_t)bytes + size - begin, BUSTER_ARENA_MADV_POPULATE_WRITE);
    }"""),
("""    const bool result = arena->mapping_bytes != 0 && !arena->unaccounted && peak - length < bytes && arena_push(arena, bytes, 1) != 0;
    if (result)
    {
        arena_pop_to(arena, length);
        arena_fault_in(arena->base + peak, length + bytes - peak);
    }""", """    const bool result = (arena->mapping_bytes != 0 || M2546(4)) && (!arena->unaccounted || M2546(5)) && (M2546(6) ? peak - length <= bytes : peak - length < bytes) && (arena_push(arena, bytes, 1) != 0 || M2546(7));
    if (result)
    {
        if (!M2546(8))
        {
            arena_pop_to(arena, length);
        }
        const uint64_t from = M2546(9) ? length : peak;
        arena_fault_in(arena->base + from, M2546(10) ? bytes : length + bytes - from);
    }"""),
])
link_calls = []
s = open(root + 'link.c').read()
start = s.index('static void link_populate(const Link* link, LinkCapacity added)')
end = s.index('// Whether atoms of the class have no bytes.', start)
body = s[start:end]
lines = body.split('\n')
k = 15
out = []
for line in lines:
    if line.strip().startswith('link_populate_column('):
        out.append('    if (!M2546(%d))' % k)
        out.append('    {')
        out.append('    ' + line)
        out.append('    }')
        k += 1
    else:
        out.append(line)
assert k == 44, k
s = s[:start] + '\n'.join(out) + s[end:]
s = s.replace("""    const uint32_t room = capacity - count;
    const uint32_t taken = added < room ? added : room;
    arena_fault_in((const uint8_t*)records + count * element, taken * element);""", """    const uint32_t room = M2546(11) ? capacity : capacity - count;
    const uint32_t taken = M2546(12) ? added : added < room ? added : room;
    arena_fault_in((const uint8_t*)records + (M2546(13) ? count : count * element), M2546(14) ? taken : taken * element);""", 1)
open(root + 'link.c', 'w').write(s)
edit('bind.c', [
("""            bind_capacity_piece(runtime, RUNTIME_OBJECTS + w * 64 + (uint32_t)__builtin_ctzll(pending), &added, &name_bytes, &atom_bytes);""",
 """            if (!M2546(45))
            {
                bind_capacity_piece(runtime, (M2546(46) ? 0 : RUNTIME_OBJECTS) + w * 64 + (uint32_t)__builtin_ctzll(pending), &added, &name_bytes, &atom_bytes);
            }"""),
("""    if (arena_populate(bind->bytes, atom_bytes))
    {
        arena_populate(link->name_arena, name_bytes);
        link_populate(link, added);
    }""", """    if (arena_populate(bind->bytes, atom_bytes) || M2546(47))
    {
        if (!M2546(48))
        {
            arena_populate(link->name_arena, name_bytes);
        }
        if (!M2546(49))
        {
            link_populate(link, added);
        }
    }"""),
("""    bind_populate(bind, link);
""", """    if (!M2546(44))
    {
        bind_populate(bind, link);
    }
"""),
])
print('mutants applied')

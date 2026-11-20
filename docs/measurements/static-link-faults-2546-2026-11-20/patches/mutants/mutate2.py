# Switch build of the review fixes' mutants: M2546=k selects mutant k (0: none).
import sys
root = sys.argv[1] + '/src/buster/compiler/'
def edit(name, pairs):
    p = root + name
    s = open(p).read()
    for old, new in pairs:
        assert s.count(old) == 1, (name, old)
        s = s.replace(old, new)
    open(p, 'w').write(s)
edit('lane.c', [
("""static bool arena_base_pages(void)
{
    return arena_pages_busy || prctl(PR_GET_THP_DISABLE, 0, 0, 0, 0) == 1;
}
""", """static int mutant_2546_value = -2;
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
static bool arena_base_pages(void)
{
    const bool busy = arena_pages_busy;
    const bool off = prctl(PR_GET_THP_DISABLE, 0, 0, 0, 0) == 1;
    return M2546(6) ? busy : M2546(7) ? off : M2546(8) ? busy && off : M2546(9) ? true : M2546(10) ? false : M2546(11) ? busy || prctl(PR_GET_THP_DISABLE, 0, 0, 0, 0) == 0 : busy || off;
}
"""),
])
edit('bind.c', [
("""    const bool base_pages = arena_base_pages();""", """    const bool base_pages = M2546(1) ? true : M2546(2) ? !arena_base_pages() : arena_base_pages();"""),
("""    bind_populate(bind, link);
    for (uint32_t w = 0; bind->error == BIND_ERROR_NONE && w < words; w += 1)""", """    if (!M2546(3) && !M2546(4) && !M2546(5))
    {
        bind_populate(bind, link);
    }
    for (uint32_t w = 0; bind->error == BIND_ERROR_NONE && w < words; w += 1)"""),
("""            bind->members_joined[w] |= 1ull << (m % 64);
            bind_join(bind, link, RUNTIME_OBJECTS + m);
        }
    }
}""", """            bind->members_joined[w] |= 1ull << (m % 64);
            bind_join(bind, link, RUNTIME_OBJECTS + m);
        }
    }
    if (M2546(3))
    {
        bind_populate(bind, link);
    }
}"""),
])
# 4: populate moved into bind_end after bind_static_members
s = open(root + 'bind.c').read()
import re
i = s.index('BUSTER_LINKER_ENTRY bool bind_end(Bind* bind, Link* link)')
j = s.index('bind_static_members(bind, link);', i)
k = s.index(';', j) + 1
s = s[:k] + '\n        if (M2546(4))\n        {\n            bind_populate(bind, link);\n        }' + s[k:]
open(root + 'bind.c', 'w').write(s)
print('mutated')

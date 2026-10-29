# The diagnostic of 3-diag4.sh, not a change of item 2: a lane's per-name columns' pages populated when they are laid
# out (MADV_POPULATE_WRITE), so that no body's walk faults them in.
import sys
p = sys.argv[1]
s = open(p).read()
a = """        arenas->name_room = (uint32_t)room;
        arenas->name_bytes = arena->length;"""
b = """        if (arenas->name_bytes == 0)
        {
            madvise(arena->base, arena->length, 23);
        }
        arenas->name_room = (uint32_t)room;
        arenas->name_bytes = arena->length;"""
assert s.count(a) == 1
open(p, 'w').write(s.replace(a, b))

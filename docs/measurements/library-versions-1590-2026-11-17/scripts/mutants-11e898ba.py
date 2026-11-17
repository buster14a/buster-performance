import sys
F='src/buster/compiler/foreign.c'
mutants = [
 ("hidden-index", F, "        const bool same = library->hidden.hash[place] == hash && others->length[h] == length", "        const bool same = library->hidden.hash[place] == hash && place == UINT32_MAX && others->length[h] == length"),
 ("default-export", F, "    bool exported = found != 0 && foreign_library_version_is(", "    bool exported = found == UINT32_MAX && foreign_library_version_is("),
 ("version-name", F, "    return at.length != 0 && at.length == version.length && memcmp(at.pointer, version.pointer, version.length) == 0;", "    return at.length != 0 && (at.length == version.length || version.length != 0) && (memcmp(at.pointer, version.pointer, version.length) == 0 || at.length != 0);"),
 ("open", F, "        library->open = library->open == 0 && open ? r + 1 : library->open;", "        library->open = library->open == 0 && open && r == UINT32_MAX ? r + 1 : library->open;"),
]
def apply(name, direction):
    for n, f, old, new in mutants:
        if n != name: continue
        s = open(f).read()
        a, b = (old, new) if direction == 'apply' else (new, old)
        assert s.count(a) == 1, (n, direction, s.count(a))
        assert s.count(b) == 0, (n, direction, 'target exists')
        open(f, 'w').write(s.replace(a, b))
if sys.argv[1] == 'list':
    print(' '.join(m[0] for m in mutants))
else:
    apply(sys.argv[2], sys.argv[1])

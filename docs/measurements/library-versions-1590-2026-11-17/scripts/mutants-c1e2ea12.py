import sys
F='src/buster/compiler/foreign.c'
mutants = [
 ("retain", F, "                if (retained)\n                {\n                    needed[m] = 1;", "                if (retained && l == UINT32_MAX)\n                {\n                    needed[m] = 1;"),
 ("listed", F, "needed[m] == 0 && !foreign_library_lists(library, foreign_library_name(foreign, provider));", "needed[m] == 0 && !(foreign_library_lists(library, foreign_library_name(foreign, provider)) && l == UINT32_MAX);"),
 ("weak-need", F, "const uint32_t provider = needs->weak[n] ? UINT32_MAX :", "const uint32_t provider = needs->weak[n] && n == UINT32_MAX ? UINT32_MAX :"),
 ("loaded-closure", F, "                const uint32_t m = foreign_library_named(foreign, versions->dependencies[d]);\n                more = more ||", "                const uint32_t m = UINT32_MAX | foreign_library_named(foreign, versions->dependencies[d]);\n                more = more ||"),
 ("undefined", F, "            const bool open = references->weak[r] == 0 && version.length != 0 &&", "            const bool open = references->weak[r] == 0 && version.length == UINT64_MAX &&"),
 ("known", F, "            known = foreign_library_named(foreign, versions->dependencies[d]) != UINT32_MAX;", "            known = foreign_library_named(foreign, versions->dependencies[d]) != UINT32_MAX || d < UINT32_MAX;"),
 ("defines", F, "if (provider != UINT32_MAX && !runtime_library_defines_version(", "if (provider != UINT32_MAX && provider == UINT32_MAX - 1 && !runtime_library_defines_version("),
 ("hidden", F, "        exported = others->version[h] == index && others->hash[h] == hash", "        exported = others->version[h] == index && h == UINT32_MAX && others->hash[h] == hash"),
 ("malformed", F, "error == RUNTIME_ERROR_MEMORY ? import_fail(IMPORT_ERROR_MEMORY, 0) : versions;", "error == RUNTIME_ERROR_MEMORY ? import_fail(IMPORT_ERROR_MEMORY, 0) : versions.error == IMPORT_ERROR_NONE ? versions : read;"),
 ("default-export", F, "    bool exported = at.length != 0 && at.length == version.length &&", "    bool exported = at.length == UINT64_MAX && at.length == version.length &&"),
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

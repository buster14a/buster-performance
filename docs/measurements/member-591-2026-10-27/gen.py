#!/usr/bin/env python3
# gen.py DIR: the scaling units of #591, as test-checker writes them (check_test_member_source), at several sizes:
# records-N (N structs of 3 to 26 members, an anonymous union every 7th, a 50-level pointer to each and a function that
# reads 16 of its members) and members-N (one struct of N members, an anonymous struct every 50th, read in one function).
import os, sys
out = sys.argv[1]
os.makedirs(out, exist_ok=True)
def records(size):
    parts = []
    for i in range(size):
        extra = i % 24
        anonymous = i % 7 == 0
        s = "struct s%u { int a; int b; long c;" % i
        for d in range(extra):
            s += " int d%u;" % d
        s += "%s };\nstruct s%u %s q%u;\nlong f%u(struct s%u* p) { return 0" % (" union { int u; short v; };" if anonymous else "", i, "*" * 50, i, i, i)
        names = 3 + extra + (2 if anonymous else 0)
        for read in range(16):
            name = (read * 5 + i) % names
            if name < 3:
                s += " + p->%c" % chr(ord('a') + name)
            elif name < 3 + extra:
                s += " + p->d%u" % (name - 3)
            else:
                s += " + p->%c" % ('u' if name == 3 + extra else 'v')
        parts.append(s + "; }\n")
    return "".join(parts)
def members(size):
    s = "struct big {\n"
    for i in range(size):
        s += ("    struct { int x%u; short y%u; };\n" % (i, i)) if i % 50 == 49 else ("    int m%u;\n" % i)
    s += "};\nlong f(struct big* p)\n{\n    long s = 0;\n"
    for i in range(size):
        s += ("    s += p->x%u + p->y%u;\n" % (i, i)) if i % 50 == 49 else ("    s += p->m%u;\n" % i)
    return s + "    return s;\n}\n"
for size in (500, 1000, 2000, 4000, 8000):
    open(os.path.join(out, "records-%u.c" % size), "w").write(records(size))
for size in (2500, 5000, 10000, 20000, 40000):
    open(os.path.join(out, "members-%u.c" % size), "w").write(members(size))

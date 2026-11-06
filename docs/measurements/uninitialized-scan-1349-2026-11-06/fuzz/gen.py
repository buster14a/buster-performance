#!/usr/bin/env python3
# gen.py SEED: one C file of random local brace initializers that mention their own object (#1349's scan), in reach of
# sizeof/__alignof__ operands, members after . and ->, statement expressions, casts and long element lists. Well typed,
# so that no error suppresses the warnings.
import random, sys
r = random.Random(int(sys.argv[1]))
def leaf(ref, depth):
    c = r.randrange(15)
    if c <= 1: return ref
    if c == 2: return "(int)sizeof(%s)" % expr(ref, depth + 1)
    if c == 3: return "(int)__alignof__(%s)" % ref
    if c == 4: return "s.%s" % r.choice("xyt")
    if c == 5: return "p->%s" % r.choice("xyt")
    if c == 6: return "(int)%s" % ref
    if c == 7 and depth < 2: return "({ int inner = { %s }; inner; })" % expr(ref, depth + 1)
    if c == 8: return "(&%s != 0)" % ref
    if c == 9: return "(%s = 1)" % ref
    if c == 10: return "(0 ? %s : 1)" % ref
    if c == 11: return "(1 ? 2 : %s)" % ref
    if c == 12: return "other"
    return str(r.randrange(100))
def expr(ref, depth):
    n = 1 + (r.randrange(40) if r.randrange(4) == 0 else r.randrange(3))
    parts = [leaf(ref, depth) for _ in range(n)]
    out = parts[0]
    for p in parts[1:]:
        op = r.choice(["+", "-", "*", "|", "^", ","])
        out = "(%s %s %s)" % (out, op, p) if op == "," else "%s %s %s" % (out, op, p)
    return out
lines = ["struct S { int x; int y; int t; };", "int other;"]
for f in range(40):
    name = r.choice(["x", "y", "t"])
    kind = r.randrange(3)
    if kind == 0:
        body = "int %s = { %s };" % (name, expr(name, 0))
        ret = name
    elif kind == 1:
        n = 1 + r.randrange(200)
        ref = "%s[%d]" % (name, r.randrange(n))
        body = "int %s[%d] = { %s };" % (name, n, ", ".join(expr(ref, 1) if r.randrange(10) == 0 else str(i) for i in range(n)))
        ret = "%s[0]" % name
    else:
        body = "long %s = { %s }, w = { %s };" % (name, expr(name, 0), expr("w", 0))
        ret = name
    lines.append("int f%d(struct S s, struct S *p) { %s return (int)%s + s.x + p->y; }" % (f, body, ret))
print("\n".join(lines))

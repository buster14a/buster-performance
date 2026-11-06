# usage: gen.py seed out.c — one random file-scope table of rows, mostly eligible, sometimes one change that is not
import random, sys
r = random.Random(int(sys.argv[1]))
types = [("unsigned char", 0, 255), ("signed char", -128, 127), ("short", -32768, 32767), ("unsigned short", 0, 65535),
         ("int", -2**31, 2**31 - 1), ("unsigned", 0, 2**32 - 1), ("long", -2**63, 2**63 - 1), ("unsigned long long", 0, 2**64 - 1),
         ("float", None, None), ("double", None, None), ("_Bool", 0, 1), ("char", -128, 127)]
name, lo, hi = r.choice(types)
quals = r.choice(["", "const ", "static const ", "static ", "volatile "] if r.random() < 0.1 else ["", "const ", "static const "])
cols = r.choice([1, 2, 3, 4, 5, 7, 8, 16, 17, 32])
rows = max(1, r.randrange(100, 700) // cols)
sized = r.random() < 0.4
extra = r.choice([0, 0, 1, 3])
change = r.choice(["none"] * 6 + ["short", "excess", "desig_row", "desig_elem", "expr", "deep", "elide", "range", "empty", "big", "char", "paren"])
at = r.randrange(rows)
def spell(i):
    if name in ("float", "double"):
        v = r.randrange(-5000, 5000)
        k = r.randrange(5)
        return [f"{v}.25", f"{v}", f"{v}e-1", f"0x1.8p{v % 7}", f"{v}.5f"][k]
    v = r.randrange(lo, hi + 1) if r.random() < 0.7 else r.randrange(max(lo, -300), min(hi, 300) + 1)
    if change == "big" and i == 0:
        v = hi + 1
    k = r.randrange(6)
    if v < 0:
        return f"-{-v}" if k != 5 else f"-0x{-v:x}"
    return [f"{v}", f"0x{v:x}", f"0{v:o}" if v else "0", f"{v}u", f"{v}L", f"0X{v:X}"][k]
out = []
out.append(f"{quals}{name} table[{rows + extra if sized else ''}][{cols}]" + ("[2]" if change == "deep" else "") + " = {")
for i in range(rows):
    n = cols
    if change == "short" and i == at and cols > 1:
        n = cols - 1
    if change == "excess" and i == at:
        n = cols + 1
    items = []
    for c in range(n):
        s = spell(i * cols + c)
        if change == "deep":
            s = "{" + s + ", " + spell(0) + "}"
        items.append(s)
    if change == "desig_elem" and i == at:
        items[0] = "[0] = " + items[0]
    if change == "expr" and i == at:
        items[0] = items[0] + " + 1"
    if change == "char" and i == at:
        items[0] = "'a'"
    if change == "paren" and i == at:
        items[0] = "(" + items[0] + ")"
    if change == "range" and i == at and cols > 1:
        items = [f"[0 ... {cols - 1}] = 1"]
    body = ", ".join(items) + ("," if r.random() < 0.3 else "")
    if change == "empty" and i == at:
        body = ""
    row = "{" + body + "}"
    if change == "elide" and i == at:
        row = body if body else "0"
    if change == "desig_row" and i == at:
        row = f"[{i}] = " + row
    out.append("  " + row + ("," if i + 1 < rows or r.random() < 0.5 else ""))
out.append("};")
out.append(f"int get(int i, int j) {{ return (int)table[i][j] + (int)sizeof table; }}")
open(sys.argv[2], "w").write("\n".join(out) + "\n")

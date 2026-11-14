#!/usr/bin/env python3
"""ab-table.py FILE: Markdown tables from vector-copies-ab.sh's lines.

A line is `NAME: add_i32 X ns/element, dot_f32 Y ns/element, digest D | cycles C instructions I conflicts S`, where NAME
is `{base,fix}-tier{0,1}-{sse,avx}-MARCH` or `clang-{O0,O2-novec-nounroll}-{sse,avx}-MARCH`.
"""
import re
import sys

LINE = re.compile(r"^(\S+): add_i32 ([\d.]+) ns/element, dot_f32 ([\d.]+) ns/element, digest (\S+ \S+) \| cycles (\d+) instructions (\d+) conflicts (\d+)$")
NAME = re.compile(r"^(base-tier1|fix-tier1|base-tier0|fix-tier0|clang-O0|clang-O2-novec-nounroll)-(sse|avx)-(.+)$")


def main():
    rows = {}
    order = []
    digests = set()
    for line in open(sys.argv[1]):
        m = LINE.match(line.strip())
        if not m:
            continue
        n = NAME.match(m.group(1))
        key = (n.group(2), n.group(3))
        if key not in rows:
            rows[key] = {}
            order.append(key)
        rows[key][n.group(1)] = (float(m.group(2)), float(m.group(3)), int(m.group(5)), int(m.group(6)), int(m.group(7)))
        digests.add(m.group(4))
    print("Digests: %s (%d lines)." % (", ".join(sorted(digests)), sum(len(r) for r in rows.values())))
    print()
    print("| Source, `-march` | Build | `add_i32` ns/element | `dot_f32` ns/element | User cycles | Instructions | Store-to-load conflicts |")
    print("| --- | --- | ---: | ---: | ---: | ---: | ---: |")
    names = [("base-tier1", "`--tier1`, main"), ("fix-tier1", "`--tier1`, patched"), ("base-tier0", "Tier 0, main"), ("fix-tier0", "Tier 0, patched"), ("clang-O0", "clang -O0"), ("clang-O2-novec-nounroll", "clang -O2, no vectorizer, no unroller")]
    for key in order:
        for name, label in names:
            r = rows[key][name]
            print("| %s, `%s` | %s | %.4f | %.4f | %s | %s | %s |" % (key[0].upper(), key[1], label, r[0], r[1], format(r[2], ","), format(r[3], ","), format(r[4], ",")))
    print()
    print("| Source, `-march` | `--tier1` cycles, main over patched | `--tier1` main over Tier 0 | `--tier1` patched over Tier 0 | `--tier1` patched over clang -O0 | `--tier1` patched over clang -O2 without vectorizer and unroller |")
    print("| --- | ---: | ---: | ---: | ---: | ---: |")
    for key in order:
        r = rows[key]
        base = r["base-tier1"][2]
        fix = r["fix-tier1"][2]
        tier0 = r["base-tier0"][2]
        print("| %s, `%s` | %.2f | %.2f | %.3f | %.3f | %.2f |" % (key[0].upper(), key[1], base / fix, base / tier0, fix / tier0, fix / r["clang-O0"][2], fix / r["clang-O2-novec-nounroll"][2]))


main()

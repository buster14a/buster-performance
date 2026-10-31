#!/usr/bin/env python3
"""Compare check_lower_drain's internal branch geometry across placements."""
import os
import re
import subprocess

ROOT = os.path.expanduser("~/buster-fast-bench/codex-883-takeover-20261031")
SHIFTS = [0, 16, 64, 256, 1024, 2048]
SYMBOL = "check_lower_drain"
LINE = re.compile(r"^\s*([0-9a-f]+):\s+(?:[0-9a-f]{2}\s+)+\s*([a-z0-9.]+)\s*(.*)$")


def geometry(image):
    out = subprocess.check_output(["objdump", "-d", "--disassemble=" + SYMBOL, image], text=True)
    start = None
    size = None
    for line in out.splitlines():
        m = re.match(r"^([0-9a-f]+) <" + SYMBOL + r">:$", line.strip())
        if m:
            start = int(m.group(1), 16)
    # The next symbol's address gives the size; use readelf instead.
    syms = subprocess.check_output(["readelf", "-sW", image], text=True)
    for line in syms.splitlines():
        f = line.split()
        if len(f) >= 8 and f[7] == SYMBOL:
            size = int(f[2], 16)
    edges = []
    for line in out.splitlines():
        m = LINE.match(line)
        if not m:
            continue
        addr = int(m.group(1), 16)
        mnemonic = m.group(2)
        operands = m.group(3)
        if mnemonic.startswith("j") or mnemonic.startswith("loop"):
            t = re.search(r"([0-9a-f]+)\s+<", operands)
            if t:
                target = int(t.group(1), 16)
                if start <= target < start + size:
                    edges.append((addr - start, mnemonic, target - addr))
    return start, size, edges


def main():
    reference = None
    for shift in SHIFTS:
        image = os.path.join(ROOT, "place-candidate", "compiler-%d" % shift)
        start, size, edges = geometry(image)
        print("shift %4d start=%x size=%d internal_branches=%d back_edges=%d" % (
            shift, start, size, len(edges), sum(1 for e in edges if e[2] < 0)))
        print("  " + " ".join("%d:%s%+d" % e for e in edges[:8]))
        if reference is None:
            reference = edges
        elif edges != reference:
            print("  MISMATCH", file=os.sys.stderr)
            return 1
    print("internal branch geometry identical across placements")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

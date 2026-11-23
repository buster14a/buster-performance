#!/usr/bin/env python3
"""loops.py BINARY: each k_* function's innermost loop (its shortest backward branch): start, end, bytes,
instructions, and whether it lies across a 64-byte line. One line per function."""
import re
import subprocess
import sys

def main():
    binary = sys.argv[1]
    text = subprocess.run(["objdump", "-d", "--no-show-raw-insn", binary], capture_output=True, text=True, check=True).stdout
    function = None
    rows = {}
    for line in text.splitlines():
        m = re.match(r"^([0-9a-f]+) <(k_[A-Za-z0-9_]+)>:$", line)
        if m:
            function = m.group(2)
            rows[function] = []
            continue
        if re.match(r"^[0-9a-f]+ <", line):
            function = None
            continue
        if function is None:
            continue
        m = re.match(r"^\s*([0-9a-f]+):\s+(\S+)\s*(.*)$", line)
        if m:
            rows[function].append((int(m.group(1), 16), m.group(2), m.group(3)))
    for name, instructions in rows.items():
        best = None
        for index, (address, mnemonic, operands) in enumerate(instructions):
            if not mnemonic.startswith("j"):
                continue
            m = re.match(r"^([0-9a-f]+) <", operands)
            if not m:
                continue
            target = int(m.group(1), 16)
            if target > address:
                continue
            end = instructions[index + 1][0] if index + 1 < len(instructions) else address + 2
            count = sum(1 for a, _, _ in instructions if target <= a <= address)
            if best is None or end - target < best[1] - best[0]:
                best = (target, end, count)
        if best is None:
            print(f"{name} none")
        else:
            start, end, count = best
            crosses = (start >> 6) != ((end - 1) >> 6)
            print(f"{name} {start:#x} {end:#x} {end - start} {count} {'crosses' if crosses else 'inside'} {start & 63}")

main()

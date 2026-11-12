# cmpclass.py RAW: objdump -d's raw listing's memory comparisons with an immediate (cmpw/cmpl/cmpq $imm, memory), by
# whether the immediate fits a signed byte at the comparison's width, and by opcode: 81 /7 (imm16/imm32) or 83 /7 (imm8).
import re
import sys

widths = {"w": 16, "l": 32, "q": 64}
counts = {}
pattern = re.compile(r"\t((?:[0-9a-f]{2} )+)\s*\tcmp([wlq]) +\$(0x[0-9a-f]+),([^%]*\(.*)$")
for line in open(sys.argv[1]):
    match = pattern.search(line)
    if not match:
        continue
    raw, suffix, immediate, _ = match.groups()
    width = widths[suffix]
    value = int(immediate, 16) & ((1 << width) - 1)
    value = value - (1 << width) if value >> (width - 1) else value
    small = -128 <= value <= 127
    opcode = [b for b in raw.split() if b != "66" and not re.fullmatch(r"4[0-9a-f]", b)][0]
    key = ("small" if small else "large", opcode)
    counts[key] = counts.get(key, 0) + 1
print(" ".join(f"{size}-{opcode}={count}" for (size, opcode), count in sorted(counts.items())))

# lua_mnemonics.py BASE HEAD: lua-fixed.sh's gap.c rows of the five scripts (luaf-NAME-SCRIPT.tsv) summed over the
# scripts: Lua's own instructions, the change by mnemonic (at least 10,000 executions), and the ALU operations that read
# memory (a parenthesized source operand), by build.
import collections
import re
import sys

SCRIPTS = ["calls", "tables", "strings", "arithmetic", "closures"]
ALU = ("add", "and", "or", "xor", "sub", "imul")


def load(name):
    counts = collections.Counter()
    memory = collections.Counter()
    total = 0
    for script in SCRIPTS:
        for line in open(f"luaf-{name}-{script}.tsv"):
            if line.startswith("#total"):
                total += int(line.split("\t")[1])
            if not line.startswith("#ins"):
                continue
            fields = line.rstrip("\n").split("\t")
            words = fields[6].split(None, 1)
            executions = int(fields[5])
            counts[words[0] if words else "?"] += executions
            if len(words) == 2 and words[0] in ALU and re.match(r"^[^,]*\(", words[1]):
                memory[words[0]] += executions
    return counts, memory, total


base, base_memory, base_total = load(sys.argv[1])
head, head_memory, head_total = load(sys.argv[2])
print(f"# Lua's own instructions, five scripts: {sys.argv[1]} {base_total} {sys.argv[2]} {head_total} change {head_total - base_total:+d} ({(head_total - base_total) / base_total * 100:+.3f}%)")
print(f"# mnemonic\t{sys.argv[1]}\t{sys.argv[2]}\tchange")
for mnemonic in sorted(set(base) | set(head), key=lambda m: head[m] - base[m]):
    if abs(head[mnemonic] - base[mnemonic]) >= 10000:
        print(f"{mnemonic}\t{base[mnemonic]}\t{head[mnemonic]}\t{head[mnemonic] - base[mnemonic]:+d}")
print(f"# from memory\t{sys.argv[1]}\t{sys.argv[2]}")
for mnemonic in ALU:
    print(f"{mnemonic}\t{base_memory[mnemonic]}\t{head_memory[mnemonic]}")

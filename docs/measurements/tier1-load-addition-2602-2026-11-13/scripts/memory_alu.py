# memory_alu.py BASE HEAD: two gap.c row files (BASE.tsv and HEAD.tsv) summed for the ALU operations that read memory (add,
# and, or, xor, sub, imul with a parenthesized source operand), by mnemonic: static rows and dynamic executions.
import collections
import re
import sys

ALU = {"add", "and", "or", "xor", "sub", "imul"}


def count(name):
    executions = collections.Counter()
    rows = collections.Counter()
    for line in open(f"{name}.tsv"):
        if not line.startswith("#ins"):
            continue
        fields = line.rstrip("\n").split("\t")
        words = fields[6].split(None, 1)
        if len(words) == 2 and words[0] in ALU and re.match(r"^[^,]*\(", words[1]) and words[1].count(",") >= 1:
            executions[words[0]] += int(fields[5])
            rows[words[0]] += 1
    return executions, rows


base, base_rows = count(sys.argv[1])
head, head_rows = count(sys.argv[2])
print("# mnemonic from memory\tbase rows\thead rows\tbase executions\thead executions")
for mnemonic in sorted(ALU):
    print(f"{mnemonic}\t{base_rows[mnemonic]}\t{head_rows[mnemonic]}\t{base[mnemonic]}\t{head[mnemonic]}")

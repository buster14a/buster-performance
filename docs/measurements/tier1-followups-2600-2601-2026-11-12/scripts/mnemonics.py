# mnemonics.py BASE HEAD: two builds' gap.c rows (st-NAME.tsv, GAP_INSTRUCTIONS=1) summed by mnemonic, and the head's
# change against the base for each mnemonic that moved by at least 10,000 executions, largest drop first.
import collections
import sys


def by_mnemonic(name):
    counts = collections.Counter()
    for line in open(f"st-{name}.tsv"):
        if not line.startswith("#ins"):
            continue
        fields = line.rstrip("\n").split("\t")
        words = fields[6].split()
        counts[words[0] if words else "?"] += int(fields[5])
    return counts


base = by_mnemonic(sys.argv[1])
head = by_mnemonic(sys.argv[2])
changes = {m: head.get(m, 0) - base.get(m, 0) for m in set(base) | set(head)}
print(f"# mnemonic\tbase\thead\tchange ({sys.argv[1]} -> {sys.argv[2]})")
for mnemonic, change in sorted(changes.items(), key=lambda item: item[1]):
    if abs(change) >= 10000:
        print(f"{mnemonic}\t{base.get(mnemonic, 0)}\t{head.get(mnemonic, 0)}\t{change:+d}")

# tally.py NAME...: each build's gap.c rows (st-NAME.tsv, GAP_INSTRUCTIONS=1) into speedtest1's own instructions, its
# rip-relative leas (by the symbol objdump names in the comment), its register-to-register 64-bit movs, and the leas of
# five symbols; and each build's leas by symbol into leas-NAME.tsv.
import collections
import re
import sys


def tally(name):
    by = collections.Counter()
    total = 0
    leas = 0
    movs = 0
    for line in open(f"st-{name}.tsv"):
        if line.startswith("#total"):
            total = int(line.split("\t")[1])
        if not line.startswith("#ins"):
            continue
        fields = line.rstrip("\n").split("\t")
        count = int(fields[5])
        text = fields[6]
        if text.startswith("lea") and "(%rip)" in text:
            match = re.search(r"<([^+>]+)", text)
            by[match.group(1) if match else "?"] += count
            leas += count
        if re.match(r"mov\s+%r\w+,%r\w+$", text.split("#")[0].strip()):
            movs += count
    return total, leas, movs, by


for name in sys.argv[1:]:
    total, leas, movs, by = tally(name)
    symbols = " ".join(f"{s}={by[s] / 1e6:.2f}M" for s in ("mem5", "sqlite3Stat", "sqlite3Config", "g", "mem0"))
    print(name, f"program {total / 1e6:.1f}M rip-leas {leas / 1e6:.2f}M reg-reg 64-bit movs {movs / 1e6:.2f}M", symbols)
    with open(f"leas-{name}.tsv", "w") as out:
        for symbol, count in by.most_common():
            out.write(f"{symbol}\t{count}\n")

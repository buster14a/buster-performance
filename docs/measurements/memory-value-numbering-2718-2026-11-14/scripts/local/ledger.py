#!/usr/bin/env python3
# ledger.py CAMPAIGN_DIRECTORY: one line per case: its status, its first failure and each step's status and signal.
import json, os, sys, re
d = sys.argv[1]
steps = ["buster-tier0-compile", "buster-tier0-run", "buster-tier1-compile", "buster-tier1-run", "clang-o0-compile", "clang-o0-run", "clang-o2-compile", "clang-o2-run"]
print("case\tstatus\tfirst_failure\t" + "\t".join(steps))
for case in sorted(e for e in os.listdir(d) if re.match(r"(csmith|yarpgen)-\d+$", e)):
    signature_path = os.path.join(d, case, "failure.signature")
    signature = open(signature_path).read().strip() if os.path.exists(signature_path) else ""
    cells = []
    for step in steps:
        p = os.path.join(d, case, step + ".json")
        text = open(p).read() if os.path.exists(p) else ""
        status = re.search(r'"status":"[^"]*"', text)
        signal = re.search(r'"signal":-?\d+', text)
        cells.append((status.group(0) if status else "") + (" " + signal.group(0) if signal else ""))
    print(f"{case}\t{'failed' if signature else 'passed'}\t{signature}\t" + "\t".join(cells))

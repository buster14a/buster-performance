# Medians across rounds of benchmark-preprocessor's phases and the screening build's sub-phases, per case, from a
# phases.log or variants.log of #451's runs.
import re, statistics, sys
cases = {}
case = None
for line in open(sys.argv[1]):
    m = re.match(r"== round (\d+) case (\S+)", line)
    if m:
        case = m.group(2)
        cases.setdefault(case, {})
        continue
    if case is None:
        continue
    m = re.match(r"subphase (.+?)\s+\d+ passes, median\s+([\d.]+)", line)
    if m:
        cases[case].setdefault(m.group(1).strip(), []).append(float(m.group(2)))
        continue
    m = re.match(r"\s+read ([\d.]+) ms\s+lex ([\d.]+) ms\s+refine ([\d.]+) ms\s+directives ([\d.]+) ms\s+main loop/setup ([\d.]+) ms", line)
    if m:
        for name, value in zip(("read", "lex", "refine", "directives", "main loop"), m.groups()):
            cases[case].setdefault(name, []).append(float(value))
keys = ["read", "lex", "refine", "directives", "main loop", "W scan", "W pages", "W extract", "W finish", "W finish kinds", "W finish pair",
        "H scans", "H finish", "H finish kinds", "H finish pair", "W lexed bytes", "W file bytes"]
for case, values in cases.items():
    parts = []
    for k in keys:
        if k in values:
            v = values[k]
            unit = "" if "bytes" in k else (" ms" if k in ("read", "lex", "refine", "directives", "main loop") else " us")
            fmt = "%.0f" if "bytes" in k else ("%.3f" if unit == " ms" else "%.1f")
            parts.append(f"{k} {fmt % statistics.median(v)}{unit} [{fmt % min(v)}-{fmt % max(v)}] n={len(v)}")
    print(f"== {case}")
    for p in parts:
        print("   ", p)

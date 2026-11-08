#!/usr/bin/env python3
"""Compare each exported tag row with its compiler outcome; no semantic claim."""
from collections import Counter
from pathlib import Path
import sys

receipt = Path(sys.argv[1])
rows = {}
for line in (receipt / "stderr").read_text().splitlines():
    fields = line.split("\t")
    if fields[0] != "tier1-kind-outcome":
        continue
    name = fields[1]
    if name in rows:
        raise ValueError(f"duplicate outcome: {name}")
    rows[name] = dict(field.split("=", 1) for field in fields[2:])

seen = set()
for line in (receipt / "tags.kinds").read_text().splitlines():
    name, tags = line.split("\t")
    if name in seen or name not in rows:
        raise ValueError(f"duplicate or unknown tag name: {name}")
    seen.add(name)
    outcome = rows[name]
    counts = Counter(tags)
    for key, expected in (("records", len(tags)), ("tags", len(tags)),
                          ("T", counts["T"]), ("U", counts["U"]), ("e", counts["e"])):
        if int(outcome[key]) != expected:
            raise ValueError((name, key, outcome[key], expected))

missing = rows.keys() - seen
if missing:
    raise ValueError(f"outcomes without tags: {sorted(missing)}")
print(f"outcomes={len(rows)} tag_rows={len(seen)} missing=0; lengths and T/U/e counts agree")

"""Summarize JSONL produced by sweep.py, and fail if there is an unsafe admission."""

from collections import Counter, defaultdict
import json
import sys

status = Counter()
totals = defaultdict(Counter)
for line in sys.stdin:
    row = json.loads(line)
    policy = row["policy"]
    status[policy, row["returncode"]] += 1
    for kind, counters in row["counts"].items():
        totals[policy, kind].update(counters)

for (policy, code), count in sorted(status.items()):
    print(f"{policy} exit {code}: {count}")
for (policy, kind), counts in sorted(totals.items()):
    print(policy, kind, *(f"{key}={number}" for key, number in counts.items()))
sys.exit(1 if any(row["unsafe"] for row in totals.values()) else 0)

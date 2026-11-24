#!/usr/bin/env python3
"""Reduce the ABBA recordings in a measure.py output directory."""
import json
from pathlib import Path
import re
from statistics import median
import sys

root = Path(sys.argv[1])
sample = next(root.glob("tree-sizes-*-base.stdout")).read_text()
tokens = int(re.search(r"1 files, (\d+) tokens", sample)[1])
source_bytes = 9_507_037 if "/sqlite/sqlite3.c:" in sample else None


def rows(mode):
    path = root / f"{mode}.jsonl"
    return [json.loads(line) for line in path.read_text().splitlines()] if path.exists() else []


def groups(records, value):
    return {arm: [value(row) for row in records if row["name"].endswith("-" + arm)] for arm in ("base", "candidate")}


def pair(records, value):
    arms = groups(records, value)
    return median(arms["base"]), median(arms["candidate"])


def stage_sample(row, field):
    out = (root / (row["name"] + ".stdout")).read_text()
    return float(re.search(r"([\d.]+) " + field + r"/token", out)[1])


wall = rows("wall")
all_compiles = wall + rows("perf") + rows("stages")
assert all(r["exit"] == 0 for r in all_compiles)
assert len({r["object_sha256"] for r in all_compiles}) == 1
assert len({(r["stdout_sha256"], r["stderr_sha256"]) for r in wall + rows("perf")}) == 1
base, head = pair(wall, lambda r: r["wall_ns"])
print(f"fresh wall, base {base/1e6:.3f} ms, candidate {head/1e6:.3f} ms")
if source_bytes:
    print(f"source GB/s {source_bytes/base:.6f} -> {source_bytes/head:.6f}")
for column in ("maxrss_kib", "minor_faults", "major_faults"):
    print(column, *pair(wall, lambda row: row[column]))
for r in sorted({r["name"].split("-")[1] for r in wall}):
    group = [row for row in wall if row["name"].split("-")[1] == r]
    b, h = pair(group, lambda row: row["wall_ns"])
    print(f"round {r} candidate - base {(h-b)/1e6:+.3f} ms")
perf = rows("perf")
for event in (("cycles:u", "cycles:k", "instructions:u", "minor-faults", "major-faults") if perf else ()):
    def counter(row):
        lines = (root / (row["name"] + ".perf")).read_text().splitlines()
        return next(int(fields[0]) for fields in (line.split(",") for line in lines) if len(fields) > 2 and fields[2] == event)
    print(event, *pair(perf, counter))
for mode in ("tree", "tree-sizes"):
    group = rows(mode)
    assert all(row["exit"] == 0 for row in group)
    b, h = pair(group, lambda row: stage_sample(row, "ns"))
    cb, ch = pair(group, lambda row: stage_sample(row, "cycles"))
    ib, ih = pair(group, lambda row: stage_sample(row, "instructions"))
    print(f"{mode} ns/token {b:.4f} -> {h:.4f}, cycles/token {cb:.3f} -> {ch:.3f}, instructions/token {ib:.3f} -> {ih:.3f}")
    payloads = [("parent bytes", 4 * tokens), ("published output bytes", (24 if mode == "tree-sizes" else 20) * tokens)]
    if source_bytes:
        payloads.append(("original source bytes", source_bytes))
    for name, size in payloads:
        print(f"  {name} GB/s {size/(tokens*b):.3f} -> {size/(tokens*h):.3f}")
stages = rows("stages")
if stages:
    def check_input_ms(row):
        data = (root / (row["name"] + ".stderr")).read_text()
        return float(re.search(r"^time-stage\tcheck-input\t([.\d]+)", data, re.MULTILINE)[1])
    print("check-input ms", *pair(stages, check_input_ms))
print("object", wall[0]["object_sha256"])

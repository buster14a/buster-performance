# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and README.md.
"""Post-capture data reduction only; never executes a compiler or archived helper."""
import csv
import itertools
import json
import pathlib
import re
import statistics

ROOT = pathlib.Path(__file__).resolve().parents[1]
RAW = ROOT / "raw" / "artifact"
DEPTHS = (500, 1000, 2000, 4000, 8000, 16000)
MODES = ("baseline", "vector", "scalar", "gcc")
rows = list(csv.DictReader((RAW / "measurements.csv").open()))
wanted = set(itertools.product(("expression", "type"), DEPTHS, MODES, range(3)))
observed = set()
groups = {}
for row in rows:
    form, depth, mode, repeat = row["form"], int(row["depth"]), row["mode"], int(row["repeat"])
    key = (form, depth, mode, repeat)
    assert key in wanted and key not in observed, key
    observed.add(key)
    wall, check = float(row["wall_ms"]), float(row["check_input_ms"])
    assert wall > 0 and (check == -1 if mode == "gcc" else check >= 0), key
    text = (RAW / f"{form}-{depth}.c-{mode}-{repeat}.log").read_text()
    assert "warning:" not in text and "error:" not in text, key
    stages = re.findall(r"^time-stage\tcheck-input\t([0-9.]+)\t", text, re.M)
    assert (text == "" and stages == []) if mode == "gcc" else len(stages) == 1 and float(stages[0]) == check, key
    groups.setdefault((form, depth, mode), []).append((wall, check))
assert observed == wanted and len(rows) == 144
summary = []
for form in ("expression", "type"):
    for depth in DEPTHS:
        source = "int x = " + "sizeof(" * depth + ("0" if form == "expression" else "int") + ")" * depth + ";\n"
        assert (RAW / f"{form}-{depth}.c").read_bytes() == source.encode()
        result = {"form": form, "depth": depth}
        for mode in MODES:
            samples = groups[(form, depth, mode)]
            wall = [sample[0] for sample in samples]
            check = [sample[1] for sample in samples]
            result[mode] = {
                "wall_median_ms": statistics.median(wall),
                "wall_min_ms": min(wall),
                "wall_max_ms": max(wall),
                "check_input_median_ms": None if mode == "gcc" else statistics.median(check),
            }
        summary.append(result)
print(json.dumps({"method": "median of three captured samples; not a new measurement", "rows": 144, "summary": summary}, indent=2))

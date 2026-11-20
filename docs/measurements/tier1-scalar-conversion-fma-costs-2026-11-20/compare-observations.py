# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Compare independent measurements with run zero, mirroring x86_zen5_reproduces."""
import argparse
import csv
import re
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("directory", type=Path)
parser.add_argument("--forms", type=Path, required=True)
parser.add_argument("--prefix", required=True)
parser.add_argument("--output", type=Path, required=True)
args = parser.parse_args()
forms = args.forms.read_text().splitlines()
args.output.mkdir(parents=True, exist_ok=True)
columns = ["latency", "throughput", "retired_ops", "flags_latency", "load_extra", "fp_ops", "pipes"]
def decode(file, form):
    text = file.read_text()
    lines = re.findall(r"^# row\s+X\((.*)\)", text, re.M)
    if len(lines) != 1:
        raise ValueError(file)
    fields = lines[0].split(", ")
    assert "/".join(fields[:2]) == form and len(fields) == 12, file
    vals = tuple(None if a == "U" else int(a, 0) for a in fields[2:9])
    masks = tuple(int(a, 0) for a in fields[9:])
    assert masks[0] | masks[1] | masks[2] == 0x7f, (file, masks)
    independent, = [line.split("\t") for line in text.splitlines() if line.startswith(form+"\tindependent\t")]
    return vals, masks, tuple(map(float, independent[2:5])), "    X(" + lines[0] + ")"
def differences(base, measured):
    table, masks, _, _ = base
    row, observed_masks, (_, lo, hi), _ = measured
    failures = [] if observed_masks == masks else ["masks"]
    for col, (a, b) in enumerate(zip(table[:6], row[:6])):
        if a == b:
            continue
        if a is None or b is None:
            failures.append(columns[col])
            continue
        if col == 1:
            tolerance = max(8, 0.10*a)
            span_ok = 0.9*lo-1/32 <= a/256 <= 1.1*hi+1/32
        elif col in (2, 5):
            tolerance = 32 + 0.05*a
            span_ok = False
        else:
            tolerance = max(128, 0.10*a)
            span_ok = False
        if abs(b-a) > tolerance and not span_ok:
            failures.append(columns[col])
    return failures
with (args.output/"independent-checks.tsv").open("w") as out, (args.output/"round-zero-rows.txt").open("w") as rows:
    writer = csv.writer(out, delimiter="\t", lineterminator="\n")
    writer.writerow(["form", "round", *columns, "measured", "derived", "absent", "independent_median", "independent_min", "independent_max", "required_differences", "pipe_difference"])
    for form in forms:
        data = [decode(args.directory/f"{args.prefix}-{r}-{form.replace('/', '-')}.out", form) for r in range(4)]
        rows.write(data[0][-1] + "\n")
        for r, record in enumerate(data):
            values, masks, span, _ = record
            mismatch = differences(data[0], record)
            writer.writerow([form, r, *("U" if a is None else a for a in values), *(hex(m) for m in masks), *span, ",".join(mismatch) if mismatch else "none", int(data[0][0][-1] != values[-1])])
            if mismatch:
                print(f"{form} round {r} differs in {','.join(mismatch)}")

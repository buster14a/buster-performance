import csv
import hashlib
import pathlib
import re
import statistics
import sys

root = pathlib.Path(sys.argv[1])

def counters(path):
    with path.open() as source:
        return {row[2]: float(row[0]) for row in csv.reader(source)
                if len(row) > 2 and row[2] in ("cycles:u", "instructions:u", "task-clock")}

def compiler_medians(path):
    pattern = r"^(default|compiler): median of 31: (\d+\.\d+) ms wall .*?, (\d+\.\d+) M user cycles, (\d+\.\d+) M user instructions"
    return {side: tuple(map(float, values)) for side, *values
            in re.findall(pattern, path.read_text(), re.M)}

def paired(base, head, divisor=1):
    return f"{base / divisor:,.3f} → {head / divisor:,.3f} ({(head / base - 1) * 100:+.2f}%)"

print("SQLite")
for pipeline in ("default", "no-direct"):
    medians = compiler_medians(root / f"sqlite-{pipeline}.txt")
    print(pipeline, *(paired(b, h) for b, h in zip(medians["compiler"], medians["default"])))

print("Warning fixture")
for mode in ("diagnostic-none", "diagnostic-caret"):
    print(mode)
    values = {}
    sample = {}
    for side in ("base", "head"):
        files = sorted((root / mode).glob(f"*-{side}.csv"))
        assert len(files) == 21
        rows = [counters(path) for path in files]
        values[side] = {k: statistics.median(row[k] for row in rows) for k in rows[0]}
        sample[side] = (root / mode / f"0-{side}.stderr").read_bytes()
        warning_count = len(re.findall(rb"^.*: warning:", sample[side], re.M))
        assert warning_count == 1024
        print(side, warning_count, len(sample[side]), hashlib.sha256(sample[side]).hexdigest())
    print("byte exact", sample["base"] == sample["head"])
    for key in ("task-clock", "cycles:u", "instructions:u"):
        print(key, paired(values["base"][key], values["head"][key], 1 if key == "task-clock" else 1e6))

print("Caret oracle")
for side in ("base", "head"):
    print(side, counters(root / f"oracle-{side}.csv"))
    print((root / f"oracle-{side}.txt").read_text().splitlines()[-1])

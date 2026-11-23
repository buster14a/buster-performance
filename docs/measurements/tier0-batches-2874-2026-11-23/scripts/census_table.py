#!/usr/bin/env python3
"""census_table.py CENSUS.txt [--cumulative]: Tier 0's passes by event, an entry (buster#2874).

Each line of CENSUS.txt is one run of the census harness: an event set, a stop (the pass Tier 0 stops after) and the
medians an entry of cycles, instructions and the set's four events. A pass's count is its stop's less the stop before's.
"""
import re
import sys

SETS = {
    "A": ["uops", "misp", "branches", "stl-conflict"],
    "B": ["loads", "stores", "stl-forward", "misal64"],
    "C": ["dc-fill", "dc-fill-l2", "dc-anyfill", "dtlb-miss"],
    "D": ["uop-decoder", "uop-opcache", "opcache-miss", "ic-miss"],
    "E": ["fe-empty-slot", "be-stall-slot", "noretire-cyc", "noretire-load"],
    "F": ["ucode-uops", "hwpf-fill", "lq-stall", "sq-stall"],
    "G": ["opq-empty", "noretire-empty", "noretire-notdone", "bp-redirect"],
    "H": ["fpsch-stall", "intprf-stall", "retq-stall", "l2btb-correct"],
    "I": ["uop512", "uop256", "uop128", "uop-scalarfp"],
}
PASSES = {
    0: "setup",
    1: "labels",
    2: "values (P0)",
    3: "fusion (P1, P2)",
    4: "depths (P3, P4)",
    5: "selection",
    6: "homes, frame",
    7: "measuring",
    8: "output room",
    9: "emission",
    10: "forms chosen",
    11: "forms applied",
    -1: "the rest",
}
ORDER = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -1]


def main():
    path = sys.argv[1]
    cumulative = "--cumulative" in sys.argv
    per_body = "--body" in sys.argv
    data = {}
    meta = {}
    for line in open(path):
        m = re.match(r"set=(\w)(\d) census: (.*)", line.strip())
        if not m:
            continue
        key = m.group(1)
        half = int(m.group(2)) - 1
        fields = dict(f.split("=") for f in m.group(3).split())
        stop = int(fields["stop"])
        meta = fields
        row = data.setdefault(stop, {})
        row.setdefault("cycles", []).append(float(fields["cycles"]))
        row.setdefault("instructions", []).append(float(fields["instructions"]))
        for i, name in enumerate(SETS[key][2 * half:2 * half + 2]):
            if f"e{i}" in fields:
                row[name] = float(fields[f"e{i}"])
    columns = ["cycles", "instructions"] + [n for k in "ABCDEFGHI" for n in SETS[k]]
    scale = 1.0
    if per_body:
        scale = float(meta["entries"]) / float(meta["functions"])
    values = {}
    for stop in ORDER:
        if stop not in data:
            continue
        row = data[stop]
        values[stop] = {}
        for c in columns:
            v = row.get(c)
            if isinstance(v, list):
                v = sorted(v)[len(v) // 2]
            values[stop][c] = (v if v is not None else float("nan")) * scale
    print(f"# {path}: entries={meta.get('entries')} functions={meta.get('functions')} records={meta.get('records')} loops={meta.get('loops')}; "
          f"{'a body' if per_body else 'an entry'}{', cumulative' if cumulative else ', by pass'}")
    shown = [s for s in ORDER if s in values]
    width = 16
    print(f"{'event':<{width}}" + "".join(f"{PASSES[s][:11]:>12}" for s in shown) + f"{'Tier 0':>12}")
    for c in columns:
        line = f"{c:<{width}}"
        previous = 0.0
        for s in shown:
            v = values[s][c]
            line += f"{(v if cumulative else v - previous):12.3f}"
            previous = v
        line += f"{values[shown[-1]][c]:12.3f}"
        print(line)


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""census_summary.py CENSUS.txt [--body]: each pass's cycles and where its dispatch slots went (buster#2874).

The 9700X dispatches eight uops a cycle. A pass's slots are eight times its cycles: retired uops, slots the front end
left empty, slots the back end stalled, and the rest (uops dispatched and not retired: a mispredicted path's)."""
import re
import sys

sys.path.insert(0, __file__.rsplit("/", 1)[0])
import census_table as t  # noqa: E402


def load(path):
    data = {}
    meta = {}
    for line in open(path):
        m = re.match(r"set=(\w)(\d) census: (.*)", line.strip())
        if not m:
            continue
        key, half = m.group(1), int(m.group(2)) - 1
        fields = dict(f.split("=") for f in m.group(3).split())
        stop = int(fields["stop"])
        meta = fields
        row = data.setdefault(stop, {})
        row.setdefault("cycles", []).append(float(fields["cycles"]))
        row.setdefault("instructions", []).append(float(fields["instructions"]))
        for i, name in enumerate(t.SETS[key][2 * half:2 * half + 2]):
            row[name] = float(fields[f"e{i}"])
    values = {}
    for stop, row in data.items():
        values[stop] = {k: (sorted(v)[len(v) // 2] if isinstance(v, list) else v) for k, v in row.items()}
    return values, meta


def main():
    path = sys.argv[1]
    per_body = "--body" in sys.argv
    values, meta = load(path)
    scale = float(meta["entries"]) / float(meta["functions"]) if per_body else 1.0
    shown = [s for s in t.ORDER if s in values]
    unit = "a body" if per_body else "an entry"
    print(f"{path}: {meta['functions']} functions, {meta['entries']} entries; {unit}")
    print("| pass | cycles | instructions | uops | retired | front end empty | back end stalled | mispredicted | op cache misses | L1I misses | uops from the decoder | L1D fills | store-to-load conflicts | microcoded uops |")
    print("| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |")
    previous = {}
    rows = []
    for s in shown + ["total"]:
        if s == "total":
            d = {k: values[shown[-1]][k] for k in values[shown[-1]]}
            name = "**Tier 0**"
        else:
            d = {k: values[s][k] - previous.get(k, 0.0) for k in values[s]}
            previous = values[s]
            name = t.PASSES[s]
        slots = 8.0 * d["cycles"]
        dispatched = d["uop-decoder"] + d["uop-opcache"]

        def share(x):
            return f"{100.0 * x / slots:.0f}%" if slots > 0 else "-"
        cells = [name, f"{d['cycles'] * scale:.2f}", f"{d['instructions'] * scale:.1f}", f"{d['uops'] * scale:.1f}", share(d["uops"]), share(d["fe-empty-slot"]),
                 share(d["be-stall-slot"]), f"{d['misp'] * scale:.3f}", f"{d['opcache-miss'] * scale:.2f}", f"{d['ic-miss'] * scale:.2f}",
                 f"{100.0 * d['uop-decoder'] / dispatched:.0f}%" if dispatched > 0 else "-", f"{d['dc-fill'] * scale:.2f}", f"{d['stl-conflict'] * scale:.3f}",
                 f"{d['ucode-uops'] * scale:.2f}"]
        print("| " + " | ".join(cells) + " |")


main()

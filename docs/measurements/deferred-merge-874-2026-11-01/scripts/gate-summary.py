#!/usr/bin/env python3
"""#874 gate summary: per-unit medians over rounds, and grouped statistics."""
import argparse
import re
import statistics

HEADING = re.compile(r"^== round (\d+) (\S+) (\S+) lanes (\d+)$")
WHOLE = re.compile(r"^checker-deferred:   lanes=(\d+) active=(\d+) copies=(\d+) whole=([0-9.]+) ")


def parse(path):
    rows = {}
    current = None
    for line in open(path, encoding="utf-8", errors="replace"):
        match = HEADING.match(line.rstrip("\n"))
        if match:
            round_, name, unit, lanes = match.groups()
            current = (int(round_), name, unit, int(lanes))
            continue
        if current is None:
            continue
        match = WHOLE.match(line)
        if match:
            lanes, active, copies, whole = match.groups()
            if int(lanes) != current[3]:
                continue
            rows[(current[0], current[1], current[2])] = (float(whole), int(active))
    return rows


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("log")
    parser.add_argument("--mode", required=True)
    args = parser.parse_args()
    rows = parse(args.log)
    units = sorted({u for (_, _, u) in rows})
    results = []
    for unit in units:
        control = [(r, rows[(r, f"control-{args.mode}", unit)]) for (r, n, u) in rows if n == f"control-{args.mode}" and u == unit]
        fix = [(r, rows[(r, f"fix-{args.mode}", unit)]) for (r, n, u) in rows if n == f"fix-{args.mode}" and u == unit]
        control.sort()
        fix.sort()
        ratios = []
        for (_, (c, _)), (_, (f, _)) in zip(control, fix):
            ratios.append((f / c - 1.0) * 100.0)
        if not ratios:
            continue
        active = fix[0][1][1]
        results.append((unit, active, statistics.median(ratios), min(ratios), max(ratios), len(ratios)))
    print(f"units={len(results)} mode={args.mode}")
    print(f"{'unit':24s} {'active':>6s} {'median%':>8s} {'min%':>8s} {'max%':>8s} {'rounds':>6s}")
    for unit, active, median, low, high, count in results:
        print(f"{unit:24s} {active:6d} {median:8.2f} {low:8.2f} {high:8.2f} {count:6d}")
    for label, predicate in (("active=1", lambda a: a == 1), ("active>1", lambda a: a > 1), ("all", lambda a: True)):
        group = [r for r in results if predicate(r[1])]
        if not group:
            continue
        medians = [r[2] for r in group]
        print(f"{label}: n={len(group)} median={statistics.median(medians):+.2f}% "
              f"range={min(medians):+.2f}%..{max(medians):+.2f}% over2={sum(1 for m in medians if m > 2.0)} "
              f"worst-round-over2={sum(1 for r in group if r[4] > 2.0)}")


if __name__ == "__main__":
    main()

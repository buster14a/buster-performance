#!/usr/bin/env python3
"""perf_table.py UNSTRIPPED DIR [--top N] [--match REGEX]: perf-symbols.sh's samples by function (buster#2874).

DIR holds EVENT.ips (count address) and events.txt (each event's period and runs). Prints each function's events a
run, in thousands, for the functions with the most cycles."""
import bisect
import re
import subprocess
import sys


def symbols(path):
    out = subprocess.run(["nm", "-S", "--defined-only", path], capture_output=True, text=True).stdout
    rows = []
    for line in out.splitlines():
        p = line.split()
        if len(p) == 4 and p[2] in "tTwW":
            rows.append((int(p[0], 16), int(p[1], 16), p[3]))
    rows.sort()
    return rows


def main():
    binary, directory = sys.argv[1], sys.argv[2]
    top = int(sys.argv[sys.argv.index("--top") + 1]) if "--top" in sys.argv else 40
    match = re.compile(sys.argv[sys.argv.index("--match") + 1]) if "--match" in sys.argv else None
    syms = symbols(binary)
    starts = [s[0] for s in syms]
    events = {}
    for line in open(f"{directory}/events.txt"):
        m = re.match(r"(\S+) period=(\d+) runs=(\d+)", line)
        events[m.group(1)] = (int(m.group(2)), int(m.group(3)))
    table = {}
    totals = {}
    for name, (period, runs) in events.items():
        for line in open(f"{directory}/{name}.ips"):
            count, address = line.split()
            a = int(address, 16)
            i = bisect.bisect_right(starts, a) - 1
            function = "?"
            if i >= 0 and a < syms[i][0] + max(syms[i][1], 1):
                function = syms[i][2].replace(".buster_split", "")
            v = int(count) * period / runs
            table.setdefault(function, {}).setdefault(name, 0.0)
            table[function][name] += v
            totals[name] = totals.get(name, 0.0) + v
    names = list(events)
    order = sorted(table, key=lambda f: -table[f].get("cycles", 0.0))
    if match:
        order = [f for f in order if match.search(f)]
    print(f"{'function':<44}" + "".join(f"{n[:12]:>13}" for n in names))
    print(f"{'(all, thousands a run)':<44}" + "".join(f"{totals.get(n, 0) / 1000:13.0f}" for n in names))
    shown = {n: 0.0 for n in names}
    for f in order[:top]:
        print(f"{f[:43]:<44}" + "".join(f"{table[f].get(n, 0) / 1000:13.1f}" for n in names))
        for n in names:
            shown[n] += table[f].get(n, 0)
    if match:
        print(f"{'(matched)':<44}" + "".join(f"{sum(table[f].get(n, 0) for f in order) / 1000:13.1f}" for n in names))


if __name__ == "__main__":
    main()

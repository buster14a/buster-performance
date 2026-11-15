#!/usr/bin/env python3
# tables.py RESULTS_DIRECTORY LABEL...: the facts' figures of each label's runs (results/LABEL/facts-CORPUS[-SETTING]-N.txt),
# as rows of a table: the median over a setting's runs of the kernel's cycles, instructions and mispredicted branches a
# taken leaf or lookup, and of a leaf's and a lookup's cycles, with the records, the taken shares and the differences
# of the first run. A leaf's and a lookup's cycles are their TSC ticks by the cycles a tick of the label's sqlite3.c
# runs: a unit as short as musl's files has its pass's counter reads in its cycles and not in its ticks, and its own
# ratio reads up to a fifth high (the same core and clock: 1.45 to 1.46 cycles a tick).
import glob
import os
import re
import statistics
import sys


def read(path):
    text = open(path, errors="replace").read()
    row = {}
    m = re.search(r"node-facts: records=(\d+) identifiers=(\d+) .*? literals=(\d+) lookups=(\d+) given=(\d+)", text)
    if m:
        row["records"], row["identifiers"], row["literals"], row["lookups"], row["given"] = map(int, m.groups())
    m = re.search(r"node-facts: taken identifiers=(\d+) \(([\d.]+)%\) lookups=(\d+) \(([\d.]+)%\) differences=(\d+)(?: list-differences=(\d+))? failures=(\d+)", text)
    if m:
        row["taken_identifiers"] = int(m.group(1))
        row["identifier_share"] = float(m.group(2))
        row["taken_lookups"] = int(m.group(3))
        row["lookup_share"] = float(m.group(4))
        row["differences"] = int(m.group(5))
        row["list_differences"] = int(m.group(6) or 0)
        row["failures"] = int(m.group(7))
    m = re.search(r"the kernel a taken leaf or lookup: cycles=([\d.]+) instructions=([\d.]+)(?: mispredicted-branches=([\d.]+))?", text)
    if m:
        row["cycles"] = float(m.group(1))
        row["instructions"] = float(m.group(2))
        row["mispredicts"] = float(m.group(3) or 0)
    m = re.search(r"TSC ticks \(([\d.]+) cycles a tick\): a leaf=([\d.]+) a lookup=([\d.]+); a window's second run: a leaf=([\d.]+) a lookup=([\d.]+)", text)
    if m:
        row["tick"] = float(m.group(1))
        row["leaf"] = float(m.group(2))
        row["lookup"] = float(m.group(3))
        row["leaf_again"] = float(m.group(4))
        row["lookup_again"] = float(m.group(5))
    m = re.search(r"time a taken leaf or lookup: cycles=([\d.]+) instructions=([\d.]+)", text)
    if m and "cycles" not in row:
        row["cycles"] = float(m.group(1))
        row["instructions"] = float(m.group(2))
    m = re.search(r"words rows=(\d+) .*? lines=(\d+) .*?member-slots=(\d+) windows=(\d+) widest=(\d+)", text)
    if m:
        row["rows"], row["lines"], row["slots"], row["windows"], row["widest"] = map(int, m.groups())
    row["status"] = re.findall(r"^status (\d+)", text, re.M)
    return row


def main():
    directory = sys.argv[1]
    for label in sys.argv[2:]:
        groups = {}
        for path in sorted(glob.glob(os.path.join(directory, label, "facts-*.txt"))):
            m = re.match(r"facts-([a-z0-9]+?)(-[a-z0-9]+)?-(\d+)\.txt$", os.path.basename(path))
            if m:
                groups.setdefault((m.group(1), m.group(2) or ""), []).append(read(path))
        ticks = [r["tick"] for (corpus, setting), rows in groups.items() if corpus == "sqlite3" for r in rows if "tick" in r]
        tick = statistics.median(ticks) if ticks else float("nan")
        print("## %s (%.3f cycles a tick)" % (label, tick))
        print("| corpus | windows | records | leaves taken | lookups taken | differences | cycles | instructions | mispredicted | a leaf | a lookup | a leaf again | a lookup again | runs |")
        print("| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |")
        for (corpus, setting), rows in sorted(groups.items()):
            first = rows[0]

            def median(key):
                values = [r[key] for r in rows if key in r]
                return statistics.median(values) if values else float("nan")

            differences = sum(r.get("differences", 0) + r.get("list_differences", 0) + r.get("failures", 0) for r in rows)
            print("| %s | %s | %s | %s (%.2f%%) | %s (%.2f%%) | %d | %.2f | %.2f | %.3f | %.2f | %.2f | %.2f | %.2f | %d |" % (
                corpus, setting.lstrip("-") or "a body", first.get("records", 0), first.get("taken_identifiers", 0), first.get("identifier_share", 0.0),
                first.get("taken_lookups", 0), first.get("lookup_share", 0.0), differences, median("cycles"), median("instructions"), median("mispredicts"),
                median("leaf") * tick, median("lookup") * tick, median("leaf_again") * tick, median("lookup_again") * tick, len(rows)))
        print()


main()

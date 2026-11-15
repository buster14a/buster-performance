#!/usr/bin/env python3
# summary.py RESULTS_DIRECTORY LABEL: the three kernels of a label side by side (results/LABEL/facts-CORPUS[-SETTING]-N.txt,
# the settings "", lean, loads, packed, leanpacked, loadspacked), medians over a setting's runs: the kernel's cycles a
# taken leaf or lookup and the same a record of the window, which is the figure the variants share a denominator of
# (a lean kernel makes no discard, so its taken lookups are fewer and dearer than the whole kernel's); then what a lean
# kernel left out and its rule derives, from each corpus's first lean run.
import glob
import os
import re
import statistics
import sys

SETTINGS = [("", "whole"), ("-lean", "lean"), ("-loads", "loads")]
WINDOWS = [("", "a body a window"), ("packed", "packed to 384 records")]
CORPORA = [("sqlite3", "`sqlite3.c`"), ("lua", "Lua"), ("musl", "musl")]


def figures(path):
    text = open(path, errors="replace").read()
    row = {}
    m = re.search(r"node-facts: (?:variant=\S+ )?records=(\d+) identifiers=(\d+) .*? literals=(\d+) lookups=(\d+) given=(\d+)", text)
    row["records"], row["identifiers"], row["lookups"] = int(m.group(1)), int(m.group(2)), int(m.group(4))
    m = re.search(r"node-facts: taken identifiers=(\d+) \(([\d.]+)%\) lookups=(\d+) \(([\d.]+)%\) differences=(\d+) list-differences=(\d+) failures=(\d+)", text)
    row["taken"] = int(m.group(1)) + int(m.group(3))
    row["taken_lookups"] = int(m.group(3))
    row["wrong"] = int(m.group(5)) + int(m.group(6)) + int(m.group(7))
    m = re.search(r"the kernel a taken leaf or lookup: cycles=([\d.]+) instructions=([\d.]+) mispredicted-branches=([\d.]+)", text)
    row["cycles"], row["instructions"], row["mispredicts"] = float(m.group(1)), float(m.group(2)), float(m.group(3))
    m = re.search(r"lookups by a short path=(\d+) .*? by their rule=(\d+)", text)
    if m:
        row["short"], row["ruled"] = int(m.group(1)), int(m.group(2))
    m = re.search(r"conversions=(\d+) derived=(\d+); discards=(\d+) derived=(\d+)", text)
    if m:
        row["conversions"], row["conversions_derived"], row["discards"], row["discards_derived"] = map(int, m.groups())
    m = re.search(r"lookups by their load alone=(\d+)", text)
    if m:
        row["loads"] = int(m.group(1))
    row["status"] = re.findall(r"^status (\d+)", text, re.M)
    return row


def main():
    directory, label = sys.argv[1], sys.argv[2]
    runs = {}
    for path in sorted(glob.glob(os.path.join(directory, label, "facts-*.txt"))):
        m = re.match(r"facts-([a-z0-9]+?)(-[a-z0-9]+)?-(\d+)\.txt$", os.path.basename(path))
        if m:
            runs.setdefault((m.group(1), m.group(2) or ""), []).append(figures(path))

    def median(corpus, setting, key):
        return statistics.median(r[key] for r in runs[(corpus, setting)])

    print("| | " + " | ".join(name for _, name in CORPORA) + " |")
    print("| --- |" + " ---: |" * len(CORPORA))
    for windows, title in WINDOWS:
        for suffix, variant in SETTINGS:
            setting = "-" + suffix.lstrip("-") + windows if suffix or windows else ""
            cells = []
            for corpus, _ in CORPORA:
                first = runs[(corpus, setting)][0]
                cycles = median(corpus, setting, "cycles")
                cells.append("%.1f (%.1f a record of the window; %.1f instructions, %.2f mispredicted)" % (
                    cycles, cycles * first["taken"] / first["records"], median(corpus, setting, "instructions"), median(corpus, setting, "mispredicts")))
            print("| %s, %s | %s |" % (title, variant, " | ".join(cells)))
    print()
    for corpus, name in CORPORA:
        lean = runs[(corpus, "-lean")][0]
        loads = runs[(corpus, "-loads")][0]
        wrong = sum(r["wrong"] for rows in runs.values() for r in rows)
        statuses = sorted({s for rows in runs.values() for r in rows for s in r["status"]})
        print("%s: records=%d leaves=%d lean lookups=%d taken=%d short=%d ruled=%d conversions=%d derived=%d discards=%d derived=%d loads-alone=%d; every run's differences=%d statuses=%s" % (
            name, lean["records"], lean["identifiers"], lean["lookups"], lean["taken_lookups"], lean["short"], lean["ruled"], lean["conversions"], lean["conversions_derived"],
            lean["discards"], lean["discards_derived"], loads["loads"], wrong, ",".join(statuses)))


main()

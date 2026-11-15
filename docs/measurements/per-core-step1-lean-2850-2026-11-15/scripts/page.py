#!/usr/bin/env python3
# page.py RESULTS_DIRECTORY LABEL PASSES [BEFORE BEFORE_PASSES]: the design page's tables of the follow-up from a
# label's runs and profiles: the three kernels' cycles a taken leaf or lookup (and a record of the window) with their
# mispredicted branches, by corpus and window setting; the kernels by part on sqlite3.c, packed, side by side
# (parts.py's figures); and, with BEFORE (an earlier label that has the lean kernel's profile, of BEFORE_PASSES passes
# a run), the lean kernel's parts before and after.
import glob
import os
import re
import statistics
import sys

PERIODS = {"cycles": 200003, "instructions": 400009, "branch-misses": 1009}
CORPORA = ["sqlite3", "lua", "musl"]
VARIANTS = [("", "whole"), ("lean", "lean"), ("loads", "loads")]


def figures(path):
    text = open(path, errors="replace").read()
    row = {}
    m = re.search(r"node-facts: (?:variant=\S+ )?records=(\d+) identifiers=(\d+)", text)
    row["records"], row["identifiers"] = int(m.group(1)), int(m.group(2))
    m = re.search(r"node-facts: taken identifiers=(\d+) \(([\d.]+)%\) lookups=(\d+)", text)
    row["taken"] = int(m.group(1)) + int(m.group(3))
    m = re.search(r"the kernel a taken leaf or lookup: cycles=([\d.]+) instructions=([\d.]+) mispredicted-branches=([\d.]+)", text)
    row["cycles"], row["instructions"], row["mispredicts"] = float(m.group(1)), float(m.group(2)), float(m.group(3))
    return row


def samples(path):
    found = {}
    for line in open(path, errors="replace"):
        m = re.match(r"\s*[\d.]+%\s+(\d+)\s+\[\.\]\s+(\S+)", line)
        if m:
            found[m.group(2)] = int(m.group(1))
    return found


def parts(directory, label, passes, variant):
    suffix = "-" + (variant or "whole")
    loop = "_" + variant if variant else ""
    names = [
        ("lists", "node_facts_window", "records"),
        ("leaf", "node_facts_leaves" + ("_lean" if variant else ""), "identifiers"),
        ("discard", "node_facts_discards", "discard"),
        ("->", "node_facts_arrows" + loop, "->"),
        (".", "node_facts_dots" + loop, "."),
        ("*", "node_facts_dereferences" + loop, "*"),
        ("[]", "node_facts_subscripts" + loop, "[]"),
        ("call", "node_facts_calls" + loop, "call"),
    ]
    runs = 3 * passes + 1
    text = open("%s/%s/profile-run-cycles%s.txt" % (directory, label, suffix), errors="replace").read()
    counts = {}
    m = re.search(r"records=(\d+) identifiers=(\d+)", text)
    counts["records"], counts["identifiers"] = int(m.group(1)), int(m.group(2))
    for m in re.finditer(r"node-facts: lookup=(\S+) records=(\d+) left=(\d+)", text):
        counts[m.group(1)] = int(m.group(2))
    profiles = {event: samples("%s/%s/profile-%s%s.txt" % (directory, label, event, suffix)) for event in PERIODS}
    found = {}
    for name, symbol, key in names:
        count = counts.get(key, 0)
        if count and symbol in profiles["cycles"]:
            found[name] = (count,) + tuple(profiles[event].get(symbol, 0) * PERIODS[event] / runs / count for event in ("cycles", "instructions", "branch-misses"))
    return found


def main():
    directory, label, passes = sys.argv[1], sys.argv[2], int(sys.argv[3])
    before = sys.argv[4] if len(sys.argv) > 4 else None
    before_passes = int(sys.argv[5]) if len(sys.argv) > 5 else passes
    runs = {}
    for path in sorted(glob.glob(os.path.join(directory, label, "facts-*.txt"))):
        m = re.match(r"facts-([a-z0-9]+?)(-[a-z0-9]+)?-(\d+)\.txt$", os.path.basename(path))
        if m:
            runs.setdefault((m.group(1), (m.group(2) or "").lstrip("-")), []).append(figures(path))

    def median(corpus, setting, key):
        return statistics.median(r[key] for r in runs[(corpus, setting)])

    for windows, title in (("", "**a body a window:**"), ("packed", "**windows packed to 384 records:**")):
        for variant, name in VARIANTS:
            cells = []
            for corpus in CORPORA:
                setting = variant + windows
                first = runs[(corpus, setting)][0]
                cycles = median(corpus, setting, "cycles")
                cells.append("%.1f (%.1f)" % (cycles, cycles * first["taken"] / first["records"]))
            print("| %s%s | %s |" % (title + " " if name == "whole" else "", name, " | ".join(cells)))
        cells = [", ".join("%.2f" % median(corpus, variant + windows, "mispredicts") for variant, _ in VARIANTS) for corpus in CORPORA]
        print("| mispredicted branches: whole, lean, loads | %s |" % " | ".join(cells))
    print()
    tables = {name: parts(directory, label, passes, variant) for variant, name in VARIANTS}
    print("| part | of them | whole | lean | loads |")
    print("| --- | ---: | ---: | ---: | ---: |")
    titles = [("lists", "the lists, the classes' mask and the batches, a record of the window"), ("leaf", "a leaf"), ("discard", "a discard"), ("->", "`->`"), (".", "`.`"),
              ("*", "`*`"), ("[]", "a subscript"), ("call", "a call")]
    for key, title in titles:
        count = max((tables[name][key][0] for _, name in VARIANTS if key in tables[name]), default=0)
        cells = []
        for _, name in VARIANTS:
            row = tables[name].get(key)
            cells.append("%.1f (%.0f; %.2f)" % (row[1], row[2], row[3]) if row else "given" if key == "discard" else "")
        print("| %s | %s | %s |" % (title, "{:,}".format(count), " | ".join(cells)))
    if before:
        print()
        old = parts(directory, before, before_passes, "lean")
        new = tables["lean"]
        print("| the lean kernel's | cycles before | after | mispredicted branches before | after |")
        print("| --- | ---: | ---: | ---: | ---: |")
        for key, title in titles[3:]:
            if key in old and key in new:
                print("| %s | %.1f | %.1f | %.2f | %.2f |" % (title, old[key][1], new[key][1], old[key][3], new[key][3]))


main()

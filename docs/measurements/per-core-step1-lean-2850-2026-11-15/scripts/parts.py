#!/usr/bin/env python3
# parts.py RESULTS_DIRECTORY LABEL PASSES [VARIANT]: the kernel's cost by part, from profile.sh's three profiles of a
# label (results/LABEL/profile-{cycles,instructions,branch-misses}[-VARIANT].txt, the kernel's functions' samples) and
# the counts of its profiled run (results/LABEL/profile-run-cycles[-VARIANT].txt). VARIANT is whole, lean or loads
# (profiles.sh's names), or nothing for the whole kernel's files as step 1 named them. A profiled run makes the kernel run over the unit 3 * PASSES + 1 times: PASSES counted,
# PASSES twice with the parts' ticks apart, and the checked pass (the loads' kernel's checked pass runs the lean kernel
# once more, which is one run in 122 of the parts the two share).
import re
import sys

PERIODS = {"cycles": 200003, "instructions": 400009, "branch-misses": 1009}


def samples(path):
    found = {}
    for line in open(path, errors="replace"):
        m = re.match(r"\s*[\d.]+%\s+(\d+)\s+\[\.\]\s+(\S+)", line)
        if m:
            found[m.group(2)] = int(m.group(1))
    return found


def main():
    directory, label, passes = sys.argv[1], sys.argv[2], int(sys.argv[3])
    variant = sys.argv[4] if len(sys.argv) > 4 else ""
    suffix = "-" + variant if variant else ""
    variant = "" if variant == "whole" else variant
    loop = "_" + variant if variant else ""
    parts = [
        ("the lists, the classes' mask and the batches, a record of the window", "node_facts_window", "records"),
        ("a leaf", "node_facts_leaves" + ("_lean" if variant else ""), "identifiers"),
        ("->", "node_facts_arrows" + loop, "->"),
        (".", "node_facts_dots" + loop, "."),
        ("*", "node_facts_dereferences" + loop, "*"),
        ("a subscript", "node_facts_subscripts" + loop, "[]"),
        ("a call", "node_facts_calls" + loop, "call"),
        ("a lookup by its rule", "node_facts_slow", None),
    ]
    if not variant:
        parts.insert(2, ("a discard", "node_facts_discards", "discard"))
    runs = 3 * passes + 1
    text = open("%s/%s/profile-run-cycles%s.txt" % (directory, label, suffix), errors="replace").read()
    counts = {}
    m = re.search(r"records=(\d+) identifiers=(\d+)", text)
    counts["records"], counts["identifiers"] = int(m.group(1)), int(m.group(2))
    for m in re.finditer(r"node-facts: lookup=(\S+) records=(\d+) left=(\d+)", text):
        counts[m.group(1)] = int(m.group(2))
    profiles = {event: samples("%s/%s/profile-%s%s.txt" % (directory, label, event, suffix)) for event in PERIODS}
    print("| part | of them | cycles each | instructions | mispredicted branches |")
    print("| --- | ---: | ---: | ---: | ---: |")
    for name, symbol, key in parts:
        count = counts.get(key, 0) if key else 0
        cells = []
        for event in ("cycles", "instructions", "branch-misses"):
            total = profiles[event].get(symbol, 0) * PERIODS[event] / runs
            cells.append("%.2f" % (total / count) if count else "%.0f a run of the unit" % total)
        print("| %s | %s | %s |" % (name, count if count else "", " | ".join(cells)))
    kernel = sum(profiles["cycles"].get(symbol, 0) for _, symbol, _ in parts) * PERIODS["cycles"] / runs
    print()
    print("the kernel's functions: %.2f M cycles a run of the unit (%d runs)" % (kernel / 1e6, runs))


main()

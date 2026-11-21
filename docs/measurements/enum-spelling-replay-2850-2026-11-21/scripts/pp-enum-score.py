"""Pair retired work and elapsed time within each interleaved two-binary rotation."""
import re
import sys
from collections import defaultdict
from pathlib import Path
from statistics import median

root = Path(sys.argv[1])
studies = sys.argv[2:] or ["enum-time", "tagplace-time", "enumclass-time",
                           "enumprod-time", "enum-current", "enumqueue-time"]
fields = ("rounds", "parent", "candidate", "median paired %", "minimum %", "maximum %")
print("study", "source", "metric", *fields, sep="\t")
for study in studies:
    folder = root / study
    if not (folder / "status").is_file():
        continue
    data = defaultdict(lambda: defaultdict(dict))
    hashes = defaultdict(set)
    for row in (folder / "status").read_text().splitlines():
        round_no, source, pos, label = row.split()
        sample = folder / f"{round_no}-{source}-{pos}-{label}"
        mass = defaultdict(list)
        for line in sample.with_suffix(".wall").read_text().splitlines():
            match = re.match(r"run \d+ list 1: ([\d.]+) ms wall.*?, (\d+) KiB wait4 peak, (\d+) minor faults, \d+ major, (\d+) user cycles, (\d+) instructions, status 0", line)
            if match:
                for name, x in zip(("external wall ms", "wait4 KiB", "external minor faults", "external user cycles", "external instructions"), match.groups()):
                    mass[name].append(float(x))
        assert len(mass["external wall ms"]) == 2, sample
        for line in sample.with_suffix(".stages").read_text().splitlines():
            v = line.split("\t")
            if v[0] == "time-stage" and v[1] in ("preprocess", "parse", "check-program", "check-input", "total"):
                mass[v[1] + " ms"].append(float(v[2]))
        counts = {}
        for line in sample.with_suffix(".perf").read_text().splitlines():
            v = line.split(";")
            if len(v) > 2 and v[0].isdigit():
                counts[v[2]] = int(v[0])
        counts["cycles:u+k"] = counts["cycles:u"] + counts["cycles:k"]
        for event, amount in counts.items():
            mass[event] = [amount]
        hashes[source].add(sample.with_suffix(".sha256").read_text().strip())
        for name, vals in mass.items():
            data[source, name][round_no][label] = median(vals)
    for source, elfs in hashes.items():
        assert len(elfs) == 1, (study, source, elfs)
    a,b = ("before","after") if study == "enum-current" else ("base","cand")
    for (source, name), rounds in data.items():
        pairs = [(x[a], x[b]) for x in rounds.values() if a in x and b in x]
        if not pairs: continue
        pct = [100*(y/x-1) for x,y in pairs if x]
        measures = [median(x for x,y in pairs),median(y for x,y in pairs)]
        measures += [median(pct),min(pct),max(pct)] if pct else [0.,0.,0.]
        print(study,source,name,len(pairs),*(f"{v:.3f}" for v in measures),sep="\t")

# The Zen 4 counters of local/zen4-counters, normalized by each run's own instructions (benchmark-ir calibrates its
# repetitions by time, so whole runs differ in work): events per 1000 instructions, the median of three runs per tree,
# each set of runs apart (they ran at different times of the laptop's load).
# q786-*: two groups of events, A and B; s786-*: restarts, fused instructions, store-to-load events; b786-*: branches.
import collections, glob, os, re, statistics
root = os.path.join(os.path.dirname(__file__), "..", "local", "zen4-counters")
rates = collections.defaultdict(list)
for path in sorted(glob.glob(os.path.join(root, "*.csv"))):
    name = os.path.basename(path)
    m = re.match(r'(q786|s786|b786)-(old|main)-(?:(\d+)-)?(?:([AB])-)?(\d)\.csv$', name)
    if not m:
        continue
    kind, tree, size, group, run = m.groups()
    events = {}
    for line in open(path):
        fields = line.strip().split(",")
        if len(fields) > 3 and fields[0].isdigit():
            events[fields[2]] = float(fields[0])
    instructions = events["instructions:u"]
    for event, value in events.items():
        if event != "instructions:u":
            rates[(kind + (group or ""), size or "262144", event, tree)].append(value / instructions * 1000)
for runs, size, event in sorted(set((r, s, e) for r, s, e, _ in rates)):
    old = statistics.median(rates[(runs, size, event, "old")])
    main = statistics.median(rates[(runs, size, event, "main")])
    print(f"{runs:5s} {size:>7} {event:50s} old {old:10.3f} main {main:10.3f} {main / old - 1:+7.1%}")

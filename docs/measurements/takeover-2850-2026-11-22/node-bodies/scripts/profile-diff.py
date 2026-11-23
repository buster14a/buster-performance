#!/usr/bin/env python3
# profile-diff.py OLD_GLOB NEW_GLOB [TOP]: perf reports by symbol (overhead, period, symbol), mean cycles a run, new less old.
import sys, re, glob, collections
def load(pattern):
    files = sorted(glob.glob(pattern)); prof = collections.defaultdict(float)
    for p in files:
        for line in open(p):
            m = re.match(r"\s*([\d.]+)%\s+(\d+)\s+\[(.)\]\s+(.*)$", line)
            if m: prof[("k " if m.group(3) == "k" else "") + re.split(r"\s{2,}", m.group(4).strip())[0]] += float(m.group(2))
    return {k: v / max(len(files), 1) for k, v in prof.items()}, len(files)
old, n_old = load(sys.argv[1]); new, n_new = load(sys.argv[2]); top = int(sys.argv[3]) if len(sys.argv) > 3 else 40
rows = sorted(((new.get(n, 0) - old.get(n, 0), old.get(n, 0), new.get(n, 0), n) for n in set(old) | set(new)))
to, tn = sum(old.values()), sum(new.values())
print(f"runs {n_old} and {n_new}; cycles a run {to/1e6:.1f} M -> {tn/1e6:.1f} M, {(tn-to)/1e6:+.1f} M ({(tn-to)/5.49e6:+.2f} ms at 5.49 GHz)")
print("-- grows most")
for d, o, n, name in rows[::-1][:top]: print(f"{d/1e6:+8.2f} {d/5.49e6:+6.2f} ms  {o/1e6:7.2f} -> {n/1e6:7.2f}  {name[:80]}")
print("-- shrinks most")
for d, o, n, name in rows[:top]: print(f"{d/1e6:+8.2f} {d/5.49e6:+6.2f} ms  {o/1e6:7.2f} -> {n/1e6:7.2f}  {name[:80]}")

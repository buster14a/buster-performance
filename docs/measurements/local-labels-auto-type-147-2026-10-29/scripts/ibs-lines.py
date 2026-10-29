# Compares ibs-reports.sh's reports of the base (d11a91d2) and the head (af2d9a9b): samples per run (the mean of four)
# by symbol over the whole program, and by source line in check_input_resolve_range and check_input_specifiers, each
# head line mapped to the base's where the two files' lines are equal (difflib), so that the head's samples split into
# those on lines the branch added or changed and those on lines it didn't. Usage: ibs-lines.py REPORTS BASE HEAD, the
# last two the trees' source directories.
import collections, difflib, glob, os, re, sys

reports, trees = sys.argv[1], {"base": sys.argv[2], "head": sys.argv[3]}

def load(kind, tree):
    total = collections.Counter()
    files = sorted(glob.glob(f"{reports}/report-{kind}-{tree}-*.txt"))
    for name in files:
        for line in open(name):
            m = re.match(r"\s*(\d+)\s+(?:\[\.\]\s+)?(\S+)", line)
            if m:
                total[m.group(2)] += int(m.group(1))
    return {k: v / len(files) for k, v in total.items()}, len(files)

base, runs_base = load("symbols", "base")
head, runs_head = load("symbols", "head")
print(f"By symbol, the mean of {runs_base} and {runs_head} runs: base {sum(base.values()):.1f} samples, "
      f"head {sum(head.values()):.1f} ({sum(head.values()) - sum(base.values()):+.1f})")
deltas = sorted(((head.get(k, 0) - base.get(k, 0), k) for k in set(base) | set(head)), reverse=True)
for v, k in deltas[:8]:
    print(f"  {v:+8.1f}  {k}")
print("  ...")
for v, k in deltas[-6:]:
    print(f"  {v:+8.1f}  {k}")

base, _ = load("lines", "base")
head, _ = load("lines", "head")
print(f"\nBy line in check_input_resolve_range and check_input_specifiers: base {sum(base.values()):.1f} samples, "
      f"head {sum(head.values()):.1f} ({sum(head.values()) - sum(base.values()):+.1f})")
files = sorted({k.rpartition(":")[0] for k in set(base) | set(head)})
unchanged = collections.Counter()
for name in files:
    paths = {t: os.path.join(trees[t], "src/buster/compiler", name) for t in trees}
    text = {t: open(paths[t]).read().split("\n") if os.path.exists(paths[t]) else [] for t in trees}
    mapping = {}
    for tag, i1, i2, j1, j2 in difflib.SequenceMatcher(None, text["base"], text["head"], autojunk=False).get_opcodes():
        if tag == "equal":
            for k in range(i2 - i1):
                mapping[j1 + k + 1] = i1 + k + 1
    sums = collections.Counter()
    for k, v in head.items():
        file, _, number = k.rpartition(":")
        if file != name:
            continue
        number = int(number)
        if number == 0:
            sums["no line"] += v
        elif number in mapping:
            sums["unchanged"] += v
            unchanged[(name, mapping[number])] += v
        else:
            sums["added or changed"] += v
    for k, v in base.items():
        file, _, number = k.rpartition(":")
        if file == name:
            sums["base, no line" if number == "0" else "base, numbered"] += v
            if number != "0":
                unchanged[(name, int(number))] -= v
    print(f"  {name}: head {sums['added or changed']:.1f} on added or changed lines, {sums['unchanged']:.1f} on "
          f"unchanged lines (base {sums['base, numbered']:.1f}), {sums['no line']:.1f} without a line "
          f"(base {sums['base, no line']:.1f})")
print("\nThe unchanged lines whose samples changed most, head less base, at the base's line:")
ranked = sorted(((v, k) for k, v in unchanged.items()), reverse=True)
for item in ranked[:6]:
    v, (name, number) = item
    print(f"  {v:+7.1f}  {name}:{number}")
print("  ...")
for item in ranked[-4:]:
    v, (name, number) = item
    print(f"  {v:+7.1f}  {name}:{number}")

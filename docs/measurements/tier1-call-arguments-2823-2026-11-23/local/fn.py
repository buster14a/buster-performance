# fn.py BASE_DIR NEW_DIR: per-function instruction counts of each program's callgrind output in both directories,
# ??? addresses named by the executable's symbols (PIE at 0x108000 under valgrind), recursion levels merged; prints rises
# and falls per program and the totals.
import re, subprocess, sys
def table(d, p, exe):
    syms = {}
    for line in subprocess.run(["nm", exe], capture_output=True, text=True).stdout.splitlines():
        f = line.split()
        if len(f) == 3 and f[1] in "tT":
            syms[int(f[0], 16) + 0x108000] = f[2]
    out = subprocess.run(["callgrind_annotate", "--threshold=100", "--auto=no", f"{d}/cg-{p}.out"], capture_output=True, text=True).stdout
    total = {}
    for line in out.splitlines():
        m = re.match(r"\s*([\d,]+)\s+\([^)]*\)\s+(\S+)", line)
        if not m or "PROGRAM" in line:
            continue
        n = int(m.group(1).replace(",", "")); f = re.sub(r"'\d+$", "", m.group(2))
        a = re.match(r"\?\?\?:0x([0-9a-f]+)", f)
        f = syms.get(int(a.group(1), 16), f) if a else f.split(":")[-1]
        total[f] = total.get(f, 0) + n
    return total
for p in ["speedtest1", "arithmetic", "calls", "closures", "strings", "tables"]:
    exe = "speedtest1" if p == "speedtest1" else "lua"
    b = table(sys.argv[1], p, f"{sys.argv[1]}/{exe}"); n = table(sys.argv[2], p, f"{sys.argv[2]}/{exe}")
    diffs = sorted(((n.get(f, 0) - b.get(f, 0), f, b.get(f, 0)) for f in set(b) | set(n)))
    print(f"== {p}: {sum(b.values())} -> {sum(n.values())}")
    print("  rises:", [(d, f) for d, f, _ in diffs if d > 0 and not f.startswith("???")][-6:][::-1])
    print("  falls:", [(d, f) for d, f, _ in diffs if d < 0][:6])

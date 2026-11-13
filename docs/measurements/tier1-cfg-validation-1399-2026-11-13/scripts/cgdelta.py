# Self cost by function, head minus base, from callgrind_annotate's tables: cgdelta.py BASE.txt HEAD.txt
import re, sys
def load(path):
    d = {}
    for line in open(path):
        m = re.match(r"\s*([\d,]+) \([\s\d.]+%\)\s+(\S+?):(\S+)", line)
        if m and "PROGRAM" not in line:
            d[m.group(3)] = d.get(m.group(3), 0) + int(m.group(1).replace(",", ""))
    return d
b, h = load(sys.argv[1]), load(sys.argv[2])
print(f"total\t{(sum(h.values()) - sum(b.values())) / 1e6:+.3f}M")
for d, k in sorted(((h.get(k, 0) - b.get(k, 0), k) for k in set(b) | set(h))):
    if abs(d) > 30000:
        print(f"{k}\t{d / 1e6:+.3f}M\tbase {b.get(k, 0) / 1e6:.2f}M")

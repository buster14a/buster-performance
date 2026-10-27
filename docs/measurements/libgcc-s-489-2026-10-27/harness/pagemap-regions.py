import sys, subprocess, bisect
binary, pages = sys.argv[1], sys.argv[2]
syms = []
for line in subprocess.run(["nm", "-S", "--defined-only", binary], capture_output=True, text=True).stdout.splitlines():
    p = line.split()
    if len(p) == 4 and p[2] in "bBdD":
        syms.append((int(p[0], 16), int(p[1], 16), p[3]))
syms.sort()
present = sorted(int(x, 16) for x in open(pages))
regions = {}
for a in present:
    regions.setdefault(a >> 21, []).append(a)
starts = [s[0] for s in syms]
for r, ps in sorted(regions.items()):
    lo, hi = r << 21, (r + 1) << 21
    # symbols that own a present page in this region
    owners = {}
    for a in ps:
        i = bisect.bisect_right(starts, a + 4095) - 1
        while i >= 0 and syms[i][0] + max(syms[i][1], 1) > a:
            if syms[i][0] < a + 4096: owners[syms[i][2]] = syms[i][1]
            i -= 1
    big = sorted(owners.items(), key=lambda kv: -kv[1])[:4]
    print("%x: %4d pages; %d symbols, largest %s" % (lo, len(ps), len(owners), ", ".join("%s (%d)" % kv for kv in big)))

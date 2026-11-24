# Functions of a raw profile by entry count, with how much of each call does anything past its first region:
# total counts / entry, and the largest non-entry counter / entry. Usage: selectivity.py PROFILE [MIN_ENTRY] [TOP]
import sys
sys.path.insert(0, __file__.rsplit('/', 1)[0])
from byfunc import load
w, counters, funcs = load(sys.argv[1])
delta = w[13] if w[13] < (1 << 63) else w[13] - (1 << 64)
rows = []
for name, n, cptr, i in funcs:
    s = (cptr + i * 72 - delta) // 8
    c = counters[s:s + n]
    if n and c[0]:
        rows.append((c[0], sum(c), max(c[1:]) if n > 1 else 0, n, name))
minimum = int(sys.argv[2]) if len(sys.argv) > 2 else 20000
top = int(sys.argv[3]) if len(sys.argv) > 3 else 60
total = sum(counters)
rows = [r for r in rows if r[0] >= minimum]
rows.sort(key=lambda r: -r[1])
print('total counts', total, 'functions entered at least', minimum, 'times:', len(rows))
print('%10s %11s %6s %7s %7s  %s' % ('entered', 'counts', 'share', 'per', 'maxrest', 'function'))
for e, t, m, n, name in rows[:top]:
    print('%10d %11d %5.1f%% %7.1f %7.2f  %s' % (e, t, 100 * t / total, t / e, m / e, name[:70]))

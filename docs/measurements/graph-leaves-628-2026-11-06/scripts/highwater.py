# highwater.py DUMP BINARY STAGE LO HI: the pushes into [LO, HI) in order (alloc lines of the STAGE dump), with each push's
# start and end as MB from LO, marking those that raise the high-water; the sites by the first frame outside lane.c.
import subprocess, sys
dump, binary, stage, lo, hi = sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4], 16), int(sys.argv[5], 16)
text = open(dump).read()
text = text[:text.index('end ' + stage)]
text = text[text.rindex(stage + ' VmHWM'):]
lines = [l.split() for l in text.split('\n') if l.startswith('alloc')]
lines = [l for l in lines if lo <= int(l[2], 16) < hi]
addresses = sorted({f for l in lines for f in l[l.index('frames') + 1:]})
symbols = {}
for a in addresses:
    r = subprocess.run(['addr2line', '-f', '-i', '-e', binary, hex(int(a, 16) - 1)], capture_output=True, text=True).stdout.strip().split('\n')
    symbols[a] = [(r[i], r[i + 1].split('/')[-1].split(' ')[0]) for i in range(0, len(r) - 1, 2)]
high = 0
for l in lines:
    frames = [x for f in l[l.index('frames') + 1:] for x in symbols[f]]
    kept = [(fn, loc) for fn, loc in frames if not loc.startswith('lane.c') and fn != 'check_graph_column']
    key = kept[0] if kept else frames[0]
    begin = (int(l[2], 16) - lo) / 1048576
    end = begin + int(l[4]) / 1048576
    mark = '*' if end > high else ' '
    high = max(high, end)
    if int(l[4]) >= 256 * 1024 or mark == '*':
        print(f'{l[1]:>6} {mark} {begin:7.2f} {end:7.2f} {int(l[4]) / 1048576:6.2f}  {key[0]} {key[1]}')

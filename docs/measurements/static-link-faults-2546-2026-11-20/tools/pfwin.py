import sys, re, collections
exec(open(sys.argv[0].replace('pfwin.py','pfparse.py')).read())
samples, mmaps = parse(sys.argv[1])
first = next(i for i, s in enumerate(samples) if any('bind_end' in f for f in s['chain']))
# go back to find samples after check_data_publish/debug ... print a window
lo = max(0, first - int(sys.argv[2]))
hi = int(sys.argv[3]) if len(sys.argv) > 3 else len(samples)
for s in samples[lo:hi]:
    mp = mapping(mmaps, s['addr'], s['t'])
    print('%.6f %x %s | %s' % (s['t'], s['addr'], (mp[2] + ' ' + hex(mp[0])) if mp else 'brk?', ' < '.join(s['chain'][:6])))

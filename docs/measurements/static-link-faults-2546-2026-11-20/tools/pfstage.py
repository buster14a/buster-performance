import sys, collections
sys.path.insert(0, sys.argv[0].rsplit('/', 1)[0])
from pfparse import parse, mapping
samples, mmaps = parse(sys.argv[1])
# the executable stage: from the first sample under bind_end to the first under executable_write/check_driver_write_main
def has(s, names):
    return any(any(n in f for n in names) for f in s['chain'])
first = next(i for i, s in enumerate(samples) if has(s, ['bind_end']))
end = next(i for i, s in enumerate(samples) if i > first and has(s, ['check_driver_write_main', 'executable_write', 'lane_run']))
win = samples[first:end]
print('window samples', len(win), 'from', win[0]['t'], 'to', win[-1]['t'])
bymap = collections.Counter(); byfn = collections.Counter(); both = collections.Counter()
pages = collections.defaultdict(set)
for s in win:
    mp = mapping(mmaps, s['addr'], s['t'])
    key = '%s %s 0x%x(+0x%x)' % (mp[2], mp[3], mp[0], mp[1] - mp[0]) if mp else 'brk/heap? %x' % s['addr']
    bymap[key] += 1
    # the innermost frame that is not memcpy/memset/inlined helper
    fn = ' < '.join(s['chain'][:3])
    both[(key, fn)] += 1
    pages[key].add(s['addr'] >> 12)
for k, v in bymap.most_common(): print('%5d %s  distinct pages %d' % (v, k, len(pages[k])))
print('--- by mapping and top frames')
for k, v in both.most_common(60): print('%5d %s | %s' % (v, k[0].split()[0] + ' ' + k[0].split()[-1], k[1]))

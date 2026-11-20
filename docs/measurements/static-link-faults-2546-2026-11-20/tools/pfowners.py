import sys, collections
# pfowners.py PERF_SCRIPT_TXT: the `executable` stage's page faults by mapping, with who owns each mapping.
# Written when the record was assembled (2026-11-20), over the perf script outputs the session left; it uses pfparse.py.
# The window is pfstage.py's: from the first fault under bind_end to the first under check_driver_write_main,
# executable_write or lane_run. A mapping's owner is told by the binding or link function that faulted it first in the
# whole process (link_push_column: the link's columns, pushed by link_initialize; bind_begin: Bind's arrays), or by
# its file; an anonymous mapping that only the joins' copies fault is the program's byte arena.
sys.path.insert(0, sys.argv[0].rsplit('/', 1)[0])
from pfparse import parse, mapping
samples, mmaps = parse(sys.argv[1])
def has(s, names):
    return any(any(n in f for n in names) for f in s['chain'])
first = next(i for i, s in enumerate(samples) if has(s, ['bind_end']))
end = next(i for i, s in enumerate(samples) if i > first and has(s, ['check_driver_write_main', 'executable_write', 'lane_run']))
known = ('link_push_column', 'bind_begin', 'link_add_name', 'bind_join_block', 'bind_join_records', 'runtime_piece_hash')
first_toucher = {}
names = {}
window = collections.defaultdict(list)
for i, s in enumerate(samples):
    mp = mapping(mmaps, s['addr'], s['t'])
    base = mp[0] if mp else 0
    names[base] = mp[2] if mp else '?'
    if base not in first_toucher:
        for f in s['chain']:
            hit = next((n for n in known if n in f), None)
            if hit:
                first_toucher[base] = hit
                break
    if first <= i < end:
        window[base].append(s)
def owner(base):
    name = names[base]
    if name.endswith('.snapshot'):
        return 'the runtime snapshot (file)'
    if name != '//anon':
        return 'the compiler\'s own image (file)'
    toucher = first_toucher.get(base)
    if toucher == 'link_push_column':
        return 'the link\'s columns (first faulted by link_initialize)'
    if toucher == 'bind_begin':
        return 'Bind\'s arrays (first faulted by bind_begin)'
    if all(has(s, ['bind_join_block', 'bind_join_records']) for s in window[base]):
        return 'the program\'s byte arena (only the joins fault it)'
    return 'unknown'
total = sum(len(v) for v in window.values())
print('stage window: %d faults' % total)
print('mapping\tfaults\tdistinct 4 KB pages\towner\tfile')
for base, ss in sorted(window.items(), key=lambda kv: -len(kv[1])):
    pages = len(set(s['addr'] >> 12 for s in ss))
    print('%x\t%d\t%d\t%s\t%s' % (base, len(ss), pages, owner(base), names[base].rsplit('/', 1)[-1]))

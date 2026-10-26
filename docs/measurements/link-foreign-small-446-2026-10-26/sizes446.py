#!/usr/bin/env python3
# sizes446.py TRACE OUT DIRS...: #446's sizes list: for each kept benchmark-link directory links-N (N workers, its
# objects/unit_*.o), the dynamic PIE's threaded command line of the traced 2,000-worker link with that program's objects,
# by main's and the head's archived executables, 21 runs after a warm-up, with benchmark-link's pause: 20 ms, or 200 ms
# for an output past 4 MB (200 workers' units of about 300 bytes of output per worker).
import glob
import os
import re
import sys

trace, out = sys.argv[1], sys.argv[2]
H = '/home/david/buster-fast-bench'
D = H + '/perf-445-446-claude'
exes = {'base': H + '/build-270-claude/ab3/base/build/compiler', 'head': H + '/build-270-claude/ab3/head/build/compiler'}
template = None
for line in open(trace):
    m = re.match(r'(\d+) execve\("([^"]*)", \[(.*?)\], \[', line)
    if not m:
        continue
    args = re.findall(r'"((?:[^"\\]|\\.)*)"', m.group(3))
    objects = [a for a in args if a.endswith('.o') and '/objects/' in a]
    if len(args) > 1 and args[1] == 'link-foreign' and '--lanes=8' in args and '-static' not in args and len(objects) == 10:
        template = args
        break
first = next(i for i, a in enumerate(template) if a.endswith('.o') and '/objects/' in a)
last = max(i for i, a in enumerate(template) if a.endswith('.o') and '/objects/' in a)
events = 'events=task-clock:cycles:instructions:context-switches:cpu-migrations:page-faults'
lines = ['# #446\'s sizes: the traced 2,000-worker dynamic PIE\'s command line, its threads unpinned, with each program\'s',
         '# objects (links-N), by main 51ab0b63 (base) and head 6847c1db, 21 runs after a warm-up.']
for directory in sys.argv[3:]:
    workers = int(directory.rsplit('-', 1)[1])
    kept = glob.glob(os.path.join(D, directory, 'buster-link-benchmark-*', 'objects'))
    assert len(kept) == 1, directory
    count = len(glob.glob(os.path.join(kept[0], 'unit_*.o')))
    objects = [os.path.join(kept[0], f'unit_{u}.o') for u in range(count)]
    pause = 200 if workers * 300 > (4 << 20) else 20
    for t in ('base', 'head'):
        label = f'{t}-dyn{workers}-threads'
        args = template[:first] + objects + template[last + 1:]
        args[0] = exes[t]
        o = args.index('-o')
        args[o + 1] = f'{D}/links-out/{label}'
        lines.append(f'{label}|runs=21,warmups=1,pause={pause},{events}|{" ".join(args)}')
open(out, 'w').write('\n'.join(lines) + '\n')
print(len(lines) - 2, 'commands')

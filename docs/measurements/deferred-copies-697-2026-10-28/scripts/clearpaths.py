#!/usr/bin/env python3
# perf script -F pid,tid,ip,sym output (with -g): the clear_page_erms samples by thread (the main thread, which is the
# first lane, or another lane), by the fault path that cleared the page (a huge page for an untouched region,
# do_huge_pmd_anonymous_page; a huge page in place of the huge zero page, do_huge_pmd_wp_page; a base page,
# do_anonymous_page; a page the advice committed, madvise; other), with each thread's and path's total, and by the first
# user frame under it.
import sys, collections
counts = collections.Counter(); totals = collections.Counter()
role = None; frames = []
def path(fs):
    for name, key in (('do_huge_pmd_anonymous_page', 'huge, untouched'), ('do_huge_pmd_wp_page', 'huge, zero page'),
                      ('madvise', 'committed'), ('do_anonymous_page', 'base'), ('do_wp_page', 'base, zero page')):
        if any(name in f for k, f in fs if k):
            return key
    return 'other'
def flush():
    global frames
    if role is not None and frames:
        totals[role] += 1
        if frames[0][1] == 'clear_page_erms':
            user = next((f for k, f in frames if not k), '?')
            counts[(role, path(frames), user)] += 1
    frames = []
for line in sys.stdin:
    s = line.strip()
    if not s:
        flush(); continue
    parts = s.split()
    if '/' in parts[0] and not frames:
        pid, tid = parts[0].split('/')
        role = 'main' if pid == tid else 'lane'
        continue
    if len(parts) >= 2:
        frames.append((parts[0].startswith('ffffffff'), parts[1]))
flush()
print('samples: main %d, lanes %d' % (totals['main'], totals['lane']))
paths = collections.Counter()
for (r, p, u), n in counts.items():
    paths[(r, p)] += n
for (r, p), n in sorted(paths.items()):
    print('total %5d %-4s %s' % (n, r, p))
for (r, p, u), n in sorted(counts.items(), key=lambda x: (-x[1])):
    if n >= 2:
        print('%5d %-4s %-16s %s' % (n, r, p, u))

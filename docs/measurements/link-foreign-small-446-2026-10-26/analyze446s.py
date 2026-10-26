#!/usr/bin/env python3
# analyze446s.py switches-base.txt switches-head.txt: #446's context switches by where they happen. Each file is perf
# script's text of every context switch of 22 link-foreign processes (switches446.sh); the first process of each is a
# warm-up and is left out. A switch is classified by the kernel function that blocked (the first kernel frame past the
# scheduler's own) and by the innermost frame of the compiler's code (or the C library's, when no compiler frame is
# found), and counted per process: per label, each class's mean per process, then the classes that differ most.
import collections
import re
import sys

SCHEDULER = re.compile(r'^(__schedule|schedule|schedule_preempt_disabled|schedule_timeout|schedule_hrtimeout_range_clock|'
                       r'schedule_hrtimeout_range|io_schedule|preempt_schedule\w*|__cond_resched|_cond_resched|'
                       r'perf_\w+|__perf_\w+|ctx_sched_out|task_ctx_sched_out|perf_event_task_sched_out|'
                       r'prepare_task_switch|finish_task_switch\.isra\.0|finish_task_switch)$')


def samples(path):
    sample = None
    for line in open(path, errors='replace'):
        if not line.strip():
            if sample:
                yield sample
            sample = None
            continue
        if not line[0].isspace():
            if sample:
                yield sample
            m = re.match(r'\s*(\S+)\s+(\d+)/(\d+)\s+([\d.]+):', line)
            sample = {'pid': int(m.group(2)), 'tid': int(m.group(3)), 'time': float(m.group(4)), 'frames': []} if m else None
            continue
        if sample is not None:
            m = re.match(r'\s+([0-9a-f]+)\s+(.*?)\s+\((.*)\)\s*$', line)
            if m:
                symbol = re.sub(r'\+0x[0-9a-f]+$', '', m.group(2))
                sample['frames'].append((symbol, m.group(3)))
    if sample:
        yield sample


def classify(frames):
    kernel = [s for s, dso in frames if 'kernel' in dso]
    user = [(s, dso) for s, dso in frames if 'kernel' not in dso]
    blocked = next((s for s in kernel if not SCHEDULER.match(s)), kernel[-1] if kernel else '-')
    own = next((s for s, dso in user if dso.endswith('/compiler')), None)
    library = next((s for s, dso in user if 'libc' in dso or 'ld-linux' in dso), None)
    return blocked, own or (f'[{library}]' if library else '-')


results = {}
for path in sys.argv[1:]:
    label = re.search(r'switches-(\w+)\.txt', path).group(1)
    by_pid = collections.defaultdict(list)
    for sample in samples(path):
        by_pid[sample['pid']].append(sample)
    pids = sorted(by_pid, key=lambda p: min(s['time'] for s in by_pid[p]))[1:]
    counts = collections.Counter()
    per_thread = collections.Counter()
    for pid in pids:
        for sample in by_pid[pid]:
            counts[classify(sample['frames'])] += 1
        per_thread[len({s['tid'] for s in by_pid[pid]})] += 1
    results[label] = (len(pids), counts, sum(len(by_pid[p]) for p in pids))
    print(f'{label}: {len(pids)} processes, {sum(len(by_pid[p]) for p in pids) / len(pids):.1f} switches each; threads that switched, per process: {dict(sorted(per_thread.items()))}')

print()
labels = list(results)
classes = set()
for _, counts, _ in results.values():
    classes |= set(counts)
rows = []
for c in classes:
    means = [results[l][1][c] / results[l][0] for l in labels]
    rows.append((max(means) - min(means), c, means))
print(f'{"blocked in":34s} {"compiler frame":44s} ' + ' '.join(f'{l:>7s}' for l in labels))
for _, c, means in sorted(rows, key=lambda r: (-max(r[2]), r[1]))[:40]:
    print(f'{c[0][:34]:34s} {c[1][:44]:44s} ' + ' '.join(f'{m:7.2f}' for m in means))

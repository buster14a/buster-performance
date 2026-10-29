#!/usr/bin/env python3
"""One contention-controlled batch of independent SQLite object compiles."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile
import time

p = argparse.ArgumentParser()
p.add_argument('--compiler', required=True)
p.add_argument('--corpus', required=True)
p.add_argument('--workers', required=True, type=int)
p.add_argument('--tasks', required=True, type=int)
p.add_argument('--scratch', default='/dev/shm')
a = p.parse_args()
if a.workers < 1 or a.tasks < a.workers:
    raise SystemExit('invalid task/worker count')
allowed = sorted(os.sched_getaffinity(0))
cpus = []
seen = set()
for cpu in allowed:
    pth = Path(f'/sys/devices/system/cpu/cpu{cpu}/topology/thread_siblings_list')
    siblings = pth.read_text().strip() if pth.exists() else str(cpu)
    if siblings not in seen:
        cpus.append(cpu)
        seen.add(siblings)
if len(cpus) < a.workers:
    raise SystemExit('not enough physical cores in granted affinity')
cpus = cpus[:a.workers]
compiler = str(Path(a.compiler).resolve())
corpus = Path(a.corpus).resolve()
env = os.environ.copy()
env.update({'SOURCE_DATE_EPOCH': '1792454400', 'LC_ALL': 'C'})
for var in ('CPATH', 'C_INCLUDE_PATH'):
    env.pop(var, None)
base = [compiler, '--lanes', '1', '-c', '--predefines', str(corpus / 'provenance/gnu17-pinned-predefines.txt'),
        '--clang-features', '-march=znver5', '-std=gnu17', '-nostdinc',
        '-isystem', str(corpus / 'headers/usr/lib/clang/23/include'),
        '-isystem', str(corpus / 'headers/usr/local/include'),
        '-isystem', str(corpus / 'headers/usr/include'), '-I' + str(corpus / 'sqlite'),
        str(corpus / 'sqlite/sqlite3.c')]
with tempfile.TemporaryDirectory(prefix='buster-scaling-', dir=a.scratch) as tmp:
    running = {}
    completed = []
    next_task = 0
    start = time.monotonic_ns()
    while len(completed) < a.tasks:
        free = [c for c in cpus if c not in (x[2] for x in running.values())]
        for cpu in free:
            if next_task >= a.tasks:
                break
            obj = Path(tmp) / f'{next_task:04d}.o'
            err = Path(tmp) / f'{next_task:04d}.err'
            err_handle = err.open('wb')
            def affinity(cpu=cpu):
                os.sched_setaffinity(0, {cpu})
            proc = subprocess.Popen([*base, '-o', str(obj)], stdout=subprocess.DEVNULL, stderr=err_handle,
                                    preexec_fn=affinity, env=env)
            running[proc.pid] = (proc, next_task, cpu, obj, err, err_handle)
            next_task += 1
        pid, status, ru = os.wait4(-1, 0)
        proc, index, cpu, obj, err, err_handle = running.pop(pid)
        proc.returncode = os.waitstatus_to_exitcode(status)
        err_handle.close()
        completed.append({'index': index, 'cpu': cpu, 'status': os.waitstatus_to_exitcode(status),
                          'user_s': ru.ru_utime, 'system_s': ru.ru_stime, 'rss_kb': ru.ru_maxrss,
                          'minor_faults': ru.ru_minflt, 'major_faults': ru.ru_majflt,
                          'voluntary_switches': ru.ru_nvcsw, 'involuntary_switches': ru.ru_nivcsw,
                          'object': obj, 'stderr': err})
    wall_s = (time.monotonic_ns() - start) / 1e9
    hashes = []
    failures = []
    for item in completed:
        obj, err = item.pop('object'), item.pop('stderr')
        if item['status'] != 0 or not obj.exists():
            failures.append({'index': item['index'], 'status': item['status'], 'stderr': err.read_text(errors='replace')})
        else:
            hashes.append(hashlib.sha256(obj.read_bytes()).hexdigest())
    result = {'workers': a.workers, 'tasks': a.tasks, 'cpus': cpus, 'wall_s': wall_s,
              'source_bytes_per_task': (corpus / 'sqlite/sqlite3.c').stat().st_size,
              'throughput_MB_s': (corpus / 'sqlite/sqlite3.c').stat().st_size * (a.tasks-len(failures)) / wall_s / 1e6,
              'unique_output_hashes': sorted(set(hashes)), 'failures': failures, 'children': completed}
    print(json.dumps(result))
    if failures:
        raise SystemExit(1)

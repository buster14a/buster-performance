#!/usr/bin/env python3
# runs.py N WORKERS -- env... -- command...: N rounds of WORKERS concurrent runs; prints medians of wall, user, sys, faults, maxrss.
import os, sys, time, resource, statistics, subprocess
n = int(sys.argv[1]); workers = int(sys.argv[2])
rest = sys.argv[3:]
assert rest[0] == '--'
rest = rest[1:]
split = rest.index('--')
env = dict(os.environ)
for kv in rest[:split]:
    k, v = kv.split('=', 1); env[k] = v
cmd = rest[split + 1:]
rows = []
for r in range(n):
    pids = {}
    t0 = time.monotonic()
    for w in range(workers):
        c = [a.replace('%w', str(w)) for a in cmd]
        pid = os.fork()
        if pid == 0:
            os.sched_setaffinity(0, {w % os.cpu_count()})
            dn = os.open('/dev/null', os.O_WRONLY); os.dup2(dn, 2); os.dup2(dn, 1)
            os.execvpe(c[0], c, env)
        pids[pid] = time.monotonic()
    for _ in range(workers):
        pid, status, ru = os.wait4(-1, 0)
        t1 = time.monotonic()
        assert status == 0, status
        rows.append((t1 - pids[pid], ru.ru_utime, ru.ru_stime, ru.ru_minflt, ru.ru_maxrss))
med = lambda i: statistics.median(x[i] for x in rows)
print(f"wall {med(0)*1000:8.1f} ms  user {med(1)*1000:8.1f} ms  sys {med(2)*1000:8.1f} ms  faults {int(med(3)):7d}  maxrss {med(4)/1024:7.1f} MB  ({len(rows)} runs)")

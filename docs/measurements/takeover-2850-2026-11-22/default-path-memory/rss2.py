import os, sys, time, statistics
setting = sys.argv[1]; rounds = int(sys.argv[2]); args = sys.argv[3:]
env = dict(os.environ)
if setting != '0': env['PROTO_NO_DISCARD'] = setting
rows = []
for i in range(rounds):
    start = time.perf_counter()
    pid = os.fork()
    if pid == 0:
        os.sched_setaffinity(0, {2})
        os.execve(args[0], args, env)
    _, status, usage = os.wait4(pid, 0)
    rows.append((1000 * (time.perf_counter() - start), 1000 * usage.ru_utime, 1000 * usage.ru_stime, usage.ru_maxrss / 1024, usage.ru_minflt))
med = lambda k: statistics.median(r[k] for r in rows)
print(f'discards off={setting}: wall {med(0):7.1f} ms  user {med(1):6.1f}  sys {med(2):5.1f}  peak {med(3):6.1f} MB  faults {med(4):.0f}   (medians of {rounds})')

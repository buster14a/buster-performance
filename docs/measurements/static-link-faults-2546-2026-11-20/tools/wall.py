import sys, os, subprocess, time, statistics, resource
# wall.py ROUNDS NAME=CMD... -- ARGS: interleaved whole-process runs; medians of wall ms, and minor faults (rusage).
rounds = int(sys.argv[1])
i = sys.argv.index('--')
configs = [c.split('=', 1) for c in sys.argv[2:i]]
args = sys.argv[i + 1:]
res = {n: ([], []) for n, _ in configs}
for r in range(rounds):
    for name, cmd in configs:
        env = dict(os.environ, XDG_CACHE_HOME=os.path.join(os.getcwd(), 'cache-' + name))
        before = resource.getrusage(resource.RUSAGE_CHILDREN)
        t0 = time.perf_counter()
        subprocess.run(([] if os.environ.get('NOPIN') else ['taskset', '-c', '3']) + [cmd] + args, env=env, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=True)
        t1 = time.perf_counter()
        after = resource.getrusage(resource.RUSAGE_CHILDREN)
        res[name][0].append((t1 - t0) * 1000)
        res[name][1].append(after.ru_minflt - before.ru_minflt)
for name, _ in configs:
    w, f = res[name]
    print('%-5s n=%d wall median %.2f ms (min %.2f) minflt median %d' % (name, len(w), statistics.median(w), min(w), statistics.median(f)))

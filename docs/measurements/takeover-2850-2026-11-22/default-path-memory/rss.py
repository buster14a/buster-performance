import os, sys, resource, time
env = dict(os.environ)
setting = sys.argv[1]
if setting != 'default': env['BUSTER_HUGE_PAGES'] = setting
args = sys.argv[2:]
start = time.perf_counter()
pid = os.fork()
if pid == 0:
    os.execve(args[0], args, env)
_, status, usage = os.wait4(pid, 0)
wall = time.perf_counter() - start
print(f'huge={setting:8s} wall={1000*wall:7.1f} ms user={1000*usage.ru_utime:7.1f} sys={1000*usage.ru_stime:6.1f} maxrss={usage.ru_maxrss/1024:7.1f} MB minor={usage.ru_minflt}')

import os, resource, subprocess, sys, time
start = time.monotonic()
status = subprocess.run(["./build.sh"], env=dict(os.environ, LC_NUMERIC="C")).returncode
wall = time.monotonic() - start
usage = resource.getrusage(resource.RUSAGE_CHILDREN)
print("timed-build: status %d, wall %.2f s, user %.2f s, system %.2f s, cpu %.2f s, largest process %d KB" %
      (status, wall, usage.ru_utime, usage.ru_stime, usage.ru_utime + usage.ru_stime, usage.ru_maxrss))
sys.exit(status)

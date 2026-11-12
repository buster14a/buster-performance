import os, sys, subprocess
p = subprocess.Popen(sys.argv[1:], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
_, status, usage = os.wait4(p.pid, 0)
print(usage.ru_maxrss, os.waitstatus_to_exitcode(status))

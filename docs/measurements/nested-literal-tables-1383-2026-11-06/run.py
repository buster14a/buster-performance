#!/usr/bin/env python3
# usage: run.py cmd...; runs it, prints its output, then "RSS <kb>" and "WALL <us>" of the child
import os, subprocess, sys, time, resource
s = time.perf_counter_ns()
p = subprocess.run(sys.argv[1:], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
e = time.perf_counter_ns()
sys.stdout.write(p.stdout.decode(errors='replace'))
print("RSS", resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss)
print("WALL", (e - s) // 1000)
print("EXIT", p.returncode)

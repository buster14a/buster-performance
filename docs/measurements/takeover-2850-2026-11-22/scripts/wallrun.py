import os, resource, subprocess, sys, time
# wallrun.py STEM -- COMMAND...: one fresh process of COMMAND; STEM.wall has its elapsed nanoseconds (monotonic, around
# fork, exec and wait), STEM.faults its minor and major faults, STEM.status its exit status, STEM.stdout and STEM.stderr its output.
stem = sys.argv[1]
command = sys.argv[3:]
with open(stem + '.stdout', 'wb') as out, open(stem + '.stderr', 'wb') as err:
    start = time.monotonic_ns()
    status = subprocess.run(command, stdout=out, stderr=err).returncode
    end = time.monotonic_ns()
usage = resource.getrusage(resource.RUSAGE_CHILDREN)
open(stem + '.wall', 'w').write(f'{end - start}\n')
open(stem + '.faults', 'w').write(f'{usage.ru_minflt} {usage.ru_majflt}\n')
open(stem + '.status', 'w').write(f'{status}\n')

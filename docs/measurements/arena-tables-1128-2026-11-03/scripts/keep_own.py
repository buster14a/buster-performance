import re, sys
# Keeps only the line shapes this record's own scripts and tools print (time-runs, strace -c, build.sh, benchmark-check-units,
# --time-stages' greps, receipts): the host lock's waiting messages, which name other sessions, are dropped.
own = re.compile(r'^(memory: wait4|run [0-9]+ list [0-9]+|list [0-9]+|  (main|head): [0-9]+ runs, median|time-runs: |strace (main|head) [0-9]+ status|% time|-{6} |\s*[0-9]+\.[0-9]+ +[0-9]+\.[0-9]+ +[0-9]+ +[0-9]+|100\.00 |== benchmark-check-units of (main|head)$|check units|status [0-9-]+$|[0-9a-f]{64}  /|build\.sh: |time-stage\t|time-process\t(user|system)-ms|[0-9]+\.[0-9]+\.[0-9]+-[0-9]+-lts$|clang version|strace -- version|[0-2]$|\[always\] madvise never$|build [a-z0-9-]+ [0-9]+$|(lua|synth|bench|prof) [0-9]+ ?$|done$)')
for line in open(sys.argv[1], errors='replace'):
    if own.match(line):
        sys.stdout.write(line)

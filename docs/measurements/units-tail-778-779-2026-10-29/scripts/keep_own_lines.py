#!/usr/bin/env python3
# Keeps the lines of a log that this record's scripts and the tools they run print, and drops every other line: the
# 9700X lock's waiting messages name other sessions' jobs, and a holder's command can span many lines.
# Usage: keep_own_lines.py < LOG > FILTERED
import re
import sys

OWN = re.compile(
    r"^(build\.sh: [0-9]+ sources compiled"
    r"|[0-9a-f]{64}  /home/david/buster-fast-bench/units-152-claude/"
    r"|== "
    r"|test-[a-z-]+( --[a-z-]+)*( [^ ]+)*: status [0-9]+$"
    r"|(check units|checker-driver|check debug|check lanes|check units|test-call-graph|call graph|worker budget): "
    r"|  (programs|diagnostics|refusals|merge|shared parts|jobserver|unstarted|corpus|backend startup|squeezes|driver): "
    r"|allowed cycle: main_unit_frontend\.ll:preprocessor_fuzz_"
    r"|status=[0-9]+$"
    r"|list [0-9]+: [0-9]+ runs, median "
    r"|time-runs: "
    r"|time-stage\t|time-process\t|time-write\t"
    r"|(synth|lua) link, (--lanes [0-9]+( plain| -g)?|(ccad|t778), --lanes [0-9]+), run [0-9]+$"
    r"|(c|syntax|exe) (t763|copy|t779|t778) round [0-9] status=[0-9]+$"
    r"|objects: "
    r"|perf-[a-z]+-[a-z0-9]+-r[0-9]\.csv: "
    r"|(ev778|st778|musl778)-finished$"
    r"|42$|463170394$"
    r")"
)

for line in sys.stdin:
    if OWN.match(line):
        sys.stdout.write(line)

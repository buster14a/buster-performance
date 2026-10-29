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
    r"|  (programs|diagnostics|refusals|unstarted|corpus): "
    r"|check units: "
    r"|status=[0-9]+$"
    r"|call graph: "
    r"|list [0-9]+ \[-c "
    r"|time-runs: "
    r"|time-stage\t|time-process\t"
    r"|(synth|lua) link, --lanes [0-9]+, run [0-9]+$"
    r"|(c|syntax|exe) (main|copy|head) round [0-9] status=[0-9]+$"
    r"|objects: "
    r"|perf-[a-z]+-[a-z]+-r[0-9]\.csv: "
    r"|(final2?|ab|stages|synth2|after)-finished$|finished$"
    r"|42$|463170394$"
    r"|    [0-9]+ error: "
    r"|record8 status|stat[18] status|strace8 status|profile-finished"
    r")"
)
# Inside a time-runs list whose names its command line spread over lines (measure.sh's first synth run): its own units.
CONTINUATION = re.compile(r"^/home/david/buster-fast-bench/units-152-claude/explore/synth/unit_[0-9]+\.c(\]: .*)?$")

for line in sys.stdin:
    if OWN.match(line) or CONTINUATION.match(line):
        sys.stdout.write(line)

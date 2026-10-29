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
    r"|test-[a-z-]+( --[a-z-]+)*( [^ ]+)*: (status [0-9]+|passed)$"
    r"|(check units|checker-driver|check debug|check lanes|test-call-graph|call graph|worker budget|teams|part ranges|arenas): "
    r"|  (programs|diagnostics|refusals|merge|shared parts|jobserver|unstarted|corpus|backend startup|squeezes|driver): "
    r"|[0-9] lanes?: +ranges [0-9]+ checked"
    r"|allowed cycle: main_unit_frontend\.ll:preprocessor_fuzz_"
    r"|memory: [0-9]+ runs short"
    r"|shared parts: [0-9]+ taken by lanes without units$"
    r"|-c of both at once: |linked by default and by one lane: "
    r"|lists: |       [0-9]+-[0-9]+ linked by"
    r"|musl: [0-9]+ units$"
    r"|status=[0-9]+$"
    r"|list [0-9]+: [0-9]+ runs, median "
    r"|time-runs: "
    r"|time-stage\t|time-process\t|units-walk\t"
    r"|(lua|synth|musl) (plain|--units-walk) run [0-9]+$"
    r"|benchmark-files: [0-9]+ roots|one command team, reused|lanes  run ms|a run: [0-9]+ rounds|unused: [0-9]+ of the"
    r"| +[0-9] +[0-9.]+ +[0-9.]+ +[0-9.]+ +[0-9.]+ "
    r"| +[0-9]+ tokens  /usr/"
    r"|(units|alone) run [0-9]+$"
    r"|[0-9]+ /home/david/buster-fast-bench/claude-linker-80/inputs/sqlite-amalgamation-3530400/"
    r"|(ev777|ev776|aa777|sl777|pr777st)-finished$"
    r"|42$|463170394$"
    r")"
)

for line in sys.stdin:
    if OWN.match(line):
        sys.stdout.write(line)

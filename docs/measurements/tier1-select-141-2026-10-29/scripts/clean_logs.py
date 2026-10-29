#!/usr/bin/env python3
# Copies the 9700X run's logs into the record, without the shared lock's messages, which name other sessions' and CI
# jobs' commands and links. A locked log starts with exclusive.sh's one waiting message (its holder's owner file: a
# command, possibly over several lines, and title, link and pull request lines): the copy starts at the first line the
# logged command itself prints. The benchmark's own logs (bench/full-*, bench/after-*, shifts/main-* and the rest) were
# written inside their holds and have none; all.out and shifts.out keep only the lines the scripts print. Usage:
# clean_logs.py SOURCE DESTINATION.
import os
import re
import shutil
import sys

source, destination = sys.argv[1], sys.argv[2]

# The first line each locked log's command prints.
first_lines = [
    (re.compile(r"^(shifts-)?build-[a-z]+-[0-9a-f]+\.log$"), re.compile(r"^build\.sh: ")),
    (re.compile(r"^tests/testtier1allocation\.log$"), re.compile(r"^test-tier1-allocation: ")),
    (re.compile(r"^tests/testtier1emit\.log$"), re.compile(r"^tier1 fragment emission: ")),
    (re.compile(r"^tests/testtier1frameexecution\.log$"), re.compile(r"^tier1 frame execution: ")),
    (re.compile(r"^tests/testtier1liveness\.log$"), re.compile(r"^Tier 1 selected-use liveness: ")),
    (re.compile(r"^tests/testtier1pipelinecrosscheck\.log$"), re.compile(r"^tier1 pipeline: ")),
    (re.compile(r"^tests/testtier1select\.log$"), re.compile(r"^tier1 selection: ")),
    (re.compile(r"^tests/testx86semantics\.log$"), re.compile(r"^x86 semantics: ")),
    (re.compile(r"^bench/round-[0-9]+\.log$"), re.compile(r"^(full|after) ")),
    (re.compile(r"^shifts/round-[0-9]+\.log$"), re.compile(r"^(main|head|again) [0-9]+ ")),
]
# The lines the scripts print themselves.
own = re.compile(
    r"^(== (build|shifts) [a-z]+-[0-9a-f]+ \S+$|(build|shifts) \S+ failed$|build\.sh: |[0-9a-f]{64}  /home/david/buster-fast-bench/tier1-select-141-claude/|"
    r"test[a-z0-9]+: exit [0-9]+, |(full|after) [a-z]+-[0-9a-f]+ [0-9]+ [0-9]+$|round [0-9]+ runs ok: [0-9]+$|(all|shifts) done \S+$)"
)

for root, _, files in os.walk(source):
    for name in sorted(files):
        path = os.path.join(root, name)
        relative = os.path.relpath(path, source)
        target = os.path.join(destination, relative)
        os.makedirs(os.path.dirname(target), exist_ok=True)
        rule = next((first for pattern, first in first_lines if pattern.match(relative)), None)
        if relative in ("all.out", "shifts.out"):
            with open(path) as f:
                kept = [line for line in f if own.match(line)]
            with open(target, "w") as f:
                f.writelines(kept)
        elif rule is not None:
            with open(path) as f:
                lines = f.readlines()
            start = next(i for i, line in enumerate(lines) if rule.match(line))
            kept = lines[start:]
            if any(line.startswith("exclusive.sh: ") for line in kept):
                sys.exit(f"clean_logs.py: {relative} has a lock message after its first line")
            with open(target, "w") as f:
                f.writelines(kept)
        else:
            with open(path, "rb") as f:
                data = f.read()
            if b"exclusive.sh: waiting" in data:
                sys.exit(f"clean_logs.py: {relative} has a lock message and no rule")
            shutil.copyfile(path, target)

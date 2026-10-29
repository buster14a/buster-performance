#!/usr/bin/env python3
# Copies the 9700X run's logs into the record, without the shared lock's messages, which name other sessions' and CI
# jobs' commands and links. A locked log starts with exclusive.sh's one waiting message (its holder's owner file: a
# command, possibly over several lines, and title, link and pull request lines): the copy starts at the first line the
# logged command itself prints. all.out keeps only the lines all.sh prints. Usage: clean_logs.py SOURCE DESTINATION.
import os
import re
import sys

source, destination = sys.argv[1], sys.argv[2]

# The first line each locked log's command prints.
first_lines = [
    (re.compile(r"^build-[a-z0-9-]+\.log$"), re.compile(r"^build\.sh: ")),
    (re.compile(r"^test-x86-zen5\.log$"), re.compile(r"^Zen 5 ")),
    (re.compile(r"^measure-[0-9]+\.log$"), re.compile(r"^# CPU=")),
    (re.compile(r"^compile\.log$"), re.compile(r"^[a-z]+-[0-9a-f]+ -c exit ")),
]
# The lines all.sh prints itself.
own = re.compile(
    r"^(== build [a-z]+-[0-9a-f]+ \S+$|build \S+ failed$|build\.sh: |[0-9a-f]{64}  /home/david/buster-fast-bench/x86-zen5-181-claude/|"
    r"test-x86-zen5 exit [0-9]+, |measure [0-9]+ exit [0-9]+$|[a-z]+-[0-9a-f]+ -c exit [0-9]+$|all done \S+$)"
)

for name in sorted(os.listdir(source)):
    path = os.path.join(source, name)
    if not os.path.isfile(path) or name.endswith(".o"):
        continue
    with open(path) as f:
        lines = f.read().splitlines(keepends=True)
    if name == "all.out":
        kept = [line for line in lines if own.match(line)]
    elif name == "receipt.txt":
        kept = lines
    else:
        start = None
        for pattern, first in first_lines:
            if pattern.match(name):
                start = next(i for i, line in enumerate(lines) if first.match(line))
        if start is None:
            sys.exit(f"clean_logs.py: no rule for {name}")
        kept = lines[start:]
        if any(line.startswith("exclusive.sh: ") for line in kept):
            sys.exit(f"clean_logs.py: {name} has a lock message after its first line")
    with open(os.path.join(destination, name), "w") as f:
        f.writelines(kept)

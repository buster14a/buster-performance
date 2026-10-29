#!/usr/bin/env python3
# Copies the 9700X run's logs into the record, without the shared lock's messages, which name other sessions' and CI
# jobs' commands and links. A locked log starts with exclusive.sh's one waiting message (its holder's owner file: a
# command, possibly over several lines, and title, link and pull request lines): the copy starts at the first line the
# logged command itself prints. The rounds' logs (sem/, target/, compile/) were written inside the holds and have no
# message; all.out keeps only the lines the scripts print. Usage: clean_logs.py SOURCE DESTINATION.
import os
import re
import shutil
import sys

source, destination = sys.argv[1], sys.argv[2]

# The first line each locked log's command prints.
first_lines = [
    (re.compile(r"^build-[a-z]+-[0-9a-f]+\.log$"), re.compile(r"^build\.sh: ")),
    (re.compile(r"^tests/testx86semantics(_crosscheck)?\.log$"), re.compile(r"^x86 semantics: ")),
    (re.compile(r"^tests/testx86target\.log$"), re.compile(r"^error: unknown target CPU ''$")),
    (re.compile(r"^tests/testchecker_programvectors\.log$"), re.compile(r"^  AVX512-FP16: |^test-checker: ")),
    (re.compile(r"^tests/testtier0\.log$"), re.compile(r"^moves ")),
    (re.compile(r"^tests/testassembler_crosscheck\.log$"), re.compile(r"^assembler ")),
]
# The lines the run's scripts print themselves.
own = re.compile(
    r"^(== build [a-z]+-[0-9a-f]+ \S+$|build \S+ failed$|build\.sh: |[0-9a-f]{64}  /home/david/buster-fast-bench/x86-semantics-760-claude/|"
    r"test[a-z0-9_]+: exit [0-9]+, |[a-z]+ done \S+$)"
)

for root, _, files in os.walk(source):
    for name in sorted(files):
        path = os.path.join(root, name)
        relative = os.path.relpath(path, source)
        if name.endswith(".o"):
            continue
        target = os.path.join(destination, relative)
        os.makedirs(os.path.dirname(target), exist_ok=True)
        rule = next((first for pattern, first in first_lines if pattern.match(relative)), None)
        if relative == "all.out":
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

#!/usr/bin/env python3
# Copies the 9700X run's logs into the record, without the shared lock's messages, which name other sessions' and CI
# jobs' commands and links. A locked log starts with exclusive.sh's one waiting message (its holder's owner file:
# a command, possibly over several lines, and title, link and pull request lines): the copy starts at the first line
# the logged command itself prints. The scripts' own outputs (all.out and the rest) keep only the lines the scripts
# print. Usage: clean_logs.py SOURCE DESTINATION.
import os
import re
import shutil
import sys

source, destination = sys.argv[1], sys.argv[2]

# The first line each locked log's command prints.
first_lines = [
    (re.compile(r"build-[a-z]+\.log$"), re.compile(r"^build\.sh: ")),
    (re.compile(r"tests/testx86semantics(_crosscheck)?\.log$"), re.compile(r"^x86 semantics: ")),
    (re.compile(r"tests/testassembler_crosscheck\.log$"), re.compile(r"^assembler ")),
    (re.compile(r"tests/testtier0\.log$"), re.compile(r"^moves ")),
]
# The lines the run's scripts print themselves.
own = re.compile(
    r"^(== build [a-z]+ \S+$|build \S+ failed$|build\.sh: |[0-9a-f]{64}  /home/david/buster-fast-bench/x86-semantics-221-claude/|"
    r"test[a-z0-9_]+: exit [0-9]+, |[a-z0-9]+ done \S+$|Verification Hash: |[a-z]+ didn't build$)"
)
script_outputs = {"all.out", "all-e22170c9.out", "variants2.out", "final.out"}

for root, _, files in os.walk(source):
    for name in files:
        path = os.path.join(root, name)
        relative = os.path.relpath(path, source)
        target = os.path.join(destination, relative)
        os.makedirs(os.path.dirname(target), exist_ok=True)
        with open(path, "rb") as f:
            data = f.read()
        if name in script_outputs:
            lines = data.decode().splitlines(keepends=True)
            kept = [line for line in lines if own.match(line)]
            with open(target, "w") as f:
                f.writelines(kept)
            continue
        if data.startswith(b"exclusive.sh: waiting"):
            pattern = next((first for log, first in first_lines if log.search(relative)), None)
            if pattern is None:
                sys.exit(f"{relative}: a locked log without a known first line")
            lines = data.decode().splitlines(keepends=True)
            start = next((i for i, line in enumerate(lines) if pattern.match(line)), None)
            if start is None:
                sys.exit(f"{relative}: its command's first line is missing")
            with open(target, "w") as f:
                f.writelines(lines[start:])
            continue
        shutil.copyfile(path, target)

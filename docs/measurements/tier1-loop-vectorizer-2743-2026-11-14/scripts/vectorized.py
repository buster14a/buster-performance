#!/usr/bin/env python3
"""vectorized.py BEFORE.o AFTER.o: the k_* functions whose instructions differ between two objects (objdump -d)."""
import re
import subprocess
import sys

def functions(path):
    text = subprocess.run(["objdump", "-d", "--no-show-raw-insn", path], capture_output=True, text=True, check=True).stdout
    result, name = {}, None
    for line in text.splitlines():
        m = re.match(r"^[0-9a-f]+ <(k_\w+)>:$", line)
        if m:
            name = m.group(1)
            result[name] = []
        elif re.match(r"^[0-9a-f]+ <", line):
            name = None
        elif name is not None:
            m = re.match(r"^\s*[0-9a-f]+:\s+(.*)$", line)
            if m:
                result[name].append(re.sub(r"[0-9a-f]+ <[^>]*>", "", m.group(1)))
    return result

before, after = functions(sys.argv[1]), functions(sys.argv[2])
for name in after:
    if before.get(name) != after[name]:
        print(name[2:])

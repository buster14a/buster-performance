#!/usr/bin/env python3
"""Audit static T/U/e instruction classes in saved tag streams and objdump text.

This is an instruction-shape check, not proof of control-flow origin or dynamic
behavior. It rejects ambiguous symbols and leaves every unknown shape visible.
"""
from collections import Counter, defaultdict
from pathlib import Path
import re
import sys

root = Path(sys.argv[1])
programs = ("sqlite-main-tagged", "sqlite-candidate-tagged", "lua-main-tagged", "lua-candidate-tagged")
symbol_line = re.compile(r"^[0-9a-fA-F]+ <(.*)>:$")
instruction_line = re.compile(r"^\s*[0-9a-fA-F]+:\s+(.+)$")


def operands(text):
    parts, start, depth = [], 0, 0
    for i, char in enumerate(text):
        depth += (char == "(") - (char == ")")
        if char == "," and depth == 0:
            parts.append(text[start:i].strip())
            start = i + 1
    parts.append(text[start:].strip())
    return parts


def classify(kind, instruction):
    ins = instruction.split("#", 1)[0].strip()
    fields = ins.split(None, 1)
    op = fields[0].lower()
    args = operands(fields[1]) if len(fields) == 2 else []
    isreg = lambda x: x.startswith("%")
    # rsp is unconditionally a stack base; rbp needs a separate frame-pointer proof.
    isstack = lambda x: bool(re.search(r"\(%rsp(?:,|\))", x))
    move = op.startswith(("mov", "vmov", "kmov"))
    if kind == "T" and ((move and len(args) == 2 and isreg(args[0]) and isstack(args[1])) or (op.startswith("fstp") and len(args) == 1 and isstack(args[0]))):
        return "stack-store"
    if kind == "U" and ((move and len(args) == 2 and isstack(args[0]) and isreg(args[1])) or (op.startswith("fld") and len(args) == 1 and isstack(args[0]))):
        return "stack-load"
    if kind == "e" and move and len(args) == 2 and all(isreg(x) for x in args):
        return "register-copy"
    return "UNKNOWN"


ok = True
for program in programs:
    directory = root / program
    functions = defaultdict(list)
    current = None
    for line in (directory / "elf.dis").read_text().splitlines():
        match = symbol_line.match(line)
        if match:
            current = []
            functions[match.group(1)].append(current)
        else:
            match = instruction_line.match(line)
            if match and current is not None:
                current.append(match.group(1))
    counts = Counter()
    bad = Counter()
    seen = set()
    for line in (directory / "tags.kinds").read_text().splitlines():
        if "\t" not in line:
            raise SystemExit(f"{program}: malformed tag row")
        name, tags = line.split("\t", 1)
        if name in seen or len(functions[name]) != 1:
            raise SystemExit(f"{program}: duplicate/missing symbol or tag row: {name}")
        seen.add(name)
        instructions = functions[name][0]
        if len(instructions) < len(tags):
            raise SystemExit(f"{program}: too few instructions for {name}")
        for index, (kind, instruction) in enumerate(zip(tags, instructions)):
            if kind in "TUe":
                classification = classify(kind, instruction)
                counts[kind, classification] += 1
                if classification == "UNKNOWN":
                    bad[kind, instruction] += 1
    print(program, "tagged_functions", len(seen))
    for kind in "TUe":
        print(" ", kind, "total", sum(value for (k, _), value in counts.items() if k == kind),
              "classes", dict((c, n) for (k, c), n in sorted(counts.items()) if k == kind))
    for (kind, instruction), n in sorted(bad.items()):
        print("  UNKNOWN", kind, n, instruction)
    ok &= not bad
if not ok:
    raise SystemExit(1)

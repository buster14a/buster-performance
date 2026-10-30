#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
"""Current #502 INSIDE derivative: one context-checked insertion, no execution.

Unlike the historical first-p2align matcher, this requires the unique page
alignment at the start of .text.buster_checker while that section is current.
Shift zero returns the exact original bytes; no retained/global marker is added.
Unknown section-stack/subsection constructs fail closed rather than guessing.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re

HOT = ".text.buster_checker"
SECTION = re.compile(r'^\s*\.section\s+(?:"([^"\\]+)"|([A-Za-z0-9_.$-]+))(?:\s*,.*)?$')
ALIGN = re.compile(r'^\s*\.p2align\s+12\s*$')


def transform(data: bytes, shift: int) -> tuple[bytes, dict]:
    if shift not in (0, 16, 64, 256, 1024, 2048):
        raise ValueError("shift must be one approved multiple of 16")
    lines = data.decode("utf-8").splitlines(keepends=True)
    section = None
    seen_content = False
    anchors = []
    for index, line in enumerate(lines):
        # Generated assembly comments cannot change section state.
        code = line.split("#", 1)[0].strip()
        if not code:
            continue
        if re.match(r'^\.(?:pushsection|popsection|previous|subsection|macro|endm|if[a-z]*|else|endif|rept|endr|irp|irpc|include|incbin)\b', code):
            raise ValueError("unsupported section stack/macro/conditional/include directive")
        match = SECTION.fullmatch(code)
        if match:
            section = match.group(1) or match.group(2)
            continue
        if re.match(r'^\.(?:text|data|bss)(?:\s+0)?$', code):
            section = code.split()[0]
            continue
        if code.startswith((".section", ".text", ".data", ".bss")) and not re.match(r'^\.(?:text|data|bss)[A-Za-z0-9_]', code):
            raise ValueError("unrecognized section-selection syntax")
        if section == HOT:
            if ALIGN.fullmatch(code):
                if seen_content:
                    raise ValueError("hot page alignment follows existing content")
                anchors.append(index)
            else:
                seen_content = True
    if len(anchors) != 1:
        raise ValueError(f"requires exactly one hot page-alignment anchor, found {len(anchors)}")
    anchor = anchors[0]
    if not lines[anchor].endswith("\n"):
        raise ValueError("hot anchor must end in a newline")
    if shift:
        lines.insert(anchor + 1, f"\t.skip\t{shift}\n")
        result = "".join(lines).encode("utf-8")
    else:
        result = data
    return result, {"hot_section": HOT, "shift": shift, "anchor_line": anchor + 1,
                    "input_sha256": hashlib.sha256(data).hexdigest(),
                    "output_sha256": hashlib.sha256(result).hexdigest(),
                    "zero_is_byte_identical": shift != 0 or result == data}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--shift", type=int, required=True)
    parser.add_argument("--receipt", type=Path, required=True)
    args = parser.parse_args()
    result, receipt = transform(args.input.read_bytes(), args.shift)
    with args.output.open("xb") as file:
        file.write(result)
    with args.receipt.open("x") as file:
        json.dump(receipt, file, indent=2)
        file.write("\n")


if __name__ == "__main__":
    main()

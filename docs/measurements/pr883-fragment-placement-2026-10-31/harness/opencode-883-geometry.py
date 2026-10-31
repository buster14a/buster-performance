#!/usr/bin/env python3
"""Record hot-section geometry and code-byte identity for every placement."""
import hashlib
import os
import re
import subprocess
import sys

ROOT = os.path.expanduser("~/buster-fast-bench/codex-883-takeover-20261031")
BUILDS = ["base", "base2", "candidate"]
SHIFTS = [0, 16, 64, 256, 1024, 2048]
SYMBOLS = ["check_lower_drain", "check_lower_batch_classify", "check_lower_fragment", "check_program_emit"]


def text_section(image):
    out = subprocess.check_output(["readelf", "-SW", image], text=True)
    for line in out.splitlines():
        if re.search(r"\] \.text ", line):
            fields = line.split()
            # [Nr] Name Type Address Off Size ES Flg Lk Inf Al
            return int(fields[3], 16), int(fields[4], 16), int(fields[5], 16)
    raise RuntimeError("no .text in " + image)


def symbols(image):
    out = subprocess.check_output(["readelf", "-sW", image], text=True)
    table = {}
    for line in out.splitlines():
        fields = line.split()
        if len(fields) >= 8 and fields[7] in SYMBOLS:
            table[fields[7]] = (int(fields[1], 16), int(fields[2], 16))
    return table


def dump_text(image, path):
    subprocess.check_call(["objcopy", "--dump-section", ".text=" + path, image])
    return open(path, "rb").read()


def main():
    records = {}
    for build in BUILDS:
        for shift in SHIFTS:
            image = os.path.join(ROOT, "place-" + build, "compiler-%d" % shift)
            addr, off, size = text_section(image)
            table = symbols(image)
            data = dump_text(image, "/tmp/opencode-883-text.bin")
            row = {"text_addr": addr, "text_size": size, "functions": {}}
            for name in SYMBOLS:
                if name not in table:
                    row["functions"][name] = None
                    continue
                value, fsize = table[name]
                start = value - addr
                blob = data[start:start + fsize]
                row["functions"][name] = {
                    "address": value,
                    "size": fsize,
                    "sha256": hashlib.sha256(blob).hexdigest(),
                }
            records[(build, shift)] = row
            print("%s\t%d\ttext=%x/%x\t%s" % (
                build, shift, addr, size,
                "\t".join("%s=%x/%d/%s" % (name, row["functions"][name]["address"], row["functions"][name]["size"], row["functions"][name]["sha256"][:16])
                          for name in SYMBOLS if row["functions"][name])))
    # Compare each function's bytes with the same build's shift 0.
    bad = 0
    for build in BUILDS:
        base = records[(build, 0)]
        for shift in SHIFTS:
            row = records[(build, shift)]
            for name in SYMBOLS:
                a = base["functions"].get(name)
                b = row["functions"].get(name)
                if (a is None) != (b is None) or (a and a["sha256"] != b["sha256"]):
                    print("MISMATCH %s %d %s" % (build, shift, name), file=sys.stderr)
                    bad += 1
    print("function-byte mismatches: %d" % bad)
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())

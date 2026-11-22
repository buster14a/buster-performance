"""Compare independent ELF files byte-for-byte and through standard ELF decoders."""
import argparse
import csv
import hashlib
from pathlib import Path
import subprocess
import sys

VIEWS = {
    "elf-header": ("readelf", "-hW"),
    "sections": ("readelf", "-SW"),
    "symbols": ("readelf", "-sW"),
    "relocations": ("readelf", "-rW"),
    "notes": ("readelf", "-nW"),
    "frames": ("readelf", "-wf"),
    "groups": ("readelf", "--section-groups", "-W"),
    "disassembly": ("objdump", "-drw"),
}


def views(path):
    result = {"all": path.read_bytes()}
    for name, cmd in VIEWS.items():
        data = subprocess.check_output([*cmd, path])
        if name == "disassembly":
            data = b"".join(data.splitlines(keepends=True)[3:])
        result[name] = data
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("reference", type=Path)
    parser.add_argument("candidate", type=Path, nargs="+")
    args = parser.parse_args()
    writer = csv.writer(sys.stdout, delimiter="\t")
    writer.writerow(("candidate", "view", "bytes", "reference-sha256", "candidate-sha256", "exact"))
    reference = views(args.reference)
    exact = True
    for path in args.candidate:
        for name, data in views(path).items():
            seen = data == reference[name]
            writer.writerow((path, name, len(data), hashlib.sha256(reference[name]).hexdigest(),
                             hashlib.sha256(data).hexdigest(), int(seen)))
            exact = exact and seen
    return int(not exact)


if __name__ == "__main__":
    raise SystemExit(main())

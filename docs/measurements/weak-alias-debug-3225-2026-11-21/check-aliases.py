"""Check repeatability and weak symbol metadata in Buster's ELF64 objects."""

import hashlib
from pathlib import Path
import struct
import subprocess
import sys


ALIASES = {
    "different_type": "object_target",
    "different_kind": "object_target",
    "object_alias": "function_target",
}
MODES = {
    "ordinary": [],
    "windowed-loop": ["--windowed-loop", "--emit-window=1"],
    "deferred": ["--deferred-bodies"],
}


def symbols(data):
    section_offset = struct.unpack_from("<Q", data, 40)[0]
    section_size, section_count = struct.unpack_from("<HH", data, 58)
    sections = [
        struct.unpack_from("<IIQQQQIIQQ", data, section_offset + i * section_size)
        for i in range(section_count)
    ]
    table = next(section for section in sections if section[1] == 2)  # SHT_SYMTAB
    names = sections[table[6]]  # sh_link selects the corresponding string table
    strings = data[names[4] : names[4] + names[5]]
    found = {}
    for offset in range(table[4], table[4] + table[5], table[9]):
        name_offset, info, _, section, value, size = struct.unpack_from("<IBBHQQ", data, offset)
        end = strings.find(b"\0", name_offset)
        if end >= 0:
            name = strings[name_offset:end]
            found[name] = (info >> 4, info & 15, section, value, size)
    return found


def broken_aliases(data):
    names = symbols(data)
    broken = set()
    for alias, target in ALIASES.items():
        actual = names.get(alias.encode())
        expected = names[target.encode()]
        if actual != (2, *expected[1:]) or expected[2] == 0:
            broken.add(alias)
    return broken


def main():
    compiler, source, directory, expected = sys.argv[1:]
    if expected not in ("pass", "fail"):
        raise SystemExit("Expected pass or fail as the last argument")
    destination = Path(directory)
    destination.mkdir(exist_ok=True)
    obj = destination / "unit.o"
    source = str(Path(source).resolve())
    saw_corrupt_debug_alias = False
    ok = True
    for debug in (False, True):
        for mode, flags in MODES.items():
            hashes = set()
            broken = set()
            command = [compiler, "-c", "--lanes", "1", "-std=gnu17"]
            if debug:
                command.append("-g")
            command += [*flags, source, "-o", str(obj)]
            for _ in range(4):
                subprocess.run(command, check=True, capture_output=True)
                data = obj.read_bytes()
                hashes.add(hashlib.sha256(data).hexdigest())
                broken.update(broken_aliases(data))
            if mode == "ordinary":
                reference_hashes = hashes
            print("debug" if debug else "ordinary", mode, len(hashes), "distinct SHA256s",
                  "broken=", ",".join(sorted(broken)) or "none")
            if expected == "pass" or not debug:
                ok &= len(hashes) == 1 and not broken and hashes == reference_hashes
            saw_corrupt_debug_alias |= debug and bool(broken)
    return ok and (expected == "pass" or saw_corrupt_debug_alias)


if __name__ == "__main__":
    sys.exit(0 if main() else 1)
